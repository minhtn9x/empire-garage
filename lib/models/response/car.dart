class CarProfile {
  final int id;
  final String carLicenseNo;
  final String carBrand;
  final String carModel;
  final List<UnresolvedProblem> unresolvedProblems;
  final List<HealthCarRecord> healthCarRecords;
  final List<OrderService> orderServices;

  CarProfile({
    required this.id,
    required this.carLicenseNo,
    required this.carBrand,
    required this.carModel,
    required this.unresolvedProblems,
    required this.healthCarRecords,
    required this.orderServices,
  });

  factory CarProfile.fromJson(Map<String, dynamic> json) {
    final unresolvedProblems = (json['unresolvedProblems'] as List)
        .map((problemJson) => UnresolvedProblem.fromJson(problemJson))
        .toList();
    final healthCarRecords = (json['healthCarRecords'] as List)
        .map((recordJson) => HealthCarRecord.fromJson(recordJson))
        .toList();
    final orderServices = (json['orderServices'] as List)
        .map((serviceJson) => OrderService.fromJson(serviceJson))
        .toList();
    return CarProfile(
      id: json['id'] as int,
      carLicenseNo: json['carLisenceNo'] as String,
      carBrand: json['carBrand'] as String,
      carModel: json['carModel'] as String,
      unresolvedProblems: unresolvedProblems,
      healthCarRecords: healthCarRecords,
      orderServices: orderServices,
    );
  }
}

class UnresolvedProblem {
  final int id;
  final String name;
  final List<String> diagnoseRecord;

  UnresolvedProblem({
    required this.id,
    required this.name,
    required this.diagnoseRecord,
  });

  factory UnresolvedProblem.fromJson(Map<String, dynamic> json) {
    final diagnoseRecord = (json['diagnoseRecord'] as List)
        .map((record) => record as String)
        .toList();
    return UnresolvedProblem(
      id: json['id'] as int,
      name: json['name'] as String,
      diagnoseRecord: diagnoseRecord,
    );
  }

  factory UnresolvedProblem.fromJson2(Map<String, dynamic> json) {
    return UnresolvedProblem(
      id: json['id'] as int,
      name: json['name'] as String,
      diagnoseRecord: [],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['problemId'] = id;
    return data;
  }
}

class HealthCarRecord {
  final int id;
  final String symptom;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int? orderServiceId;
  final List<HealthCarRecordProblem> problems;

  HealthCarRecord({
    required this.id,
    required this.symptom,
    required this.createdAt,
    required this.updatedAt,
    required this.problems,
    this.orderServiceId,
  });

  factory HealthCarRecord.fromJson(Map<String, dynamic> json) {
    final problems = (json['healthCarRecordProblems'] as List)
        .map((problemJson) => HealthCarRecordProblem.fromJson(problemJson))
        .toList();
    return HealthCarRecord(
      id: json['id'] as int,
      symptom: json['symptom'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      orderServiceId: json['orderServiceId'],
      problems: problems,
    );
  }
}

class HealthCarRecordProblem {
  final Problem problem;

  HealthCarRecordProblem({
    required this.problem,
  });

  factory HealthCarRecordProblem.fromJson(Map<String, dynamic> json) {
    final problem = Problem.fromJson(json['problem'] as Map<String, dynamic>);
    return HealthCarRecordProblem(
      problem: problem,
    );
  }
}

class Problem {
  final int id;
  final String name;
  final List<ProblemItem> items;

  Problem({
    required this.id,
    required this.name,
    required this.items,
  });

  factory Problem.fromJson(Map<String, dynamic> json) {
    var itemList = json['items'] as List<dynamic>;
    List<ProblemItem> items =
        itemList.map((itemJson) => ProblemItem.fromJson(itemJson)).toList();

    return Problem(
      id: json['id'],
      name: json['name'],
      items: items,
    );
  }
}

class ProblemItem {
  final int id;
  final String name;
  final String? photo;
  final int presentPrice;
  bool isSelected;

  ProblemItem({
    required this.id,
    required this.name,
    this.photo,
    required this.presentPrice,
    required this.isSelected,
  });

