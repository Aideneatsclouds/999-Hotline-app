import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReportPage extends StatelessWidget {
  final TextEditingController _detailsController = TextEditingController();

  // Service logic to handle report submission
  Future<void> _submitReport(BuildContext context) async {
    String details = _detailsController.text;

    if (details.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter some details')),
      );
      return;
    }

    try {
      await _addReport(details); // Call the addReport function
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Report submitted successfully!')),
      );
      _detailsController.clear(); // Clear the input field
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  // ReportService logic to add the report to Firestore
  Future<void> _addReport(String details) async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final FirebaseAuth _auth = FirebaseAuth.instance;

    // Get the current user
    User? user = _auth.currentUser;
    if (user == null) {
      throw Exception("User is not logged in");
    }

    // Add the report to Firestore
    await _firestore.collection('Reports').add({
      'userId': user.uid, // Link the report to the current user
      'details': details, // Incident details from the user
      'timestamp': Timestamp.now(), // Current timestamp
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Report Incident'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _detailsController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Enter incident details here...',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _submitReport(context),
              child: Text('Report'),
            ),
          ],
        ),
      ),
    );
  }
}
