class OrderServiceDetailRequestModel {
  int itemId;
  double price;
  int? intendedMinutes;
  OrderServiceDetailRequestModel({
    required this.itemId,
    required this.price,
    this.intendedMinutes
  });
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['itemId'] = itemId;
    data['price'] = price;
    return data;
  }
}
