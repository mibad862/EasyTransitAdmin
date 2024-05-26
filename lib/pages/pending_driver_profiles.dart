import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easytransit_admin/common_widgets/common_appbar.dart';
import 'package:flutter/material.dart';

class PendingDriverProfiles extends StatelessWidget {
  const PendingDriverProfiles({super.key});

  static const String routeName = 'pending-driver-rides';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: "Pending Driver Profiles",
        showIcon: true,
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
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            itemCount: users.length,
            itemBuilder: (context, index) {
              final userData = users[index].data() as Map<String, dynamic>;
              final userId = users[index].id;
              final name = userData['name'] ?? 'Unknown';
              final phoneNumber = userData['phoneNumber'] ?? 'Unknown';
              final vehicleName = userData['vehicleName'] ?? 'Unknown';
              final vehicleNo = userData['vehicleNo'] ?? 'Unknown';

              return Material(
                elevation: 2.0,
                borderRadius: BorderRadius.circular(10.0),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(10.0)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500),
                          ),
                          Text(
                            phoneNumber,
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w400),
                          ),
                          Text(
                            "Vehicle Name: $vehicleName",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w400),
                          ),
                          Text(
                            "Vehicle Number: $vehicleNo",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                      Row(
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
                    ],
                  ),
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
    FirebaseFirestore.instance.collection('driverDetails').doc(userId).delete();
  }
}
