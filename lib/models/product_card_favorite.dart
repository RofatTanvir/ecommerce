import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:me_ecommerce_practice/models/product.dart';

import '../product_details_screen.dart';
//import '../product_details_screen.dart';

class ProductCardFavorite extends StatefulWidget {
  final Product _product;

  const ProductCardFavorite({super.key, required Product user})
      : _product = user;

  @override
  State<ProductCardFavorite> createState() => _ProductCardFavoriteState();
}

class _ProductCardFavoriteState extends State<ProductCardFavorite> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => ProductDetails(widget._product)));
        },
        child: Column(
          children: [
            AspectRatio(
                aspectRatio: 1.3,
                child: CachedNetworkImage(
                  imageUrl: widget._product.productImage[0],
                  fit: BoxFit.cover,
                )),
            Text(widget._product.productName),
            Text(widget._product.productDescription),
          ],
        ),
      ),
    );
  }
}
