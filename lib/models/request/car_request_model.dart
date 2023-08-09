
class CarRequestModel{
  int? carId;
  String? carLisenceNo;
  String? carBrand;
  String? carModel;

  CarRequestModel({this.carLisenceNo, this.carBrand, this.carModel, this.carId});

  CarRequestModel.fromJson(Map<String, dynamic> json) {
    carLisenceNo = json['carLisenceNo'];
    carBrand = json['carBrand'];
    carModel = json['carModel'];
    carId = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['carLisenceNo'] = carLisenceNo;
    data['carBrand'] = carBrand;
    data['carModel'] = carModel;
    data['id'] = carId;
    return data;
  }
}