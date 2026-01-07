import 'package:fit_go/controllers/user_setup_controller.dart';
import 'package:fit_go/service/user_local_storage_service.dart';
import 'package:fit_go/widgets/appbar.dart';
import 'package:fit_go/widgets/calendar_strip_widget.dart';
import 'package:fit_go/widgets/workout_day.dart';
import 'package:fit_go/data/gym_data/user_activity.dart';
import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String greeting = "Morning";
  bool isLoading = true;
  late UserActivity userActivity;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      // Load user setup data
      await UserLocalStorageService.loadUserSetup();
      
      // Load exercise progress
      final savedActivity = await UserLocalStorageService.loadExerciseProgress();
      
      setState(() {
        userActivity = savedActivity ?? UserActivity();
        greeting = _getGreeting();
        isLoading = false;
      });
    } catch (e) {
      print('Error loading user data: $e');
      setState(() {
        userActivity = UserActivity();
        isLoading = false;
      });
    }
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return "Morning";
    if (hour < 17) return "Afternoon";
    return "Evening";
  }

  ImageProvider? _getProfileImage() {
    if (userSetupController.profileImage != null) {
      return FileImage(userSetupController.profileImage!);
    } else if (userSetupController.profileImageWeb != null) {
      return MemoryImage(userSetupController.profileImageWeb!);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Container(
          color: Colors.blue[400],
          child: const Center(
            child: CircularProgressIndicator(color: Colors.white),
          ),
        ),
      );
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 12, 39, 135),
              Color(0xFF1976D2),
              Color(0xFF26C6DA),
            ],
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 30, 10, 0),
              child: Appbar(),
            ),
            const SizedBox(height: 10),

            // Greeting Section
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "$greeting : ${userSetupController.name ?? 'User'}",
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white,
                    backgroundImage: _getProfileImage(),
                    child: _getProfileImage() == null
                        ? const Icon(Icons.person, size: 30, color: Colors.grey)
                        : null,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),

            // Calendar Strip
            CalendarStripWidget(userActivity: userActivity),

            const SizedBox(height: 15),

            // Workout Days List
            Expanded(child: WorkoutDay()),
          ],
        ),
      ),
    );
  }
}
