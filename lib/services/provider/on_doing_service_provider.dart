import 'package:empiregarage_mobile/models/response/orderservices.dart';
import 'package:empiregarage_mobile/models/response/workload.dart';
import 'package:empiregarage_mobile/services/booking_service/booking_service.dart';
import 'package:empiregarage_mobile/services/order_services/order_services.dart';
import 'package:flutter/material.dart';

class OnDoingServiceProvider extends ChangeNotifier {
  int count = 1;
  bool isSelected = true;
  List<String> serviceNames = [
    'Thay lốp',
    'Thay nhớt',
    'Sửa chữa động cơ',
    'Kiểm tra định kỳ',
    'Thay bình ắc quy'
  ];
  List<String> servicePrices = [
    "8000000",
    "500000",
    "10000000",
    "150000",
    "200000"
  ];

  double sum = 0;
  double sumAfter = 0;
  double prepaid = 0;
  List<OrderServiceDetails> _listOrderServiceDetails = [];
  OrderServicesResponseModel? _orderServicesResponseModel;
  bool _loading = true;
  bool _expand = false;
  Workload? _workload;
  Workload? _startWorkload;

  Future<void> _getExpertWorkload(OrderServicesResponseModel model) async {
    if (model.expert != null) {
      var workload = await OrderServices()
          .getOrderServiceWorkload(model.expert!.id, model.id);
      if (workload != null) {
        var startWorkload =
        await OrderServices().getStartWorkload(model.expert!.id, model.id);
        _startWorkload = startWorkload;
      }
      _workload = workload;
      notifyListeners();
    }
  }

  Future<void> getBookingPrice() async {
    var response = await BookingService().getBookingPrice();
    prepaid = response;
    notifyListeners();
  }

  Future<void> _getOrderServices(int servicesId) async {
    var listOrderServiceDetails =
    await OrderServices().getOrderServicesById(servicesId);
    List<OrderServiceDetails>? list =
        listOrderServiceDetails!.orderServiceDetails;
    try {
      if (list != null) {
        _listOrderServiceDetails =
            list.where((element) => element.isConfirmed == true).toList();
        _orderServicesResponseModel = listOrderServiceDetails;
        for (var item in _listOrderServiceDetails) {
          sum += int.parse(item.price.toString());
        }
        sumAfter = sum - prepaid;
        await _getExpertWorkload(listOrderServiceDetails);
        _loading = false;
        notifyListeners();
      }
    } catch (e) {
      e.toString();
    }
  }

  Future<void> refresh(int servicesId) async {
    await _getOrderServices(servicesId);
  }
}
