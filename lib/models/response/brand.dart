class BrandResponseModel {
  BrandResponseModel({
    required this.id,
    required this.name,
    required this.models,
  });

  final int id;
  final String name;
  final List<ModelResponseModel> models;

  factory BrandResponseModel.fromJson(Map<String, dynamic> json) {
    var modelList = json['models'] as List<dynamic>;
    List<ModelResponseModel> models =
        modelList.map((model) => ModelResponseModel.fromJson(model)).toList();

    return BrandResponseModel(
      id: json['id'] as int,
      name: json['name'] as String,
      models: models,
    );
  }
}

class BrandSlimModel {
  BrandSlimModel({
    required this.id,
    required this.name,
    this.photo,
  });

  final int id;
  final String name;
  final String? photo;

  factory BrandSlimModel.fromJson(Map<String, dynamic> json) {
    return BrandSlimModel(
        id: json['id'] as int,
        name: json['name'] as String,
        photo: json['photo']);
  }
}

class ModelResponseModel {
  ModelResponseModel({
    required this.id,
    required this.code,
    required this.name,
  });

  final int id;
  final String code;
  final String name;
  factory ModelResponseModel.fromJson(Map<String, dynamic> json) {
    return ModelResponseModel(
      id: json['id'] as int,
      code: json['code'] as String,
      name: json['name'] as String,
    );
  }
}

class ModelSlimResponse {
  ModelSlimResponse({
    required this.id,
    required this.name,
  });

  final int id;
  final String name;
  factory ModelSlimResponse.fromJson(Map<String, dynamic> json) {
    return ModelSlimResponse(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }
}

class ModelSymptomResponse {
  ModelSymptomResponse({
    this.symptomName,
    this.expectedPrice,
  });

  final String? symptomName;
  final double? expectedPrice;
  factory ModelSymptomResponse.fromJson(Map<String, dynamic> json) {
    return ModelSymptomResponse(
      symptomName: json['symptomName'],
      expectedPrice: json['expectedPrice'],
    );
  }
}
