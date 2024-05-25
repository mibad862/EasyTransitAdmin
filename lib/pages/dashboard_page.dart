import 'package:easytransit_admin/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../common_widgets/common_appbar.dart';
import 'pending_driver_rides.dart';
import 'pending_accounts_list.dart';

class DashBoardPage extends StatelessWidget {
  const DashBoardPage({super.key});

  static const String routeName = '/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: "Dashboard Page",
        showIcon: false,
        actions: [
          IconButton(
            onPressed: () {
              AuthService.logout();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                      child: const Text(
                        "Pending Accounts List",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                Material(
                  elevation: 2.0,
                  borderRadius: BorderRadius.circular(10),
                  child: GestureDetector(
                    onTap: () => context.goNamed(PendingDriverRides.routeName),
                    child: Container(
                      alignment: Alignment.center,
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        "Pending Driver Rides",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                        textAlign: TextAlign.center,
                      ),
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
