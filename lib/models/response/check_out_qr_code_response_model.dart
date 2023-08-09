class CheckOutQrCodeResponseModel {
  CheckOutQrCodeResponseModel(
      {required this.orderServiceId, this.qrCode, this.isGenerating});

  int orderServiceId;
  String? qrCode;
  bool? isGenerating;

  factory CheckOutQrCodeResponseModel.fromJson(Map<String, dynamic> json) {
    return CheckOutQrCodeResponseModel(
        orderServiceId: json['orderServiceId'],
        qrCode: json['qrCode'],
        isGenerating: json['isGenerating']);
  }
}
