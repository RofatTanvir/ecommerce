import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:me_ecommerce_practice/models/product.dart';

import '../product_details_screen.dart';

class ProductCard extends StatefulWidget {
  final Product _product;

  const ProductCard({super.key, required Product productCardProduct}) : _product = productCardProduct;

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
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
                child: Container(
                    color: Colors.yellow,
                    child: CachedNetworkImage(
                      imageUrl: widget._product.productImage[0],
                      fit: BoxFit.cover,
                    ))),
            Text(widget._product.productName),
            Text(widget._product.productPrice),
          ],
        ),
      ),
    );
  }
}
