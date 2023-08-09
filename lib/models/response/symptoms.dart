class SymptonResponseModel{
  SymptonResponseModel({
    required this.id,
    this.name,
    this.intendedMinutes
  });

  int id;
  String? name;
  int? intendedMinutes;
  double? expectedPrice;

  factory SymptonResponseModel.fromJson(Map<String,dynamic> json){
    return SymptonResponseModel(
      id: json['id'], 
      name: json['name'], 
      intendedMinutes: json['intendedMinutes']);
  }
}