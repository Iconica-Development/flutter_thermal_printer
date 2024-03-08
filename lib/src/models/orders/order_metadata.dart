class OrderMetadata {
  const OrderMetadata({
    required this.userName,
    required this.shopName,
    required this.orderDate,
  });

  factory OrderMetadata.fromJson(Map<String, dynamic> json) => OrderMetadata(
        userName: json["userName"] as String,
        shopName: json["shopName"] as String,
        orderDate: DateTime.parse(json["orderDate"] as String),
      );

  final String userName;
  final String shopName;
  final DateTime orderDate;

  Map<String, dynamic> toJson() => <String, dynamic>{
        "userName": userName,
        "shopName": shopName,
        "orderDate": orderDate.toIso8601String(),
      };
}
