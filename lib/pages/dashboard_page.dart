import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easytransit_admin/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'pending_users.dart';

class DashBoardPage extends StatelessWidget {
  const DashBoardPage({super.key});

  static const String routeName = '/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard Page"),
        actions: [
          IconButton(
            onPressed: () {
              AuthService.logout();
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Material(
              elevation: 2.0,
              borderRadius: BorderRadius.circular(10),
              child: GestureDetector(
                onTap: () => context.goNamed(PendingUsers.routeName),
                child: Container(
                  alignment: Alignment.center,
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    "Pending Users List",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
