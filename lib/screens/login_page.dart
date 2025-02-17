import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:person/Messaging/msg_Logic.dart';
import 'home_page.dart';

class AadhaarLoginPage extends StatefulWidget {
  const AadhaarLoginPage({Key? key}) : super(key: key);

  @override
  _AadhaarLoginPageState createState() => _AadhaarLoginPageState();
}

class _AadhaarLoginPageState extends State<AadhaarLoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _aadhaarController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  bool _isLoading = false;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  final _aadhaarFormatter = MaskTextInputFormatter(
    mask: '#### #### ####',
    filter: {"#": RegExp(r'[0-9]')},
  );

  final _phoneFormatter = MaskTextInputFormatter(
    mask: '##### #####',
    filter: {"#": RegExp(r'[0-9]')},
  );

  Future<String?> _getFCMToken() async {
    try {
      NotificationSettings settings = await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        String? token = await _firebaseMessaging.getToken();
        print('FCM Token: $token');
        return token;
      } else {
        print('User declined notifications');
        return null;
      }
    } catch (e) {
      print('Error getting FCM token: $e');
      return null;
    }
  }

  Future<void> _saveFCMToken(String aadhaarNumber, String? fcmToken) async {
    if (fcmToken == null) return;

    try {
      await FirebaseFirestore.instance
          .collection('AadharCard')
          .doc(aadhaarNumber)
          .update({
        'fcmToken': fcmToken,
        'lastTokenUpdate': FieldValue.serverTimestamp(),
      });
      print('FCM token saved successfully');
    } catch (e) {
      print('Error saving FCM token: $e');
    }
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final aadhaarNumber = _aadhaarController.text.replaceAll(' ', '');
      final phoneNumber = _phoneController.text.replaceAll(' ', '');

      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      final docSnapshot = await firestore
          .collection('AadharCard')
          .doc(aadhaarNumber)
          .get();

      if (!docSnapshot.exists) {
        _showErrorSnackBar('Invalid Aadhaar number');
        return;
      }

      final storedPhoneNumber = docSnapshot.data()?['phone'] as String?;

      if (storedPhoneNumber == null || storedPhoneNumber != phoneNumber) {
        _showErrorSnackBar('Invalid phone number');
        return;
      }

      // Generate and save FCM token after successful validation
      final fcmToken = await _getFCMToken();
      await _saveFCMToken(aadhaarNumber, fcmToken);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login Successful'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(aadhaarNumber: aadhaarNumber),
        ),
      );

    } catch (e) {
      _showErrorSnackBar('An error occurred. Please try again.');
      print('Login error: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showErrorSnackBar(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 60),
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: const Color(0xFFAE9FEE).withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.person,
                      size: 80,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(height: 40),
                  TextFormField(
                    controller: _aadhaarController,
                    inputFormatters: [_aadhaarFormatter],
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Aadhaar Number',
                      hintText: '1234 5678 9012',
                      filled: true,
                      fillColor: const Color(0xFFAE9FEE).withOpacity(0.1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: Icon(
                        Icons.credit_card,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your Aadhaar number';
                      }
                      if (value.replaceAll(' ', '').length != 12) {
                        return 'Please enter a valid 12-digit Aadhaar number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _phoneController,
                    inputFormatters: [_phoneFormatter],
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      hintText: '98765 43210',
                      filled: true,
                      fillColor: const Color(0xFFAE9FEE).withOpacity(0.1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: Icon(
                        Icons.phone,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your phone number';
                      }
                      if (value.replaceAll(' ', '').length != 10) {
                        return 'Please enter a valid 10-digit phone number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: _isLoading
                          ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                          : Text(
                        'Login',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _aadhaarController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}