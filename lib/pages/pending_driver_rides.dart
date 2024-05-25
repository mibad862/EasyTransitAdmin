import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PendingDriverRides extends StatelessWidget {
  const PendingDriverRides({Key? key}) : super(key: key);

  static const String routeName = 'pending-driver-rides';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Pending Driver Rides"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('driverDetails')
            .where('status', isEqualTo: 'pending')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            ); // Show loading indicator while fetching data
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            ); // Show error message if any
          }
          final users = snapshot.data!.docs;

          if (users.isEmpty) {
            return const Center(
              child: Text('No pending users'),
            ); // Show message if there are no pending users
          }

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final userData = users[index].data() as Map<String, dynamic>;
              final userId = users[index].id;
              final name = userData['name'] ?? 'Unknown';
              final phoneNumber = userData['phoneNumber'] ?? 'Unknown';

              return ListTile(
                title: Text(name),
                subtitle: Text(phoneNumber),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        approveUser(userId);
                      },
                      icon: Icon(Icons.check),
                      color: Colors.green,
                    ),
                    IconButton(
                      onPressed: () {
                        rejectUser(userId);
                      },
                      icon: Icon(Icons.close),
                      color: Colors.red,
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  void approveUser(String userId) {
    FirebaseFirestore.instance
        .collection('driverDetails')
        .doc(userId)
        .update({'status': 'approved'});
  }

  void rejectUser(String userId) {
    FirebaseFirestore.instance
        .collection('driverDetails')
        .doc(userId)
        .delete();
  }
}
