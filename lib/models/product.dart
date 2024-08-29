class Product {
  Product({
    required this.productName,
    required this.productDescription,
    required this.productPrice,
    required this.productImage,
    required this.productId,
  });

  late String productName;
  late String productDescription;
  late String productPrice;
  late List productImage;
  late String productId;

  Product.fromJson(Map<String, dynamic> json) {
    productImage = json['product-img'] ?? '';
    productName = json['product-name'] ?? '';
    productDescription = json['product-description'] ?? '';
    productPrice = json['product-price'] ?? '';
    productId = json['product-id'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['product-img'] = productImage;
    data['product-name'] = productName;
    data['product-description'] = productDescription;
    data['product-price'] = productPrice;
    data['product-id'] = productId;
    return data;
  }
}
