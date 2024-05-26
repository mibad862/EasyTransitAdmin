import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:easytransit_admin/common_widgets/common_appbar.dart';

class PendingAmbulanceBooking extends StatelessWidget {
  PendingAmbulanceBooking({super.key});

  static const String routeName = 'pending-ambulance-booking';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(
        title: "Pending Ambulance Bookings",
        showIcon: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          final users = snapshot.data?.docs ?? [];

          if (users.isEmpty) {
            return const Center(
              child: Text('No pending bookings'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            itemCount: users.length,
            itemBuilder: (context, index) {
              final userId = users[index].id;

              return StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(userId)
                    .collection('ambulanceBookings')
                    .doc(userId)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  }
                  final bookingData = snapshot.data?.data() as Map<String, dynamic>?;

                  if (bookingData == null || bookingData['status'] != 'pending') {
                    return Container(); // Skip if no pending bookings
                  }

                  final name = bookingData['name'] ?? 'Unknown';
                  final location = bookingData['location'] ?? 'Unknown';
                  final time = bookingData['time'] ?? 'Unknown';
                  final date = (bookingData['date'] as Timestamp).toDate(); // Convert Timestamp to DateTime

                  return Material(
                    elevation: 2.0,
                    borderRadius: BorderRadius.circular(10.0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name,
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w500),
                              ),
                              Text(
                                location,
                                style: const TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w400),
                              ),
                              Text(
                                "Time: $time",
                                style: const TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  approveBooking(userId, bookingData);
                                },
                                icon: const Icon(Icons.check),
                                color: Colors.green,
                              ),
                              IconButton(
                                onPressed: () {
                                  rejectBooking(userId);
                                },
                                icon: const Icon(Icons.close),
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
          );
        },
      ),
    );
  }

  void approveBooking(String userId, Map<String, dynamic> bookingData) async {
    try {
      // Update the booking status to 'approved'
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('ambulanceBookings')
          .doc(userId)
          .update({
        'status': 'approved',
      });

      print('Ambulance booking approved');
    } catch (e) {
      print('Error approving booking: $e');
    }
  }

  void rejectBooking(String userId) async {
    try {
      // Delete the booking
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('ambulanceBookings')
          .doc(userId)
          .delete();

      print('Ambulance booking rejected');
    } catch (e) {
      print('Error rejecting booking: $e');
    }
  }
}
