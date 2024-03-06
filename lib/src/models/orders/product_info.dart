class ProductInfo {
  ProductInfo({
    required this.name,
    required this.price,
    required this.quantity,
  });

  factory ProductInfo.fromJson(Map<String, dynamic> json) => ProductInfo(
        name: json['name'] as String,
        price: json['price'] as double,
        quantity: json['quantity'] as int,
      );

  final String name;
  final double price;
  final int quantity;

  double get total => price * quantity;

  String get roundedTotal => total.toStringAsFixed(2);

  String get roundedProductPrice => price.toStringAsFixed(2);
}
