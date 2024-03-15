import "package:flutter_thermal_printer_example/src/models/product_info.dart";

class OrderInfo {
  OrderInfo({
    required this.orderId,
    required this.products,
  }) {
    totalAmount = products.fold(
      0,
      (previousValue, element) => previousValue + element.total,
    );
  }

  factory OrderInfo.fromJson(Map<String, dynamic> json) => OrderInfo(
        orderId: json["orderId"] as String,
        products: (json["products"] as List)
            .map((e) => ProductInfo.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  final String orderId;
  final List<ProductInfo> products;
  late final double totalAmount;

  String get roundedTotalAmount => totalAmount.toStringAsFixed(2);

  Map<String, dynamic> toJson() => {
        "orderId": orderId,
        "products": products.map((e) => e.toJson()).toList(),
      };
}
