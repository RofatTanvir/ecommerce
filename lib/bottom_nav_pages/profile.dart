import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:me_ecommerce_practice/product_upload_categorized.dart';
// import '../ad_page.dart';
// import '../current_location.dart';
import '../login_screen.dart';
// import '../product_upload.dart';
import '../user_form.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController? _nameController;
  TextEditingController? _phoneController;
  TextEditingController? _ageController;

  setDataToTextField(data) {
    return Column(
      children: [
        TextFormField(
          controller: _nameController =
              TextEditingController(text: data['name']),
        ),
        TextFormField(
          controller: _phoneController =
              TextEditingController(text: data['phone']),
        ),
        TextFormField(
          controller: _ageController = TextEditingController(text: data['age']),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
            onPressed: () => updateData(), child: const Text("Update")),
        ElevatedButton(
          onPressed: () async {
            await auth.signOut().then((value) => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                ));
          },
          child: const Text('Sign Out'),
        ),
        ElevatedButton(
          onPressed: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //       builder: (context) => const CurrentLocationHere()),
            // );
          },
          child: const Text('OrderTrackingPage'),
        ),
        ElevatedButton(
          onPressed: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => const ProductUpload()),
            // );
          },
          child: const Text('Product Upload'),
        ),
        ElevatedButton(
          onPressed: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => const ProductUploadCategorized()),
            // );
          },
          child: const Text('Product Upload Categorized'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const UserForm()),
            );
          },
          child: const Text('User Form'),
        ),
        ElevatedButton(
          onPressed: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => const MyAdWidget()),
            // );
          },
          child: const Text('Ad Show'),
        ),
      ],
    );
  }

  updateData() {
    CollectionReference collectionRef =
        FirebaseFirestore.instance.collection("users-form-data");
    return collectionRef.doc(FirebaseAuth.instance.currentUser!.email).update({
      "name": _nameController!.text,
      "phone": _phoneController!.text,
      "age": _ageController!.text,
    }).then((value) => log("Updated Successfully"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade200,
        title: Text(
          "Your Profile",
          style: TextStyle(
              color: Colors.green.shade700,
              fontWeight: FontWeight.normal,
              fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 05),
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("users-form-data")
                .doc(FirebaseAuth.instance.currentUser!.email)
                .snapshots(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              var data = snapshot.data;
              if (data == null) {
                return Center(
                  child: Text(
                    'Loading......',
                    style: TextStyle(color: Colors.blue.shade700, fontSize: 20),
                  ),
                );
              }
              return setDataToTextField(data);
            },
          ),
        )),
      ),
    );
  }
}
