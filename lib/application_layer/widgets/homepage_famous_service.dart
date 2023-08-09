import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../common/colors.dart';

class HomepageFamousService extends StatefulWidget {
  final String backgroundImage;
  final String title;
  final String price;
  final String usageCount;
  final String rating;
  final String tag;

  const HomepageFamousService({
    super.key,
    required this.backgroundImage,
    required this.title,
    required this.price,
    required this.usageCount,
    required this.rating,
    required this.tag,
  });

  @override
  State<HomepageFamousService> createState() => _HomepageFamousServiceState();
}

class _HomepageFamousServiceState extends State<HomepageFamousService> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 246.w,
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(16))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
           Stack(children: [
            SizedBox(
              width: double.infinity,
              height: 180.h,
              child: widget.backgroundImage != "null"
                  ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        borderRadius: BorderRadius.circular(15),
                        child: Image.network(
                          widget.backgroundImage,
                          fit: BoxFit.cover,
                        ),
                      ),
                  )
                  : Image.asset(
                      "assets/image/error-image/no-image.png",
                      fit: BoxFit.fitWidth,
                    ),
            ),
            Positioned(
              left: 20,
              top: 20,
              child: Container(
                height: 40,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      widget.tag,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ]),
          SizedBox(height: 10.h,),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    widget.title,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.blackTextColor,
                        fontFamily: 'Roboto'),
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                      color: AppColors.green50,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  height: 20,
                  width: 80,
                  child: Center(
                    child: Text(
                      widget.price,
                      style: const TextStyle(
                        color: AppColors.greenTextColor,
                        fontSize: 10,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          Container(
            margin: const EdgeInsets.only(left: 15, right: 15),
            height: 0.1,
            width: double.infinity,
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: AppColors.grey400, // set the border color to grey
                  width: 0.5, // set the border width to 1 pixel
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: <Widget>[
                Text(
                  widget.usageCount,
                  style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w800,
                      color: AppColors.blackTextColor,
                      fontFamily: 'Roboto'),
                ),
                SizedBox(
                  width: 3.w,
                ),
                Text(
                  "lượt sử dụng",
                  style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.lightTextColor,
                      fontFamily: 'Roboto'),
                ),
                const Spacer(),
                Row(
                  children: <Widget>[
                    const Icon(
                      Icons.star,
                      size: 19,
                      color: Colors.yellow,
                    ),
                    Text(
                      widget.rating,
                      style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.lightTextColor,
                          fontFamily: 'Roboto'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
