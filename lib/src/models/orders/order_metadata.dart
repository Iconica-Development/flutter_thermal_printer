class OrderMetadata {
  OrderMetadata({
    required this.userName,
    required this.shopName,
    required this.orderDate,
  });

  factory OrderMetadata.fromJson(Map<String, dynamic> json) => OrderMetadata(
        userName: json['userName'] as String,
        shopName: json['shopName'] as String,
        orderDate: DateTime.parse(json['orderDate'] as String),
      );

  final String userName;
  final String shopName;
  final DateTime orderDate;
}
