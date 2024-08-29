import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  var inputText = "";
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey.shade200,
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Container(
                color: Colors.white,
                child: TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter Product Name',
                  ),
                  onChanged: (val) {
                    setState(() {
                      inputText = val;
                      if (kDebugMode) {
                        print(inputText);
                      }
                    });
                  },
                ),
              ),
              Expanded(
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("products")
                        .where("product-name",
                            isGreaterThanOrEqualTo: inputText)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return const Center(
                          child: Text("Something went wrong"),
                        );
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: Text("Loading"),
                        );
                      }

                      return Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: ListView(
                          children: snapshot.data!.docs
                              .map((DocumentSnapshot document) {
                            Map<String, dynamic> data =
                                document.data() as Map<String, dynamic>;
                            return Card(
                              elevation: 0,
                              child: Row(
                                children: [
                                  SizedBox(
                                      width: 45,
                                      height: 50,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 4.0),
                                        child: Image.network(
                                            data['product-img'][0]),
                                      )),
                                  Text(data['product-name']),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
