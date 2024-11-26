import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:nivetut/auth_page.dart';
import 'package:nivetut/firebase_options.dart';
import 'package:nivetut/info_page.dart';
import 'package:nivetut/police_report_page.dart';
import 'package:nivetut/profile_page.dart';
import 'package:nivetut/report_page.dart'; // for logging out

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: AuthPage(), // Starting point is AuthPage
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // Sign-out method with navigation back to AuthPage
  void signUserOut(BuildContext context) {
    FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const AuthPage()),
      (Route<dynamic> route) => false, // Clear all previous routes
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () => signUserOut(context), // Sign out
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: const Center(child: Text('Map goes here')),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.report),
            label: 'Report',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'Info',
          ),
        ],
        onTap: (index) async {
          if (index == 0) {
            // Navigate to Profile Page
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfilePage()),
            );
          } else if (index == 1) {
            // Navigate to Report Page based on role (Citizen or Police)
            User? user = FirebaseAuth.instance.currentUser;
            if (user != null) {
              // Fetch user role from Firestore
              DocumentSnapshot userDoc = await FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .get();

              String role = userDoc['role']; // Assuming 'role' field exists

              if (role == 'citizen') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ReportPage()),
                );
              } else if (role == 'police') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PoliceReportPage()),
                );
              }
            }
          } else if (index == 2) {
            // Navigate to Info Page
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const InfoPage()),
            );
          }
        },
      ),
    );
  }
}
