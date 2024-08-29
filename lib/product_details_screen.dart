import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'models/product.dart';

class ProductDetails extends StatefulWidget {
  final Product _product;

  const ProductDetails(this._product, {super.key});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  double screenWidth = 0;
  bool alreadyMarkedFavorite = false;
  bool alreadyAddedCart = false;

  checkFavorite() async {
    var currentUser = FirebaseAuth.instance.currentUser;
    var documentFavorite = await FirebaseFirestore.instance
        .collection("users-favourite-items")
        .doc(currentUser!.email)
        .collection("items")
        .doc(widget._product.productId)
        .get();

    if (documentFavorite.exists) {
      alreadyMarkedFavorite = true;
      setState(() {});
    }
  }

  addToFavourite() async {
    var currentUser = FirebaseAuth.instance.currentUser;
    // remove if exists
    if (alreadyMarkedFavorite == true) {
      await FirebaseFirestore.instance
          .collection("users-favourite-items")
          .doc(currentUser!.email)
          .collection("items")
          .doc(widget._product.productId)
          .delete();
      alreadyMarkedFavorite = false;
      setState(() {});
    }

    // set if not exists
    else {
      await FirebaseFirestore.instance
          .collection("users-favourite-items")
          .doc(currentUser!.email)
          .collection("items")
          .doc(widget._product.productId)
          .set({"product-id": widget._product.productId});

      alreadyMarkedFavorite = true;
      setState(() {});
    }
  }

  checkCart() async {
    var currentUser = FirebaseAuth.instance.currentUser;
    var documentCart = await FirebaseFirestore.instance
        .collection("users-cart-items")
        .doc(currentUser!.email)
        .collection("items")
        .doc(widget._product.productId)
        .get();

    if (documentCart.exists) {
      alreadyAddedCart = true;
      setState(() {});
    }
  }

  addToCart() async {
    // show message if exists
    if (alreadyAddedCart == true) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Already Added'),
          content: const Text('Product already added to Cart'),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }

    // set if not exists
    else {
      var currentUser = FirebaseAuth.instance.currentUser;
      CollectionReference collectionRef =
          FirebaseFirestore.instance.collection("users-cart-items");
      return collectionRef
          .doc(currentUser!.email)
          .collection("items")
          .doc(widget._product.productId)
          .set({
        "name": widget._product.productName,
        "price": widget._product.productPrice,
        "product-id": widget._product.productId,
        "images": widget._product.productImage,
        "item-quantity": "1",
      }).then((value) {
        alreadyAddedCart = true;
        setState(() {});
      });
    }
  }

  selectScreen() {
    return screenWidth < 600 ? mobileScreen() : mobileScreen();
  }

  @override
  void initState() {
    checkFavorite();
    checkCart();
    super.initState();
  }

  mobileScreen() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.orange,
            child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                )),
          ),
        ),
        actions: [
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("users-favourite-items")
                .doc(FirebaseAuth.instance.currentUser!.email)
                .collection("items")
                .where("name", isEqualTo: widget._product.productName)
                .snapshots(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return const Text("");
              }
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: CircleAvatar(
                  backgroundColor: Colors.red,
                  child: IconButton(
                    onPressed: () => addToFavourite(),
                    icon: alreadyMarkedFavorite == true
                        ? const Icon(
                            Icons.favorite,
                            color: Colors.white,
                          )
                        : const Icon(
                            Icons.favorite_outline,
                            color: Colors.white,
                          ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 12, right: 12, top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 3.5,
                child: CarouselSlider(
                    items: widget._product.productImage
                        .map<Widget>((item) => Padding(
                              padding: const EdgeInsets.only(left: 3, right: 3),
                              child: Container(
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: NetworkImage(item),
                                        fit: BoxFit.fitWidth)),
                              ),
                            ))
                        .toList(),
                    options: CarouselOptions(
                        autoPlay: false,
                        enlargeCenterPage: true,
                        viewportFraction: 0.8,
                        enlargeStrategy: CenterPageEnlargeStrategy.height,
                        onPageChanged: (val, carouselPageChangedReason) {
                          setState(() {});
                        })),
              ),
              Text(
                widget._product.productName,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
              Text(widget._product.productDescription),
              const SizedBox(
                height: 10,
              ),
              Text(
                "\$ ${widget._product.productPrice.toString()}",
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: Colors.red),
              ),
              const Divider(),
              ElevatedButton(
                onPressed: () => addToCart(),
                child: const Text(
                  "Add to cart",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: selectScreen(),
    );
  }
}
