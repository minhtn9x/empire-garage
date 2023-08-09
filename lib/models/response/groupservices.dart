class GroupServicesResponseModel {
  int? id;
  String? name;
  List<Item>? items;

  GroupServicesResponseModel({this.id, this.name, this.items});

  GroupServicesResponseModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    if (json['items'] != null) {
      items = <Item>[];
      json['items'].forEach((v) {
        items?.add(Item.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    if (items != null) {
      data['items'] = items?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Item {
  int? id;
  String? name;
  String? photo;
  PresentPrice? presentPrice;

  Item({this.id, this.name, this.photo, this.presentPrice});

  Item.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    photo = json['photo'];
    presentPrice = json['presentPrice'] != null
        ? PresentPrice.fromJson(json['presentPrice'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['photo'] = photo;
    if (presentPrice != null) {
      data['presentPrice'] = presentPrice?.toJson();
    }
    return data;
  }
}

class PresentPrice {
  int? id;
  int? price;
  String? priceFrom;
  int? itemId;

  PresentPrice({this.id, this.price, this.priceFrom, this.itemId});

  PresentPrice.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    price = json['price'];
    priceFrom = json['priceFrom'];
    itemId = json['itemId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['price'] = price;
    data['priceFrom'] = priceFrom;
    data['itemId'] = itemId;
    return data;
  }
}
