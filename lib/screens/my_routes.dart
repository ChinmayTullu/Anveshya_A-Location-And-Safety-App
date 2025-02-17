import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyRoutesPage extends StatelessWidget {
  const MyRoutesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Routes',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF8B5CF6),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 2,
      ),
      body: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? selectedRoute;

  final Map<String, List<CheckpointInfo>> routeCheckpoints = {
    'Thadomal': [
      CheckpointInfo(
          location: 'Home',
          time: '08:00 am',
          date: 'January 30, 2025',
          isReached: true,
          status: 'Left Home'),
      CheckpointInfo(
          location: 'Mira Road Station',
          time: '08:45 am',
          date: 'January 30, 2025',
          isReached: true,
          status: 'At Mira Road Station'),
      CheckpointInfo(
          location: 'Bandra Station',
          time: '09:30 am',
          date: 'January 30, 2025',
          isReached: true,
          status: 'At Bandra Station'),
      CheckpointInfo(
          location: 'Thadomal Shahani',
          time: '10:00 am',
          date: 'January 30, 2025',
          isReached: true,
          status: 'Reached Thadomal'),
    ],
    'Garden': [
      CheckpointInfo(
          location: 'Home',
          time: '02:00 pm',
          date: 'January 20, 2025',
          isReached: false,
          status: 'Left Home'),
      CheckpointInfo(
          location: 'MG Road',
          time: '02:30 pm',
          date: 'January 20, 2025',
          isReached: false,
          status: 'MG Road'),
      CheckpointInfo(
          location: 'Kanjurmarg Station',
          time: '03:15 pm',
          date: 'January 20, 2025',
          isReached: false,
          status: 'Kanjurmarg Station'),
      CheckpointInfo(
          location: 'Garden',
          time: '03:45 pm',
          date: 'January 20, 2025',
          isReached: false,
          status: 'Polly Garden'),
    ],
    'Borivali': [
      CheckpointInfo(
          location: 'Home',
          time: '12:00 pm',
          date: 'June 15 2019',
          isReached: true,
          status: 'TSEC'),
      CheckpointInfo(
          location: 'Kandivali Station',
          time: '12:45 pm',
          date: 'June 15 2019',
          isReached: false,
          status: 'Andheri'),
      CheckpointInfo(
          location: 'Borivali Station',
          time: '01:30 pm',
          date: 'June 15 2019',
          isReached: false,
          status: 'Kandivali'),
      CheckpointInfo(
          location: 'Borivali',
          time: '02:00 pm',
          date: 'June 15 2019',
          isReached: false,
          status: 'Borivali'),
    ],
  };

  void _toggleRoute(String routeName) {
    setState(() {
      if (selectedRoute == routeName) {
        selectedRoute = null;
      } else {
        selectedRoute = routeName;
      }
    });
  }

  void _navigateToAllRoutes(BuildContext context) {
    // Navigation logic for See All
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Explore!',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'See the routes you have taken',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 24),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final cardWidth = (constraints.maxWidth - 12) / 2;
                    return Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        ActionCard(
                          width: cardWidth,
                          color: const Color(0xFFE8E3FF),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.add, size: 20),
                              ),
                              const Spacer(),
                              const Text(
                                'Edit Your Routes',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>EditRoutesPage()));
                          },
                        ),
                        ActionCard(
                          width: cardWidth,
                          color: const Color(0xFFFFF8E3),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.route, size: 20),
                              ),
                              const Spacer(),
                              Row(
                                children: [
                                  const Expanded(
                                    child: Text(
                                      'Thadomal Route',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Text(
                                      'New',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          onTap: () => _toggleRoute('Thadomal'),
                        ),
                        ActionCard(
                          width: cardWidth,
                          color: Colors.black87,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.map, size: 20),
                              ),
                              const Spacer(),
                              const Text(
                                'Garden Route',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          onTap: () => _toggleRoute('Garden'),
                        ),
                      ],
                    );

                  },
                ),
                if (selectedRoute != null)
                  RoutePathSection(
                    checkpoints: routeCheckpoints[selectedRoute]!,
                    routeName: selectedRoute!,
                  ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Recent Search',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () => _navigateToAllRoutes(context),
                      child: const Text('See All'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const RecentSearchItem(
                  icon: Icons.route,
                  text: 'Route to Thadomal',
                  iconBackground: Color(0xFFE8E3FF),
                ),
                const SizedBox(height: 12),
                const RecentSearchItem(
                  icon: Icons.route,
                  text: 'Route to Borivali',
                  iconBackground: Color(0xFF333333),
                ),
                const SizedBox(height: 12),
                const RecentSearchItem(
                  icon: Icons.route,
                  text: 'Route to Kanjurmarg',
                  iconBackground: Color(0xFFFFF8E3),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CheckpointInfo {
  final String location;
  final String time;
  final String date;
  final bool isReached;
  final String status;

  const CheckpointInfo({
    required this.location,
    required this.time,
    required this.date,
    required this.isReached,
    required this.status,
  });
}

class ActionCard extends StatelessWidget {
  final Color color;
  final Widget child;
  final VoidCallback onTap;
  final double width;

  const ActionCard({
    super.key,
    required this.color,
    required this.child,
    required this.onTap,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        height: 120,
        child: child,
      ),
    );
  }
}

class RecentSearchItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color iconBackground;

  const RecentSearchItem({
    super.key,
    required this.icon,
    required this.text,
    required this.iconBackground,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconBackground,
            shape: BoxShape.circle,
          ),
          child: Icon(icon,
              size: 20,
              color: iconBackground == const Color(0xFF333333)
                  ? Colors.white
                  : Colors.black),
        ),
        const SizedBox(width: 12),
        Text(
          text,
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
        const Spacer(),
        const Icon(Icons.more_horiz),
      ],
    );
  }
}

