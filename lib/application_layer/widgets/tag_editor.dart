import 'package:empiregarage_mobile/common/style.dart';
import 'package:empiregarage_mobile/helper/common_helper.dart';
import 'package:empiregarage_mobile/models/response/symptoms.dart';
import 'package:empiregarage_mobile/services/model_services/model_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../common/colors.dart';

class TagEditor extends StatefulWidget {
  final List<SymptonResponseModel> options;
  final void Function(List<SymptonResponseModel>) onChanged;
  final void Function(bool) emptySymptom;
  final int modelId;

  const TagEditor({
    super.key,
    required this.onChanged,
    required this.options,
    required this.emptySymptom,
    required this.modelId,
  });

  @override
  // ignore: library_private_types_in_public_api
  _TagEditorState createState() => _TagEditorState();
}

class _TagEditorState extends State<TagEditor> {
  final TextEditingController _controller = TextEditingController();
  List<SymptonResponseModel> _selectedTags = [];
  List<SymptonResponseModel> _suggestedTags = [];

  @override
  void initState() {
    super.initState();
    _selectedTags = [];
  }

  _onSelectSymtomAndCar(int symptomId) async {
    var modelSymptom =
        await ModelService().getExpectedPrice(widget.modelId, symptomId);
    if (modelSymptom != null) {
      return modelSymptom.expectedPrice;
    }
  }

  Future<double> _sumExpectedPrice() async {
    double sum = 0;
    for (var element in _selectedTags) {
      sum += element.expectedPrice ?? 0;
    }
    return sum;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _controller,
          decoration: InputDecoration(
            hintText: 'Chọn triệu chứng',
            hintStyle: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.grey500,
            ),
            border: MaterialStateOutlineInputBorder.resolveWith((states) =>
                const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                    borderSide: BorderSide(color: AppColors.grey200))),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            suffixIcon: const Icon(Icons.arrow_drop_down_rounded),
          ),
          onTap: () {
            setState(() {
              _suggestedTags = widget.options;
            });
            widget.emptySymptom(false);
          },
          onChanged: (value) async {
            setState(() {
              // You'll need to replace this with your own logic for
              // generating tag suggestions based on the user's input.
              _suggestedTags = widget.options.where((tag) {
                return tag.name!.toLowerCase().contains(value.toLowerCase());
              }).toList();
            });
          },
          onFieldSubmitted: (value) {
            if (value.isNotEmpty) {
              setState(() {
                _controller.clear();
                var result = widget.options.where((tag) {
                  return tag.name!.toLowerCase().contains(value.toLowerCase());
                });
                if (result.toList().isNotEmpty) {
                  if (_selectedTags
                      .where((element) => element.id == result.first.id)
                      .isEmpty) {
                    _selectedTags.add(result.first);
                    widget.onChanged(_selectedTags);
                  }
                } else {
                  // _selectedTags.add(widget.options.where((element) => element.name!.contains(value)).first);
                }
                _suggestedTags.clear();
              });
            }
          },
        ),
        if (_suggestedTags.isNotEmpty)
          Container(
            decoration: BoxDecoration(
                border: Border.all(color: AppColors.grey200),
                borderRadius: BorderRadius.circular(16)),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _suggestedTags.length,
              itemBuilder: (context, index) {
                final tag = _suggestedTags[index];
                return InkWell(
                  onTap: () {
                    setState(() {
                      _controller.clear();
                      if (_selectedTags
                          .where((element) => element.id == tag.id)
                          .isEmpty) {
                        _selectedTags.add(tag);
                        widget.onChanged(_selectedTags);
                      }
                      _suggestedTags = [];
                    });
                  },
                  child: Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 16),
                      child: Text(
                        tag.name.toString(),
                        style: AppStyles.text400(fontsize: 12.sp),
                      )),
                );
              },
            ),
          ),
        Visibility(
          visible: _selectedTags.isNotEmpty,
          child: Padding(
            padding: const EdgeInsets.only(top: 15, bottom: 5),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Mục",
                    style: AppStyles.header600(fontsize: 12.sp),
                  ),
                  Row(
                    children: [
                      Text(
                        "Giá dự kiến tối thiểu",
                        style: AppStyles.header600(fontsize: 12.sp),
                      ),
                      const SizedBox(
                        width: 28,
                      ),
                    ],
                  ),
                ]),
          ),
        ),
        ListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: _selectedTags.map((tag) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    tag.name.toString(),
                    style: AppStyles.text400(fontsize: 10.sp),
                  ),
                  Row(
                    children: [
                      tag.expectedPrice == null
                          ? Text(
                              "Định giá sau chẩn đoán",
                              style: AppStyles.text400(fontsize: 10.sp),
                            )
                          : Text(
                            formatCurrency(tag.expectedPrice),
                            style: AppStyles.text400(fontsize: 10.sp),
                          ),
                      const SizedBox(
                        width: 10,
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            _selectedTags.remove(tag);
                            widget.onChanged(_selectedTags);
                          });
                        },
                        child: const Icon(
                          Icons.cancel,
                          size: 18,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            );
          }).toList(),
        ),
        Visibility(
          visible: _selectedTags.isNotEmpty,
          child: Column(
            children: [
              AppStyles.divider(padding: EdgeInsets.zero),
              Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 5),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Tổng chi phí dự kiến tối thiểu",
                        style: AppStyles.header600(fontsize: 12.sp),
                      ),
                      Row(
                        children: [
                          FutureBuilder(
                            future: _sumExpectedPrice(),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return Text(
                                  '0',
                                  style: AppStyles.header600(fontsize: 12.sp),
                                );
                              }
                              if (!snapshot.hasData) {
                                return Text(
                                  "0",
                                  style: AppStyles.header600(fontsize: 12.sp),
                                );
                              }
                              return Text(
                                formatCurrency(snapshot.data),
                                style: AppStyles.header600(fontsize: 12.sp),
                              );
                            },
                          ),
                          const SizedBox(
                            width: 28,
                          ),
                        ],
                      ),
                    ]),
              ),
              AppStyles.divider(padding: EdgeInsets.zero),
            ],
          ),
        ),
      ],
    );
  }
}
