import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:me_ecommerce_practice/bottom_nav_controller.dart';
import 'package:me_ecommerce_practice/registration_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;

  signIn() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: _emailController.text, password: _passwordController.text);
      var authCredential = userCredential.user;
      log(authCredential!.uid);
      if (authCredential.uid.isNotEmpty) {
        moveToBottomNavController();
      } else {
        Fluttertoast.showToast(msg: "Something is wrong");
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Fluttertoast.showToast(msg: "No user found for that email.");
      } else if (e.code == 'wrong-password') {
        Fluttertoast.showToast(msg: "Wrong password provided for that user.");
      }
    } catch (e) {
      log('$e');
    }
  }

  moveToBottomNavController() {
    Navigator.push(
      context,
      // MaterialPageRoute(builder: (context) => const BottomNavController()),
      MaterialPageRoute(builder: (context) => const BottomNavController()),
    );
  }

  exitApp() {
    SystemNavigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    num paddingMultiplicationFactor =
        MediaQuery.of(context).orientation == Orientation.portrait
            ? 0.25
            : 0.13;

    showExitAlert() async {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Exit App'),
          content: const Text('Do you want to exit this App?'),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('No'),
            ),
            ElevatedButton(
              onPressed: () => exitApp(),
              child: const Text('Yes'),
            ),
          ],
        ),
      );
    }

    Future resetPassword({required String email}) async {
      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      } on FirebaseAuthException catch (err) {
        throw Exception(err.message.toString());
      } catch (err) {
        throw Exception(err.toString());
      }
    }

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        showExitAlert();
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: const Text('Login Screen'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
                top: screenHeight * paddingMultiplicationFactor),
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20.0, vertical: 7),
                  child: TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "moon@gmail.com",
                      hintStyle: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF414041),
                      ),
                      labelText: 'Email',
                      labelStyle: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20.0, vertical: 7),
                  child: TextField(
                    controller: _passwordController,
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      hintText: "Password must be 6 character",
                      hintStyle: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF414041),
                      ),
                      labelText: 'Password',
                      labelStyle: const TextStyle(
                        fontSize: 15,
                      ),
                      suffixIcon: _obscureText == true
                          ? IconButton(
                              onPressed: () {
                                setState(() {
                                  _obscureText = false;
                                });
                              },
                              icon: const Icon(
                                Icons.remove_red_eye,
                                size: 20,
                              ))
                          : IconButton(
                              onPressed: () {
                                setState(() {
                                  _obscureText = true;
                                });
                              },
                              icon: const Icon(
                                Icons.visibility_off,
                                size: 20,
                              )),
                    ),
                  ),
                ),
                const SizedBox(height: 07),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 19.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        signIn();
                      },
                      child: const Text('Sign In'),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Forget Account Password?",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFBBBBBB),
                      ),
                    ),
                    const SizedBox(width: 5.0),
                    GestureDetector(
                      child: const Text(
                        "Reset Password",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      onTap: () {
                        if (_emailController.text.isEmpty) {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Email Box is Empty'),
                              content: const Text(
                                  'Enter a valid Email into Email Box'),
                              actions: [
                                ElevatedButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          );
                        } else {
                          resetPassword(email: _emailController.text);
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Check Your Email'),
                              content: const Text(
                                  'Password Reset link is sent to your Email. Please check your Email and reset your password.'),
                              actions: [
                                ElevatedButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                    )
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account?",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFBBBBBB),
                      ),
                    ),
                    const SizedBox(width: 5.0),
                    GestureDetector(
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RegistrationScreen()),
                        );
                      },
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
