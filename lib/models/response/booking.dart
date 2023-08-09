import 'package:empiregarage_mobile/models/response/car.dart';
import 'package:empiregarage_mobile/models/response/symptoms.dart';

class BookingResponseModel {
  BookingResponseModel({
    required this.id,
    this.code,
    required this.date,
    this.arrivedDateTime,
    required this.isArrived,
    required this.isActived,
    this.dayLeft,
    required this.user,
    required this.car,
    required this.symptoms,
    required this.unresolvedProblems,
    required this.total,
  });

  int id;
  String? code;
  String date;
  String? arrivedDateTime;
  bool isArrived;
  bool isActived;
  int? dayLeft;
  double total;
  UserSlimResponse user;
  CarResponseModel car;
  List<SymptonResponseModel> symptoms = [];
  List<UnresolvedProblem> unresolvedProblems = [];

  factory BookingResponseModel.fromJson(Map<String, dynamic> json) {
    return BookingResponseModel(
      id: json['id'],
      code: json['code'],
      date: json['date'],
      arrivedDateTime: json['arrivedDateTime'],
      isArrived: json['isArrived'],
      isActived: json['isActived'],
      dayLeft: json['dayLeft'],
      user: UserSlimResponse.fromJson(json['user']),
      car: CarResponseModel.fromJson(json['car']),
      symptoms: (json['symptoms'] as List)
          .map((e) => SymptonResponseModel.fromJson(e))
          .toList(),
      unresolvedProblems: (json['unresolvedProblems'] as List)
          .map((e) => UnresolvedProblem.fromJson2(e))
          .toList(),
      total: json['transaction']['total'] != null ? double.parse(json['transaction']['total'] .toString()) : 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'code': code,
        'date': date,
        'isArrived': isArrived,
        'isActived': isActived,
        'daysLeft': dayLeft,
        'user': user,
        'car': car,
      };
}

class UserSlimResponse {
  UserSlimResponse({
    required this.fullname,
    required this.phone,
    this.email,
    this.gender,
  });

  String fullname;
  String phone;
  String? email;
  bool? gender;

  factory UserSlimResponse.fromJson(Map<String, dynamic> json) {
    return UserSlimResponse(
      fullname: json['fullname'],
      phone: json['phone'],
      email: json['email'],
      gender: json['gender'],
    );
  }
}

class CarResponseModel {
  CarResponseModel({
    required this.id,
    required this.carLisenceNo,
    required this.carBrand,
    required this.carModel,
    required this.isNew,
    this.haveBooking = false,
    this.isInGarage = false,
  });

  int id;
  String carLisenceNo;
  String carBrand;
  String carModel;
  bool isNew = true;
  bool haveBooking;
  bool isInGarage;

  factory CarResponseModel.fromJson(Map<String, dynamic> json) {
    return CarResponseModel(
      id: json['id'],
      carLisenceNo: json['carLisenceNo'],
      carBrand: json['carBrand'],
      carModel: json['carModel'],
      isNew: json['isNew'],
      haveBooking: json['haveBooking'] ?? false,
      isInGarage: json['isInGarage'] ?? false,
    );
  }
}
