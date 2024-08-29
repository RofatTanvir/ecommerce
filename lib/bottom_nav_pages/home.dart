import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../models/product.dart';
import '../models/product_card.dart';
import '../search_screen.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final firestoreInstance = FirebaseFirestore.instance;
  var _dotPosition = 0;
  double screenWidth = 0;
  final List<String> _carouselImages = [];
  final List<String> _categoryNames = [];
  List<Product> _products = [];
  List<Product> _productsCategorized_00 = [];
  List<Product> _productsCategorized_01 = [];
  List<Product> _productsCategorized_02 = [];
  List<Product> _productsCategorized_03 = [];

  getCategoryNames() async {
    QuerySnapshot qn = await FirebaseFirestore.instance
        .collection("products_categorized")
        .get();
    setState(() {
      for (int i = 0; i < qn.docs.length; i++) {
        _categoryNames.add(
          qn.docs[i]["category-name"],
        );
      }
    });
    return qn.docs;
  }

  showProductCategorized() {
    return Column(
      children: [
        for (int i = 0; i < _categoryNames.length; i++)
          Container(
            height: 230,
            padding: const EdgeInsets.only(left: 2.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, left: 05),
                      child: Text(
                        _categoryNames[i],
                        style:
                            TextStyle(fontSize: 15, color: Colors.red.shade700),
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
                SizedBox(
                  height: 200,
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('products_categorized')
                        .doc(_categoryNames[i])
                        .collection('items')
                        .snapshots(),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                        case ConnectionState.none:
                        case ConnectionState.active:
                        case ConnectionState.done:
                          final data = snapshot.data?.docs;

                          if (i == 0) {
                            _productsCategorized_00 = data
                                    ?.map((e) => Product.fromJson(e.data()))
                                    .toList() ??
                                [];
                          }
                          if (i == 1) {
                            _productsCategorized_01 = data
                                    ?.map((e) => Product.fromJson(e.data()))
                                    .toList() ??
                                [];
                          }
                          if (i == 2) {
                            _productsCategorized_02 = data
                                    ?.map((e) => Product.fromJson(e.data()))
                                    .toList() ??
                                [];
                          } else {
                            _productsCategorized_03 = data
                                    ?.map((e) => Product.fromJson(e.data()))
                                    .toList() ??
                                [];
                          }

                          if (_productsCategorized_00.isNotEmpty) {
                            return GridView.builder(
                                itemCount: i == 0
                                    ? _productsCategorized_00.length
                                    : i == 1
                                        ? _productsCategorized_01.length
                                        : i == 2
                                            ? _productsCategorized_02.length
                                            : _productsCategorized_03.length,
                                scrollDirection: Axis.horizontal,
                                padding: const EdgeInsets.only(top: 10),
                                physics: const BouncingScrollPhysics(),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 1, childAspectRatio: 1),
                                itemBuilder: (context, index) {
                                  return ProductCard(
                                      productCardProduct: i == 0
                                          ? _productsCategorized_00[index]
                                          : i == 1
                                              ? _productsCategorized_01[index]
                                              : i == 2
                                                  ? _productsCategorized_02[
                                                      index]
                                                  : _productsCategorized_03[
                                                      index]);
                                });
                          } else {
                            return const Center(
                              child: Text('Loading....',
                                  style: TextStyle(fontSize: 15)),
                            );
                          }
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  fetchCarouselImages() async {
    QuerySnapshot qn =
        await firestoreInstance.collection("carousel-slider").get();
    setState(() {
      for (int i = 0; i < qn.docs.length; i++) {
        _carouselImages.add(
          qn.docs[i]["img-path"],
        );
        if (kDebugMode) {
          print(qn.docs[i]["img-path"]);
        }
      }
    });

    return qn.docs;
  }

  showProduct() {
    return Container(
      height: 200,
      padding: const EdgeInsets.only(left: 2.0),
      child: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('products').snapshots(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.none:
            case ConnectionState.active:
            case ConnectionState.done:
              final data = snapshot.data?.docs;
              _products =
                  data?.map((e) => Product.fromJson(e.data())).toList() ?? [];

              if (_products.isNotEmpty) {
                return GridView.builder(
                    itemCount: _products.length,
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.only(top: 10),
                    physics: const BouncingScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1, childAspectRatio: 1),
                    itemBuilder: (context, index) {
                      return ProductCard(productCardProduct: _products[index]);
                    });
              } else {
                return const Center(
                  child: Text('Loading....', style: TextStyle(fontSize: 15)),
                );
              }
          }
        },
      ),
    );
  }

  mobileScreen() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade200,
        centerTitle: true,
        title: Text(
          "Green Shop Blue",
          style: TextStyle(
              color: Colors.green.shade700,
              fontWeight: FontWeight.normal,
              fontSize: 18),
        ),
        actions: <Widget>[
          IconButton(
            icon: const CircleAvatar(
              backgroundColor: Colors.purple,
              child: Icon(
                Icons.search,
                color: Colors.white,
                size: 20,
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchScreen()),
              );
            },
          ),
          const SizedBox(width: 10)
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 07.h),
            Stack(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.0.w),
                  child: AspectRatio(
                    aspectRatio: 3.5,
                    child: CarouselSlider(
                        items: _carouselImages
                            .map((item) => Container(
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image:
                                              CachedNetworkImageProvider(item),
                                          fit: BoxFit.fitWidth)),
                                ))
                            .toList(),
                        options: CarouselOptions(
                            autoPlay: true,
                            viewportFraction: 1.0,
                            onPageChanged: (val, carouselPageChangedReason) {
                              setState(() {
                                _dotPosition = val;
                              });
                            })),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 75.h),
                  child: Center(
                    child: DotsIndicator(
                      dotsCount:
                          _carouselImages.isEmpty ? 1 : _carouselImages.length,
                      position: _dotPosition,
                      decorator: DotsDecorator(
                        activeColor: Colors.white,
                        color: Colors.white.withOpacity(0.4),
                        spacing: EdgeInsets.symmetric(horizontal: 4.w),
                        activeSize: const Size(10, 10),
                        size: const Size(7, 7),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            Text(
              "Products",
              style: TextStyle(fontSize: 15, color: Colors.green.shade700),
            ),
            showProduct(),
            SizedBox(height: 10.h),
            Text(
              "Products Categorized",
              style: TextStyle(fontSize: 15, color: Colors.green.shade700),
            ),
            showProductCategorized(),
          ],
        ),
      ),
    );
  }

  desktopScreen() {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 08),
            Row(
              children: [
                SizedBox(width: 2.w),
                SizedBox(
                  width: 200.w,
                  child: Column(
                    children: [
                      AspectRatio(
                        aspectRatio: 4.0,
                        child: CarouselSlider(
                            items: _carouselImages
                                .map((item) => Container(
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: CachedNetworkImageProvider(
                                                  item),
                                              fit: BoxFit.fitWidth)),
                                    ))
                                .toList(),
                            options: CarouselOptions(
                                autoPlay: true,
                                viewportFraction: 1.0,
                                onPageChanged:
                                    (val, carouselPageChangedReason) {
                                  setState(() {
                                    _dotPosition = val;
                                  });
                                })),
                      ),
                      const SizedBox(height: 8),
                      DotsIndicator(
                        dotsCount: _carouselImages.isEmpty
                            ? 1
                            : _carouselImages.length,
                        position: _dotPosition,
                        decorator: DotsDecorator(
                          activeColor: Colors.orange,
                          color: Colors.grey.withOpacity(0.5),
                          spacing: const EdgeInsets.symmetric(horizontal: 3),
                          activeSize: const Size(9, 9),
                          size: const Size(6, 6),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 07.w),
                SizedBox(
                  width: 140.w,
                  child: Column(
                    children: [
                      const Text(
                        'Shop BD',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        readOnly: true,
                        decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            filled: true,
                            fillColor: Colors.grey.shade200,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            labelText: "Search Desktop Screen",
                            labelStyle: const TextStyle(color: Colors.green)),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SearchScreen()),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 05),
            showProduct(),
          ],
        ),
      ),
    );
  }

  selectScreen() {
    return screenWidth < 600 ? mobileScreen() : desktopScreen();
  }

  @override
  void initState() {
    fetchCarouselImages();
    getCategoryNames();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: selectScreen(),
    );
  }
}