  factory ProblemItem.fromJson(Map<String, dynamic> json) {
    return ProblemItem(
      id: json['id'],
      name: json['name'],
      photo: json['photo'],
      presentPrice: json['presentPrice'],
      isSelected: json['isSelected'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['photo'] = photo;
    data['presentPrice'] = presentPrice;
    data['isSelected'] = isSelected;
    return data;
  }
}

class OrderService {
  int id;
  int status;
  String code;
  String receivingStatus;
  int prepaidFromBooking;
  Order? order;
  Expert? expert;
  List<OrderServiceDetail> orderServiceDetails;

  OrderService({
    required this.id,
    required this.status,
    required this.code,
    required this.receivingStatus,
    required this.prepaidFromBooking,
    required this.order,
    required this.expert,
    required this.orderServiceDetails,
  });

  factory OrderService.fromJson(Map<String, dynamic> json) {
    List<OrderServiceDetail> orderServiceDetails = [];
    if (json['orderServiceDetails'] != null) {
      orderServiceDetails = <OrderServiceDetail>[];
      json['orderServiceDetails'].forEach((v) {
        orderServiceDetails.add(OrderServiceDetail.fromJson(v));
      });
    }
    return OrderService(
      id: json['id'],
      status: json['status'] ?? "",
      code: json['code'] ?? "",
      receivingStatus: json['receivingStatus'],
      prepaidFromBooking: json['prepaidFromBooking'],
      order: json['order'] != null ? Order.fromJson(json['order']) : null,
      expert: json['expert'] != null ? Expert.fromJson(json['expert']) : null,
      orderServiceDetails: orderServiceDetails,
    );
  }
}

class Order {
  int id;
  String createdAt;
  String updatedAt;
  dynamic user;
  Transaction? transaction;

  Order(
      {required this.id,
      required this.createdAt,
      required this.updatedAt,
      this.user,
      this.transaction});

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
        id: json['id'],
        createdAt: json['createdAt'] ?? "",
        updatedAt: json['updatedAt'] ?? "",
        user: json['user'],
        transaction: json['transaction'] != null
            ? Transaction.fromJson(json['transaction'])
            : null);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['user'] = user;
    data['transaction'] = transaction;
    return data;
  }
}

class Transaction {
  dynamic total;
  // int paymentMethod;

  Transaction({
    required this.total,
    // required this.paymentMethod,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      total: json['total'],
      // paymentMethod: json['paymentMethod'],
    );
  }
}

class Expert {
  int id;
  String fullname;
  dynamic phone;
  String email;
  dynamic gender;

  Expert(
      {required this.id,
      required this.fullname,
      this.phone,
      required this.email,
      this.gender});

  factory Expert.fromJson(Map<String, dynamic> json) {
    return Expert(
        id: json['id'],
        fullname: json['fullname'],
        phone: json['phone'],
        email: json['email'],
        gender: json['gender']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['fullname'] = fullname;
    data['phone'] = phone;
    data['email'] = email;
    data['gender'] = gender;
    return data;
  }
}

class OrderServiceDetail {
  int id;
  int price;
  bool isConfirmed;
  bool? done;
  String? note;
  dynamic expert;
  Item item;

  OrderServiceDetail({
    required this.id,
    required this.price,
    required this.isConfirmed,
    this.done,
    this.note,
    required this.expert,
    required this.item,
  });

  factory OrderServiceDetail.fromJson(Map<String, dynamic> json) {
    return OrderServiceDetail(
      id: json['id'],
      price: json['price'],
      isConfirmed: json['isConfirmed'],
      done: json['done'],
      note: json['note'],
      expert: json['expert'],
      item: Item.fromJson(json['item']),
    );
  }
}

class Item {
  int id;
  String name;
  String createdAt;
  String updatedAt;
  String description;
  String photo;
  dynamic category;
  Problem2? problem;

  Item({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    required this.description,
    required this.photo,
    required this.category,
    this.problem,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'],
      name: json['name'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      description: json['description'],
      photo: json['photo'],
      category: json['category'],
      problem:
          json['problem'] != null ? Problem2.fromJson(json['problem']) : null,
    );
  }
}

class Problem2 {
  int id;
  String name;

  Problem2({
    required this.id,
    required this.name,
  });

  factory Problem2.fromJson(Map<String, dynamic> json) {
    return Problem2(
      id: json['id'],
      name: json['name'],
    );
  }
}
