class ModelSymptom {
  String? symptomName;
  double? expectedPrice;

  ModelSymptom({
    this.symptomName,
    this.expectedPrice
  });

  factory ModelSymptom.fromJson(Map<String, dynamic> json) {
    return ModelSymptom(
      symptomName: json['symptomName'],
      expectedPrice: json['expectedPrice'] != null ? double.parse(json['expectedPrice'].toString()) : 0.0
    );
  }
}