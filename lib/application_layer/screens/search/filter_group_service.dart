import 'package:empiregarage_mobile/application_layer/widgets/service_card.dart';
import 'package:empiregarage_mobile/common/colors.dart';
import 'package:empiregarage_mobile/models/response/groupservices.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FilterGroupService extends StatefulWidget {
  final GroupServicesResponseModel filterGroupServices;

  const FilterGroupService({super.key, required this.filterGroupServices});

  @override
  State<FilterGroupService> createState() => _FilterGroupServiceState();
}

class _FilterGroupServiceState extends State<FilterGroupService> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGrey,
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.transparent,
              border: Border.all(
                color: AppColors.searchBarColor,
                width: 1.0,
              ),
            ),
            child: IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: const Icon(
                  Icons.arrow_back_outlined,
                  color: AppColors.blackTextColor,
                )),
          ),
        ),
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        centerTitle: true,
        title: Text(widget.filterGroupServices.name.toString(),
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: Colors.black,
            )),
      ),
      body: ListView.builder(
        itemCount: widget.filterGroupServices.items!.length,
        itemBuilder: (BuildContext context, int index) {
          var item = widget.filterGroupServices.items![index];
          return Padding(
            padding: const EdgeInsets.all(10),
            child: SerivceCard(
                backgroundImage: item.photo.toString(),
                title: item.name.toString(),
                price: item.presentPrice!.price.toString(),
                usageCount: "128",
                rating: "4.4",
                tag: widget.filterGroupServices.name.toString()),
          );
        },
      ),
    );
  }
}