class RoutePathSection extends StatelessWidget {
  final List<CheckpointInfo> checkpoints;
  final String routeName;

  const RoutePathSection({
    super.key,
    required this.checkpoints,
    required this.routeName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Route to $routeName',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: checkpoints.length,
            itemBuilder: (context, index) {
              final checkpoint = checkpoints[index];
              final isLast = index == checkpoints.length - 1;

              return IntrinsicHeight(
                child: Row(
                  children: [
                    SizedBox(
                      width: 30,
                      child: Column(
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: Colors.orange,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 3,
                              ),
                            ),
                          ),
                          if (!isLast)
                            Expanded(
                              child: Container(
                                width: 2,
                                color: Colors.orange,
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(bottom: isLast ? 0 : 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              checkpoint.status,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${checkpoint.date} • ${checkpoint.time}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 4),
                            if (checkpoint.location.isNotEmpty)
                              Text(
                                'Reached at ${checkpoint.location}, Mumbai',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class AddRouteForm extends StatefulWidget {
 // final Function(String, List<CheckpointInfo>) onSave;

  const AddRouteForm({Key? key,}) : super(key: key);

  @override
  _AddRouteFormState createState() => _AddRouteFormState();
}

class _AddRouteFormState extends State<AddRouteForm> {
  final _formKey = GlobalKey<FormState>();
  String routeName = '';
  List<CheckpointInfo> checkpoints = [];

  void _addCheckpoint() {
    setState(() {
      checkpoints.add(CheckpointInfo(
        location: '',
        time: '',
        date: '',
        isReached: false,
        status: '',
      ));
    });
  }

  void _saveRoute() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add New Route',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Route Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a route name';
                }
                return null;
              },
              onSaved: (value) {
                routeName = value!;
              },
            ),
            const SizedBox(height: 16),
            ...checkpoints.asMap().entries.map((entry) {
              int idx = entry.key;
              CheckpointInfo checkpoint = entry.value;
              return Column(
                key: ValueKey(idx),
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Checkpoint ${idx + 1}',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a checkpoint';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            checkpoints[idx] = CheckpointInfo(
                              location: value!,
                              time: DateTime.now().toString().substring(11, 16),
                              date: 'June 15 2019',
                              isReached: false,
                              status: 'Order in transit',
                            );
                          },
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            checkpoints.removeAt(idx);
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                ],
              );
            }).toList(),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: _addCheckpoint,
                  icon: const Icon(Icons.add),
                  label: const Text('Add Checkpoint'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: _saveRoute,
                  child: const Text('Save Route'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
class EditRoutesPage extends StatefulWidget {
  const EditRoutesPage({super.key});

  @override
  State<EditRoutesPage> createState() => _EditRoutesPageState();
}

class _EditRoutesPageState extends State<EditRoutesPage> {
  final List<RouteItem> routes = [
    RouteItem(
      name: 'Home to Work',
      startPoint: 'Home',
      endPoint: 'Office',
      waypoints: ['Metro Station', 'Coffee Shop'],
    ),
    RouteItem(
      name: 'Evening Walk',
      startPoint: 'Home',
      endPoint: 'Park',
      waypoints: ['Grocery Store'],
    ),
  ];

  void _addNewRoute() {
    showDialog(
      context: context,
      builder: (context) => RouteDialog(
        onSave: (RouteItem newRoute) {
          setState(() {
            routes.add(newRoute);
          });
        },
      ),
    );
  }

  void _editRoute(int index) {
    showDialog(
      context: context,
      builder: (context) => RouteDialog(
        initialRoute: routes[index],
        onSave: (RouteItem updatedRoute) {
          setState(() {
            routes[index] = updatedRoute;
          });
        },
      ),
    );
  }

  void _deleteRoute(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: BorderSide(
            color: const Color(0xFF8B5CF6).withOpacity(0.3),
          ),
        ),
        title: Text(
          'Delete Route',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Are you sure you want to delete this route?',
          style: GoogleFonts.poppins(
            color: Colors.white.withOpacity(0.8),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(
                color: Colors.white.withOpacity(0.8),
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                routes.removeAt(index);
              });
              Navigator.pop(context);
            },
            child: Text(
              'Delete',
              style: GoogleFonts.poppins(
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          'Edit Routes',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: const Color(0xFF8B5CF6),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black,
              const Color(0xFF8B5CF6).withOpacity(0.1),
              Colors.black,
            ],
          ),
        ),
        child: routes.isEmpty
            ? Center(
          child: Text(
            'No routes added yet',
            style: GoogleFonts.poppins(
              color: Colors.white.withOpacity(0.8),
              fontSize: 16,
            ),
          ),
        )
            : ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: routes.length,
          itemBuilder: (context, index) {
            final route = routes[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF8B5CF6).withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: const Color(0xFF8B5CF6).withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                title: Text(
                  route.name,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    Text(
                      'From: ${route.startPoint}',
                      style: GoogleFonts.poppins(
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                    Text(
                      'To: ${route.endPoint}',
                      style: GoogleFonts.poppins(
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                    if (route.waypoints.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Waypoints: ${route.waypoints.join(", ")}',
                        style: GoogleFonts.poppins(
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Color(0xFF8B5CF6)),
                      onPressed: () => _editRoute(index),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteRoute(index),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewRoute,
        backgroundColor: const Color(0xFF8B5CF6),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class RouteItem {
  String name;
  String startPoint;
  String endPoint;
  List<String> waypoints;

  RouteItem({
    required this.name,
    required this.startPoint,
    required this.endPoint,
    required this.waypoints,
  });
}

class RouteDialog extends StatefulWidget {
  final RouteItem? initialRoute;
  final Function(RouteItem) onSave;

  const RouteDialog({
    super.key,
    this.initialRoute,
    required this.onSave,
  });

  @override
  State<RouteDialog> createState() => _RouteDialogState();
}

class _RouteDialogState extends State<RouteDialog> {
  late TextEditingController nameController;
  late TextEditingController startController;
  late TextEditingController endController;
  late List<TextEditingController> waypointControllers;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.initialRoute?.name ?? '');
    startController = TextEditingController(text: widget.initialRoute?.startPoint ?? '');
    endController = TextEditingController(text: widget.initialRoute?.endPoint ?? '');
    waypointControllers = (widget.initialRoute?.waypoints ?? [])
        .map((wp) => TextEditingController(text: wp))
        .toList();
  }

  @override
  void dispose() {
    nameController.dispose();
    startController.dispose();
    endController.dispose();
    for (var controller in waypointControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _addWaypoint() {
    setState(() {
      waypointControllers.add(TextEditingController());
    });
  }

  void _removeWaypoint(int index) {
    setState(() {
      waypointControllers[index].dispose();
      waypointControllers.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(
          color: const Color(0xFF8B5CF6).withOpacity(0.3),
        ),
      ),
      title: Text(
        widget.initialRoute == null ? 'Add New Route' : 'Edit Route',
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              style: GoogleFonts.poppins(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Route Name',
                labelStyle: GoogleFonts.poppins(color: Colors.white.withOpacity(0.8)),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: const Color(0xFF8B5CF6).withOpacity(0.3),
                  ),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFF8B5CF6),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: startController,
              style: GoogleFonts.poppins(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Start Point',
                labelStyle: GoogleFonts.poppins(color: Colors.white.withOpacity(0.8)),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: const Color(0xFF8B5CF6).withOpacity(0.3),
                  ),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFF8B5CF6),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: endController,
              style: GoogleFonts.poppins(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'End Point',
                labelStyle: GoogleFonts.poppins(color: Colors.white.withOpacity(0.8)),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: const Color(0xFF8B5CF6).withOpacity(0.3),
                  ),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFF8B5CF6),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Waypoints',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            ...waypointControllers.asMap().entries.map(
                  (entry) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: entry.value,
                        style: GoogleFonts.poppins(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Waypoint ${entry.key + 1}',
                          labelStyle: GoogleFonts.poppins(
                            color: Colors.white.withOpacity(0.8),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: const Color(0xFF8B5CF6).withOpacity(0.3),
                            ),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFF8B5CF6),
                            ),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.remove_circle, color: Colors.red),
                      onPressed: () => _removeWaypoint(entry.key),
                    ),
                  ],
                ),
              ),
            ),
            TextButton.icon(
              onPressed: _addWaypoint,
              icon: const Icon(Icons.add, color: Color(0xFF8B5CF6)),
              label: Text(
                'Add Waypoint',
                style: GoogleFonts.poppins(
                  color: const Color(0xFF8B5CF6),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Cancel',
            style: GoogleFonts.poppins(
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            final route = RouteItem(
              name: nameController.text,
              startPoint: startController.text,
              endPoint: endController.text,
              waypoints: waypointControllers
                  .map((controller) => controller.text)
                  .where((text) => text.isNotEmpty)
                  .toList(),
            );
            widget.onSave(route);
            Navigator.pop(context);
          },
          child: Text(
            'Save',
            style: GoogleFonts.poppins(
              color: const Color(0xFF8B5CF6),
            ),
          ),
        ),
      ],
    );
  }
}