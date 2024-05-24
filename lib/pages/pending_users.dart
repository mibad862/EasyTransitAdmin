import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PendingUsers extends StatelessWidget {
  const PendingUsers({super.key});

  static const String routeName = 'pending-users';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Pending Users List"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').where('status', isEqualTo: 'pending').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator(); // Show loading indicator while fetching data
          }
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}'); // Show error message if any
          }
          final users = snapshot.data!.docs;

          if (users.isEmpty) {
            return const Center(
              child: Text('No pending users'), // Show message if there are no pending users
            );
          }

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final userData = users[index].data() as Map<String, dynamic>;
              final userId = users[index].id;

              return ListTile(
                title: Text(userData['full_name']),
                subtitle: Text(userData['email']),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        // Approve user
                        FirebaseFirestore.instance.collection('users').doc(userId).update({
                          'status': 'approved',
                        });
                      },
                      icon: Icon(Icons.check),
                      color: Colors.green,
                    ),
                    IconButton(
                      onPressed: () {
                        // Reject user
                        FirebaseFirestore.instance.collection('users').doc(userId).delete();
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
}
