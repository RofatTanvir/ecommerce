import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:me_ecommerce_practice/bottom_nav_controller.dart';
import 'package:me_ecommerce_practice/login_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initializing Firebase
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyD_98JplDKgKKahndwfYhbD5IpbLh2a-fI",
      appId: "1:927105413555:ios:c1a15af30b5717286f9bc6",
      messagingSenderId: "927105413555",
      projectId: "moon-8650a",
      storageBucket: "moon-8650a.appspot.com",
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: false,
            ),
            home: const LogCheck(),
          );
        });
  }
}

class LogCheck extends StatefulWidget {
  const LogCheck({super.key});

  @override
  State<LogCheck> createState() => _LogCheckState();
}

class _LogCheckState extends State<LogCheck> {
  User? user;
  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return user != null ? const BottomNavController() : const LoginScreen();
  }
}
