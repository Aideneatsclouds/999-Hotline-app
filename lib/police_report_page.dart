import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PoliceReportPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Citizen Reports'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Reports')
            .orderBy('timestamp',
                descending: true) // Sort by timestamp (most recent first)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final reports = snapshot.data!.docs;

          return ListView.builder(
            itemCount: reports.length,
            itemBuilder: (context, index) {
              final report = reports[index];
              final details = report['details'];
              final timestamp = (report['timestamp'] as Timestamp).toDate();
              final userId = report['userId'];

              return Card(
                margin: EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text('Report from $userId'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Details: $details'),
                      SizedBox(height: 5),
                      Text('Submitted at: ${timestamp.toLocal()}'),
                    ],
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.check_circle),
                    onPressed: () {
                      // Handle acknowledging the report (e.g., update isAcknowledged)
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
