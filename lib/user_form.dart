import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'bottom_nav_controller.dart';

class UserForm extends StatefulWidget {
  const UserForm({super.key});

  @override
  State<UserForm> createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  List<String> gender = ["Male", "Female", "Other"];
  String dropdownValue = "Female";
  String selectedGender = "Female";

  Future<void> _selectDateFromPicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(DateTime.now().year - 20),
      firstDate: DateTime(DateTime.now().year - 30),
      lastDate: DateTime(DateTime.now().year),
    );
    if (picked != null) {
      setState(() {
        _dobController.text = "${picked.day}/ ${picked.month}/ ${picked.year}";
      });
    }
  }

  sendUserDataToDB() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    var currentUser = auth.currentUser;

    CollectionReference collectionRef =
        FirebaseFirestore.instance.collection("users-form-data");
    return collectionRef
        .doc(currentUser!.email)
        .set({
          "name": _nameController.text,
          "phone": _phoneController.text,
          "dob": _dobController.text,
          "gender": selectedGender,
          "age": _ageController.text,
        })
        .then((value) => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const BottomNavController()),
            ))
        .catchError((error) => log("something is wrong. $error"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text('User Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                keyboardType: TextInputType.text,
                controller: _nameController,
                decoration: const InputDecoration(
                  hintText: "Enter your name",
                ),
              ),
              TextField(
                keyboardType: TextInputType.number,
                controller: _phoneController,
                decoration: const InputDecoration(
                  hintText: "Enter your phone number",
                ),
              ),
              TextField(
                keyboardType: TextInputType.number,
                controller: _ageController,
                decoration: const InputDecoration(
                  hintText: "Enter your age",
                ),
              ),
              TextField(
                controller: _dobController,
                readOnly: true,
                decoration: InputDecoration(
                  hintText: "Date of birth",
                  suffixIcon: IconButton(
                    onPressed: () => _selectDateFromPicker(context),
                    icon: const Icon(Icons.calendar_today_outlined),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Wrap(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Text("Choose Your Gender :"),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 8.0),
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.blue)),
                    child: DropdownButton<String>(
                      isDense: true,
                      value: dropdownValue,
                      elevation: 16,
                      iconSize: 30,
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                      onChanged: (String? value) {
                        // This is called when the user selects an item.
                        setState(() {
                          dropdownValue = value!;
                          selectedGender = value;
                        });
                      },
                      items:
                          gender.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          alignment: AlignmentDirectional.center,
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  sendUserDataToDB();
                },
                child: const Text('Confirm'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
