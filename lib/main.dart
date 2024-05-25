import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'auth/auth_service.dart';
import 'firebase_options.dart';
import 'pages/dashboard_page.dart';
import 'pages/login_page.dart';
import 'pages/pending_driver_rides.dart';
import 'pages/pending_accounts_list.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
   MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
    );
  }
  final _router = GoRouter(
      initialLocation: DashBoardPage.routeName,
      redirect: (context, state) {
        if(AuthService.currentUser == null) {
          return LoginPage.routeName;
        }
        return null;
      },
      routes: [
        GoRoute(
          name: DashBoardPage.routeName,
          path: DashBoardPage.routeName,
          builder: (context, state) => const DashBoardPage(),
          routes: [
            GoRoute(
              name: PendingUsers.routeName,
              path: PendingUsers.routeName,
              builder: (context, state) => const PendingUsers(),
            ),
            GoRoute(
              name: PendingDriverRides.routeName,
              path: PendingDriverRides.routeName,
              builder: (context, state) => const PendingDriverRides(),
            ),
            // GoRoute(
            //     name: ViewTelescopePage.routeName,
            //     path: ViewTelescopePage.routeName,
            //     builder: (context, state) => const ViewTelescopePage(),
            //     routes: [
            //       GoRoute(
            //           name: TelescopeDetailsPage.routeName,
            //           path: TelescopeDetailsPage.routeName,
            //           builder: (context, state) => TelescopeDetailsPage(id: state.extra! as String,),
            //           routes: [
            //             GoRoute(
            //               name: DescriptionPage.routeName,
            //               path: DescriptionPage.routeName,
            //               builder: (context, state) => DescriptionPage(id: state.extra! as String,),
            //             ),
            //           ]
            //       ),
            //     ]
            // ),
            // GoRoute(
            //   name: BrandPage.routeName,
            //   path: BrandPage.routeName,
            //   builder: (context, state) => const BrandPage(),
            // ),
            // GoRoute(
            //   name: UserListPage.routeName,
            //   path: UserListPage.routeName,
            //   builder: (context, state) => const UserListPage(),
            // ),
            // GoRoute(
            //     name: OrderPage.routeName,
            //     path: OrderPage.routeName,
            //     builder: (context, state) => const OrderPage(),
            //     routes: [
            //       GoRoute(
            //         name: OrderDetailsPage.routeName,
            //         path: OrderDetailsPage.routeName,
            //         builder: (context, state) => OrderDetailsPage(orderId: state.extra! as String,),
            //       ),
            //     ]
            // ),
            // GoRoute(
            //   name: ReportPage.routeName,
            //   path: ReportPage.routeName,
            //   builder: (context, state) => const ReportPage(),
            // ),
          ],
        ),
        GoRoute(
          name: LoginPage.routeName,
          path: LoginPage.routeName,
          builder: (context, state) => const LoginPage(),
        ),
      ]
  );
}

