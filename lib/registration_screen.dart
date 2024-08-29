import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:me_ecommerce_practice/user_form.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<RegistrationScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;

  signUp() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _emailController.text, password: _passwordController.text);
      var authCredential = userCredential.user;
      if (authCredential!.uid.isNotEmpty) {
        goToUserForm();
      } else {
        Fluttertoast.showToast(
            gravity: ToastGravity.CENTER, msg: "Something is wrong");
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Fluttertoast.showToast(
            gravity: ToastGravity.CENTER,
            msg: "The password provided is too weak.");
      } else if (e.code == 'email-already-in-use') {
        Fluttertoast.showToast(
            gravity: ToastGravity.CENTER,
            msg: "The account already exists for that email.");
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  goToUserForm() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const UserForm()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registration Screen'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                hintText: "moon@gmail.com",
                hintStyle: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF414041),
                ),
                labelText: 'EMAIL',
                labelStyle: TextStyle(
                  fontSize: 15,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: TextField(
              controller: _passwordController,
              obscureText: _obscureText,
              decoration: InputDecoration(
                hintText: "password must be 6 character",
                hintStyle: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF414041),
                ),
                labelText: 'PASSWORD',
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
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: ElevatedButton(
              onPressed: () {
                signUp();
              },
              child: const Text('Sign Up'),
            ),
          ),
        ],
      ),
    );
  }
}
