import 'package:empiregarage_mobile/application_layer/screens/services/service_details.dart';
import 'package:empiregarage_mobile/application_layer/widgets/loading.dart';
import 'package:empiregarage_mobile/application_layer/widgets/service_card.dart';
import 'package:empiregarage_mobile/common/colors.dart';
import 'package:empiregarage_mobile/models/response/item.dart';
import 'package:empiregarage_mobile/services/item_service/item_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SearchPage extends StatefulWidget {
  final String? searchString;

  const SearchPage({super.key, this.searchString});

  @override
  // ignore: library_private_types_in_public_api
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<ItemResponseModel>? _listItem;
  List<ItemResponseModel>? _filteredItem;
  bool _loading = true;
  late String _searchString = "";
  FocusNode _focusNode = FocusNode();
  final TextEditingController _searchController = TextEditingController();
  List<String> _recentSearches = [
    // "Thay nhớt",
    // "Thay hộp số",
    // "Thay lốp",
    // "Thay gương"
  ];

  @override
  void initState() {
    if (widget.searchString != null) {
      _searchController.text = widget.searchString.toString();
      _recentSearches.add(widget.searchString.toString());
    }
    _fetchData();
    _focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  removeRecentSearch() {
    setState(() {
      _recentSearches = [];
    });
  }

  _fetchData() async {
    _listItem = await ItemService().fetchListItem(false);
    setState(() {
      _loading = false;
    });
    if (widget.searchString != null) {
      _searchString = widget.searchString.toString();
      _fitlterData(_searchString);
      if (widget.searchString!.isEmpty) {
        _filteredItem = _listItem;
      }
    } else {
      _filteredItem = _listItem;
    }
  }

  _fitlterData(seachString) {
    if (!_loading) {
      _filteredItem = _listItem!
          .where((element) =>
              element.name.toLowerCase().contains(seachString.toLowerCase()) ||
              (element.category != null &&
                  element.category!.name
                      .toLowerCase()
                      .contains(seachString.toLowerCase())))
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteTextColor,
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
        title: const Text('Tìm kiếm',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: Colors.black,
            )),
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(left: 24, right: 24),
              width: 335.w,
              height: 45.h,
              child: TextField(
                focusNode: FocusNode(canRequestFocus: true),
                onSubmitted: (value) => {
                  _fitlterData(value),
                  setState(() {
                    if (value.replaceAll(" ", "").isNotEmpty) {
                      _recentSearches.add(value);
                    }
                  }),
                  _searchString = value,
                },
                controller: _searchController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.lightGrey500,
                  focusedBorder: const OutlineInputBorder(
                      borderSide:
                          BorderSide(color: AppColors.blueTextColor, width: 3),
                      borderRadius: BorderRadius.all(Radius.circular(16))),
                  enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.all(Radius.circular(16))),
                  focusColor: AppColors.searchBarColor,
                  prefixIcon: const Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Icon(
                      Icons.search,
                      color: AppColors.lightTextColor,
                      size: 20,
                    ),
                  ),
                  hintText: 'Tìm kiếm...',
                  hintStyle: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 1.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.lightTextColor,
                  ),
                ),
              ),
            ),
            _searchString.isEmpty
                ? Expanded(
                    child: _loading
                        ? const Loading()
                        : Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: ListTile(
                                    title: const Text(
                                      'Tìm kiếm gần đây',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontFamily: 'Roboto',
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    trailing: _recentSearches.isNotEmpty
                                        ? InkWell(
                                            onTap: () => {removeRecentSearch()},
                                            child: const Text(
                                              "Xóa tất cả",
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  fontFamily: 'Roboto',
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.red),
                                            ),
                                          )
                                        : null,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: ListView(
                                  children:
                                      _recentSearches.reversed.map((search) {
                                    return ListTile(
                                      title: Text(
                                        search,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontFamily: 'Roboto',
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      leading: search.isNotEmpty
                                          ? const ImageIcon(
                                              AssetImage(
                                                  "assets/image/icon-logo/search-clock.png"),
                                              size: 20,
                                              color: AppColors.lightTextColor,
                                            )
                                          : null,
                                      horizontalTitleGap: 0,
                                      onTap: () {
                                        _searchController.text = search;
                                        setState(() {
                                          _searchString = search;
                                        });
                                        _fitlterData(search);
                                      },
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                  )
                : Expanded(
                    child: Column(children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: ListTile(
                            title: Container(
                              margin: const EdgeInsets.only(left: 15),
                              child: RichText(
                                text: TextSpan(
                                    text: 'Kết quả cho "',
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 12,
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.w600,
                                    ),
                                    children: [
                                      TextSpan(
                                          text: _searchString,
                                          style: const TextStyle(
                                            color: AppColors.blueTextColor,
                                            fontSize: 12,
                                            fontFamily: 'Roboto',
                                            fontWeight: FontWeight.w600,
                                          ),
                                          children: const [
                                            TextSpan(
                                              text: '"',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                                fontFamily: 'Roboto',
                                                fontWeight: FontWeight.w600,
                                              ),
                                            )
                                          ])
                                    ]),
                              ),
                            ),
                            trailing: Container(
                              margin: const EdgeInsets.only(right: 15),
                              child: Text(
                                _filteredItem != null
                                    ? "${_filteredItem!.length} tìm kiếm"
                                    : "0 tìm kiếm",
                                style: const TextStyle(
                                    fontSize: 10,
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.blueTextColor),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: _loading
                            ? const Loading()
                            : _filteredItem!.isEmpty
                                ? ListView(children: [
                                    Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.all(30),
                                            child: Image.asset(
                                              "assets/image/error-image/not-founded.png",
                                            ),
                                          ),
                                          ListTile(
                                            title: Padding(
                                              padding: EdgeInsets.all(30.h),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: const [
                                                  Text(
                                                    'Không thể tìm thấy',
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      fontFamily: 'Roboto',
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            subtitle: const Text(
                                                'Rất tiếc từ khóa bạn nhập không tìm thấy, vui lòng kiểm tra lại hoặc tìm với từ khóa khác.',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  height: 1.5,
                                                  fontFamily: 'Roboto',
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 12,
                                                  color: Colors.black,
                                                )),
                                          ),
                                        ]),
                                  ])
                                : ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    itemCount: _filteredItem!.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Column(
                                        children: [
                                          InkWell(
                                            onTap: () => Get.to(
                                              () => ServiceDetails(
                                                itemId:
                                                    _filteredItem![index].id,
                                              ),
                                            ),
                                            child: Container(
                                              margin: const EdgeInsets.only(
                                                  left: 24, right: 24),
                                              child: SerivceCard(
                                                  backgroundImage:
                                                      _filteredItem![index]
                                                          .photo,
                                                  title: _filteredItem![index]
                                                      .name,
                                                  price: _filteredItem![index]
                                                          .prices!
                                                          .isNotEmpty
                                                      ? _filteredItem![index]
                                                          .prices!
                                                          .first
                                                          .price
                                                          .toString()
                                                      : "Liên hệ",
                                                  usageCount: "182",
                                                  rating: "4.4",
                                                  tag: _filteredItem![index]
                                                              .category !=
                                                          null
                                                      ? _filteredItem![index]
                                                          .category!
                                                          .name
                                                      : "Dịch vụ"),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 25,
                                          )
                                        ],
                                      );
                                    }),
                      ),
                    ]),
                  )
          ],
        ),
      ),
    );
  }
}
