class OrderServicesResponseModel {
  int id;
  int status;
  String? code;
  Expert? expert;
  Car car;
  HealthCarRecord? healthCarRecord;
  Order order;
  List<OrderServiceDetails>? orderServiceDetails;
  MaintenanceSchedule? maintenanceSchedule;

  OrderServicesResponseModel({
    required this.id,
    required this.status,
    this.expert,
    this.code,
    required this.car,
    this.healthCarRecord,
    required this.order,
    required this.orderServiceDetails,
    this.maintenanceSchedule,
  });

  factory OrderServicesResponseModel.fromJson(Map<String, dynamic> json) {
    return OrderServicesResponseModel(
      id: json['id'],
      status: json['status'],
      code: json['code'],
      expert: json['expert'] != null ? Expert.fromJson(json['expert']) : null,
      car: Car.fromJson(json['car']),
      healthCarRecord: json['healthCarRecord'] != null
          ? HealthCarRecord.fromJson(json['healthCarRecord'])
          : null,
      order: Order.fromJson(json['order']),
      orderServiceDetails: json['orderServiceDetails'] != null
          ? List<OrderServiceDetails>.from(json['orderServiceDetails']
              .map((x) => OrderServiceDetails.fromJson(x)))
          : null,
      maintenanceSchedule: json['maintenanceSchedule'] != null ? MaintenanceSchedule.fromJson(json['maintenanceSchedule']) : null,
    );
  }
}

class MaintenanceSchedule{
  DateTime maintenanceDate;
  bool? isConfirmed = false;
  MaintenanceSchedule({required this.maintenanceDate, required this.isConfirmed});
  factory MaintenanceSchedule.fromJson(Map<String, dynamic> json){
    return MaintenanceSchedule(
      maintenanceDate: DateTime.parse(json['maintenanceDate']), 
      isConfirmed: json['isConfirmed'] ?? false,
    );
  }

}

class Expert {
  int id;
  String fullname;
  String? phone; // nullable property
  String email;
  //String? gender; // nullable property

  Expert({
    required this.id,
    required this.fullname,
    this.phone,
    required this.email,
    //this.gender,
  });

  factory Expert.fromJson(Map<String, dynamic> json) {
    return Expert(
      id: json['id'],
      fullname: json['fullname'],
      phone: json['phone'],
      email: json['email'],
      //gender: json['gender'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'fullname': fullname,
        'phone': phone,
        'email': email,
        //'gender': gender,
      };
}

class Car {
  int id;
  String carLisenceNo;
  String carBrand;
  String carModel;

  Car({
    required this.id,
    required this.carLisenceNo,
    required this.carBrand,
    required this.carModel,
  });

  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
      id: json['id'],
      carLisenceNo: json['carLisenceNo'],
      carBrand: json['carBrand'],
      carModel: json['carModel'],
    );
  }
}

class HealthCarRecord {
  int? id;
  String? symptom;
  List<HealthCarRecordProblem>? healthCarRecordProblems;

  HealthCarRecord({
    required this.id,
    this.symptom,
    this.healthCarRecordProblems,
  });

  HealthCarRecord.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    symptom = json['symptom'];
    if (json['healthCarRecordProblems'] != null) {
      healthCarRecordProblems = <HealthCarRecordProblem>[];
      json['healthCarRecordProblems'].forEach((v) {
        healthCarRecordProblems?.add(HealthCarRecordProblem.fromJson(v));
      });
    }
  }
}

class HealthCarRecordProblem {
  Problem problem;
  HealthCarRecordProblem({required this.problem});
  factory HealthCarRecordProblem.fromJson(Map<String, dynamic> json) {
    return HealthCarRecordProblem(
      problem: Problem.fromJson(json['problem']),
    );
  }
}

class Problem {
  int? id;
  String? name;
  int? intendedMinutes;
  List<Item2>? items;

  Problem({
    this.id,
    this.name,
    this.items,
    this.intendedMinutes
  });

  Problem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    if (json['items'] != null) {
      items = <Item2>[];
      json['items'].forEach((v) {
        items?.add(Item2.fromJson(v));
      });
    }
    intendedMinutes = json['intendedMinutes'];
  }
}

class SlimProblem {
  int? id;
  String? name;

  SlimProblem({
    this.id,
    this.name,
  });

  SlimProblem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }
}

class Item2 {
  int id;
  String name;
  String? photo;
  double? presentPrice;
  bool isDefault = false;

  Item2(
      {required this.id,
      required this.name,
      this.photo,
      required this.presentPrice,
      required this.isDefault});

  factory Item2.fromJson(Map<String, dynamic> json) {
    return Item2(
        id: json['id'],
        name: json['name'],
        photo: json['photo'],
        presentPrice: json['presentPrice'] != null
            ? double.parse(json['presentPrice'].toString())
            : null,
        isDefault: json['isDefault'] ?? false);
  }
}

class Order {
  int id;
  String createdAt;
  String updatedAt;
  User user;
  // Transaction? transaction;

  Order({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
    // required this.transaction,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      user: User.fromJson(json['user']),
      // transaction: json['transaction'] != null
      //     ? Transaction.fromJson(json['transaction'])
      //     : null,
    );
  }
}

class User {
  String fullname;
  String phone;
  String? email;
  bool? gender;

  User({
    required this.fullname,
    required this.phone,
    this.email,
    this.gender,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      fullname: json['fullname'],
      phone: json['phone'],
      email: json['email'],
      gender: json['gender'],
    );
  }
}

class Transaction {
  int total;
  int paymentMethod;

  Transaction({
    required this.total,
    required this.paymentMethod,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      total: json['total'],
      paymentMethod: json['paymentMethod'],
    );
  }
}

class ImageModel{
  int imgId;
  String img;

  ImageModel({required this.imgId, required this.img});

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      imgId: json['id'],
      img: json['img']
    );
  }

}

class OrderServiceDetails {
  int? id;
  int? price;
  bool? isConfirmed;
  bool? done;
  String? note;
  bool showNote = false;
  Item? item;
  List<ImageModel>? images;


  OrderServiceDetails({this.id, this.price, this.isConfirmed, this.item, required this.images});

  OrderServiceDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    price = json['price'];
    isConfirmed = json['isConfirmed'];
    done = json['done'];
    note = json['note'];
    item = json['item'] != null ? Item.fromJson(json['item']) : null;
    images = json['images'] != null
        ? List<ImageModel>.from(json['images']
        .map((x) => ImageModel.fromJson(x)))
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['price'] = price;
    data['isConfirmed'] = isConfirmed;
    data['done'] = done;
    data['note'] = note;
    if (item != null) {
      data['item'] = item!.toJson();
    }
    return data;
  }

  Map<String, dynamic> toJsonLesser() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['isConfirmed'] = isConfirmed;
    return data;
  }
}

class Item {
  int? id;
  String? name;
  String? createdAt;
  String? updatedAt;
  String? description;
  String? photo;
  Category? category;
  SlimProblem? problem;
  int? warranty;

  Item(
      {this.id,
      this.name,
      this.createdAt,
      this.updatedAt,
      this.description,
      this.photo,
      this.category,
      this.problem,
      this.warranty});

  Item.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    description = json['description'];
    photo = json['photo'];
    category =
        json['category'] != null ? Category.fromJson(json['category']) : null;
    problem =
        json['problem'] != null ? SlimProblem.fromJson(json['problem']) : null;
    warranty = json['warranty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['description'] = description;
    data['photo'] = photo;
    if (category != null) {
      data['category'] = category!.toJson();
    }
    return data;
  }
}

class Category {
  int? id;
  String? name;

  Category({this.id, this.name});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}
