import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/product.dart';
import '../models/product_card_favorite.dart';

class Favourite extends StatefulWidget {
  const Favourite({super.key});

  @override
  State<Favourite> createState() => _FavouriteState();
}

class _FavouriteState extends State<Favourite> {
  List<Product> favoriteProducts = [];

  // for getting id's of known users from firestore database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getYourFavoritesId() {
    var currentUser = FirebaseAuth.instance.currentUser;
    return FirebaseFirestore.instance
        .collection("users-favourite-items")
        .doc(currentUser!.email)
        .collection("items")
        .snapshots();
  }

  // for getting all users from firestore database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers(
      List<String> userIds) {
    log('\nUserIds: $userIds');

    return FirebaseFirestore.instance
        .collection('products')
        .where('product-id',
            whereIn: userIds.isEmpty
                ? ['']
                : userIds) //because empty list throws an error
        // .where('id', isNotEqualTo: user.uid)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade200,
        title: Text(
          "Favorite  Products",
          style: TextStyle(
              color: Colors.green.shade700,
              fontWeight: FontWeight.normal,
              fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 3.0),
          child: StreamBuilder(
            stream: getYourFavoritesId(),

            //get id of only known users
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                //if data is loading
                case ConnectionState.waiting:
                case ConnectionState.none:

                //if some or all data is loaded then show it
                case ConnectionState.active:
                case ConnectionState.done:
                  return StreamBuilder(
                    stream: getAllUsers(
                        snapshot.data?.docs.map((e) => e.id).toList() ?? []),

                    //get only those user, who's ids are provided
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        //if data is loading
                        case ConnectionState.waiting:
                        case ConnectionState.none:
                        // return const Center(
                        //     child: CircularProgressIndicator());

                        //if some or all data is loaded then show it
                        case ConnectionState.active:
                        case ConnectionState.done:
                          final data = snapshot.data?.docs;
                          favoriteProducts = data
                                  ?.map((e) => Product.fromJson(e.data()))
                                  .toList() ??
                              [];

                          if (favoriteProducts.isNotEmpty) {
                            return GridView.builder(
                                itemCount: favoriteProducts.length,
                                scrollDirection: Axis.vertical,
                                physics: const BouncingScrollPhysics(),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2, childAspectRatio: 1),
                                itemBuilder: (context, index) {
                                  return ProductCardFavorite(
                                      user: favoriteProducts[index]);
                                });
                          } else {
                            return const Center(
                              child: Text('No Favorite Added',
                                  style: TextStyle(fontSize: 15)),
                            );
                          }
                      }
                    },
                  );
              }
            },
          ),
        ),
      ),
    );
  }
}
