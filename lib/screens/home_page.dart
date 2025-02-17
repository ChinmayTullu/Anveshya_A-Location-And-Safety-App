import 'package:flutter/material.dart';
import 'package:person/screens/my_routes.dart';
import 'package:person/screens/nearest_chowki.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:uuid/uuid.dart';
import 'dart:async';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required String aadhaarNumber});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final WebViewController _controller;
  bool isLoading = false;
  bool isMapInitialized = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  StreamSubscription<Position>? _positionStreamSubscription;
  Position? _currentPosition;
  String _locationStatus = 'Waiting for location...';
  Timer? _locationUpdateTimer;

  @override
  void initState() {
    super.initState();
    _initializeLocation();
    _setupWebView();
  }

  void _setupWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {
            _initializeMap();
          },
        ),
      )
      ..loadRequest(Uri.parse('https://www.google.com/maps/search/?api=1&query=Thadomal+Shahani+Engineering+College+Mumbai'));
  }

  Future<void> _initializeMap() async {
    final String initMapScript = '''
      var map, marker;
      function initMap() {
        // Thadomal Shahani Engineering College coordinates
        var tsecLocation = new google.maps.LatLng(19.0522, 72.8295);
        
        map = new google.maps.Map(document.getElementById('map'), {
          center: tsecLocation,
          zoom: 17,
          mapTypeId: google.maps.MapTypeId.ROADMAP,
          disableDefaultUI: false,
          zoomControl: true,
          streetViewControl: false
        });
        
        // Create a marker for TSEC
        var tsecMarker = new google.maps.Marker({
          position: tsecLocation,
          map: map,
          title: 'Thadomal Shahani Engineering College'
        });
        
        // Create InfoWindow for TSEC
        var infoWindow = new google.maps.InfoWindow({
          content: 'Thadomal Shahani Engineering College, Mumbai'
        });
        
        // Show InfoWindow by default
        infoWindow.open(map, tsecMarker);
        
        // Create user location marker but don't set its position yet
        marker = new google.maps.Marker({
          map: map,
          title: 'Your Location',
          icon: {
            path: google.maps.SymbolPath.CIRCLE,
            scale: 10,
            fillColor: '#4285F4',
            fillOpacity: 1,
            strokeColor: '#ffffff',
            strokeWeight: 2,
          }
        });

        // Search for TSEC in the search box
        var searchBox = document.querySelector('input[name="q"]');
        if (searchBox) {
          searchBox.value = 'Thadomal Shahani Engineering College, Mumbai';
          searchBox.form.submit();
        }
      }
      initMap();
    ''';

    await _controller.runJavaScript(initMapScript);
    setState(() {
      isMapInitialized = true;
    });

    // If we already have a position, update the map
    if (_currentPosition != null) {
      _updateMapLocation(_currentPosition!);
    }
  }

  Future<void> _initializeLocation() async {
    try {
      await _checkLocationPermission();

      // Get initial position
      Position initialPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high
      );

      setState(() {
        _currentPosition = initialPosition;
        _locationStatus = 'Location: ${initialPosition.latitude}, ${initialPosition.longitude}';
      });

      if (isMapInitialized) {
        _updateMapLocation(initialPosition);
      }

      await _startLocationTracking();
    } catch (e) {
      setState(() {
        _locationStatus = 'Error initializing location: $e';
      });
    }
  }

  Future<void> _checkLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw 'Location services are disabled';
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw 'Location permissions are denied';
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw 'Location permissions are permanently denied';
    }
  }

  Future<void> _startLocationTracking() async {
    await _positionStreamSubscription?.cancel();

    _positionStreamSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    ).listen(
          (Position position) {
        setState(() {
          _currentPosition = position;
          _locationStatus = 'Location: ${position.latitude}, ${position.longitude}';
        });
        if (isMapInitialized) {
          _updateMapLocation(position);
        }
      },
      onError: (error) {
        setState(() {
          _locationStatus = 'Error tracking location: $error';
        });
      },
    );

    _locationUpdateTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      if (_currentPosition != null) {
        _updateLocationInFirestore(_currentPosition!);
      }
    });
  }

  Future<void> _updateMapLocation(Position position) async {
    final String javascript = '''
      var newPosition = new google.maps.LatLng(${position.latitude}, ${position.longitude});
      marker.setPosition(newPosition);
      map.panTo(newPosition);
    ''';

    await _controller.runJavaScript(javascript);
  }

  Future<void> _updateLocationInFirestore(Position position) async {
    try {
      await FirebaseFirestore.instance
          .collection('UserLocations')
          .doc('325695392002')
          .set({
        'latitude': position.latitude.toString(),
        'longitude': position.longitude.toString(),
        'timestamp': FieldValue.serverTimestamp(),
        'accuracy': position.accuracy,
        'altitude': position.altitude,
        'speed': position.speed,
        'speedAccuracy': position.speedAccuracy,
      }, SetOptions(merge: true));
    } catch (e) {
      print('Error updating location in Firestore: $e');
    }
  }

  void _openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  Future<void> _handleSOS() async {
    if (isLoading || _currentPosition == null) return;

    setState(() {
      isLoading = true;
    });

    try {
      String currentTime = DateTime.now().toIso8601String();

      final emergencyData = {
        'aadharCardNo': '325695392002',
        'location': {
          'latitude': _currentPosition!.latitude.toString(),
          'longitude': _currentPosition!.longitude.toString(),
        },
        'phoneNo': '9969736699',
        'resolved': false,
        'time': currentTime,
      };

      final String uniqueId = const Uuid().v4();

      await FirebaseFirestore.instance
          .collection('Emergency')
          .doc(uniqueId)
          .set(emergencyData);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Emergency alert sent successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error sending alert: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _positionStreamSubscription?.cancel();
    _locationUpdateTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        elevation: 16.0,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Chinmay Tullu\nGreetings!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _locationStatus,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.route),
              title: const Text('My Routes'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MyRoutesPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.location_on),
              title: const Text('Nearest Chowki'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NearestChowkiPage()),
                );
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        toolbarHeight: 50,
        backgroundColor: Colors.white,
        elevation: 2,
        leading: IconButton(
          icon: Icon(
            Icons.menu,
            color: Theme.of(context).primaryColor,
            size: 28,
          ),
          onPressed: _openDrawer,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                elevation: 3,
              ),
              onPressed: isLoading ? null : _handleSOS,
              child: isLoading
                  ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
                  : const Text(
                'SOS',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}