import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../globals.dart';
// import '../payment_page.dart';

num totalPriceFinal = 0;

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  @override
  void initState() {
    calculatingTotalPrice();
    super.initState();
  }

  calculatingTotalPrice() async {
    num totalPrice = 0;
    final firestoreInstance = FirebaseFirestore.instance;
    QuerySnapshot qn = await firestoreInstance
        .collection("users-cart-items")
        .doc(FirebaseAuth.instance.currentUser!.email)
        .collection("items")
        .get();

    for (int i = 0; i < qn.docs.length; i++) {
      totalPrice = totalPrice +
          num.parse(qn.docs[i]["price"]) *
              num.parse(qn.docs[i]["item-quantity"]);
      totalPriceFinal = totalPrice;
    }
    setState(() {
      globalVar = totalPrice;
    });
  }

  fetchCartData(String collectionName) {
    num lastElement = 0;

    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection(collectionName)
          .doc(FirebaseAuth.instance.currentUser!.email)
          .collection("items")
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text("Something is wrong"),
          );
        }

        return Column(
          children: [
            const SizedBox(height: 3.0),
            ListView.builder(
                shrinkWrap: true,
                itemCount:
                    snapshot.data == null ? 0 : snapshot.data!.docs.length,
                itemBuilder: (_, index) {
                  DocumentSnapshot documentSnapshot =
                      snapshot.data!.docs[index];
                  lastElement = snapshot.data!.docs.length;

                  return Column(
                    children: [
                      Card(
                        elevation: 0,
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: SizedBox(
                                  width: 70,
                                  child: Text(documentSnapshot['name'])),
                            ),
                            const Spacer(),
                            Text(
                              "\$ ${documentSnapshot['price']}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green),
                            ),
                            Text(" X ${documentSnapshot['item-quantity']}"),
                            const Spacer(),
                            IconButton(
                              color: Colors.blue.shade900,
                              iconSize: 30,
                              icon: const Icon(Icons.remove_circle),
                              onPressed: () {
                                if (num.parse(
                                        documentSnapshot['item-quantity']) >
                                    1) {
                                  FirebaseFirestore.instance
                                      .collection(collectionName)
                                      .doc(FirebaseAuth
                                          .instance.currentUser!.email)
                                      .collection("items")
                                      .doc(documentSnapshot.id)
                                      .update({
                                    "item-quantity":
                                        "${num.parse(documentSnapshot['item-quantity']) - 1}",
                                  }).then((value) => calculatingTotalPrice());
                                }
                              },
                            ),
                            IconButton(
                              color: Colors.green,
                              iconSize: 30,
                              icon: const Icon(Icons.add_circle),
                              onPressed: () {
                                FirebaseFirestore.instance
                                    .collection(collectionName)
                                    .doc(FirebaseAuth
                                        .instance.currentUser!.email)
                                    .collection("items")
                                    .doc(documentSnapshot.id)
                                    .update({
                                  "item-quantity":
                                      "${num.parse(documentSnapshot['item-quantity']) + 1}",
                                }).then((value) => calculatingTotalPrice());
                              },
                            ),
                            IconButton(
                              color: Colors.red.shade700,
                              iconSize: 30,
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                FirebaseFirestore.instance
                                    .collection(collectionName)
                                    .doc(FirebaseAuth
                                        .instance.currentUser!.email)
                                    .collection("items")
                                    .doc(documentSnapshot.id)
                                    .delete()
                                    .then((value) => calculatingTotalPrice());
                              },
                            ),
                          ],
                        ),
                      ),

                      // Show Total Price
                      if (index == lastElement - 1)
                        Padding(
                          padding: const EdgeInsets.only(top: 30.0),
                          child: Text(
                            "Total Price :  $totalPriceFinal",
                            style: TextStyle(
                                color: Colors.green.shade700, fontSize: 18),
                          ),
                        ),
                    ],
                  );
                }),
            const SizedBox(height: 20.0),
            if (globalVar != 0)
              ElevatedButton(
                onPressed: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //       builder: (context) => const PaymentPage()),
                  // );
                },
                child: const Text('Pay Now'),
              ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey.shade200,
        appBar: AppBar(
          backgroundColor: Colors.grey.shade200,
          title: Text(
            "Cart Items",
            style: TextStyle(
                color: Colors.green.shade700,
                fontWeight: FontWeight.normal,
                fontSize: 18),
          ),
          centerTitle: true,
        ),
        body: fetchCartData("users-cart-items"),
      ),
    );
  }
}
