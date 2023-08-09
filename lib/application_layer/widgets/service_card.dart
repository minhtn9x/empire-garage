import 'package:empiregarage_mobile/common/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SerivceCard extends StatefulWidget {
  final String backgroundImage;
  final String title;
  final String price;
  final String usageCount;
  final String rating;
  final String tag;

  const SerivceCard({
    super.key,
    required this.backgroundImage,
    required this.title,
    required this.price,
    required this.usageCount,
    required this.rating,
    required this.tag,
  });

  @override
  State<SerivceCard> createState() => _SerivceCardState();
}

class _SerivceCardState extends State<SerivceCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 275.h,
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 1),
            )
          ],
          borderRadius: const BorderRadius.all(Radius.circular(20))),
      child: Column(
        children: [
          Stack(children: [
            SizedBox(
              width: double.infinity,
              height: 160.h,
              child: widget.backgroundImage != "null"
                  ? SizedBox(
                      height: 160.h,
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: ClipRRect(
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          borderRadius: BorderRadius.circular(15),
                          child: Image.network(
                            widget.backgroundImage,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    )
                  : Image.asset(
                      "assets/image/error-image/no-image.png",
                      fit: BoxFit.fitWidth,
                    ),
            ),
            Positioned(
              left: 12,
              top: 12,
              child: Container(
                height: 32.h,
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
          ListTile(
            title: Text(
              widget.title,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w600,
              ),
            ),
            trailing: Container(
              decoration: const BoxDecoration(
                  color: AppColors.green50,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              height: 35,
              width: 70,
              child: Center(
                child: Text(
                  widget.price,
                  style: const TextStyle(
                    color: Colors.green,
                    fontSize: 12,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Divider(
              thickness: 1.5,
              color: Colors.purple[50],
            ),
          ),
          ListTile(
            title: RichText(
                text: TextSpan(
                    text: widget.usageCount,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w600,
                    ),
                    children: const [
                  TextSpan(
                    text: " luợt sử dụng",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w400,
                    ),
                  )
                ])),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.star,
                  color: Colors.orange[400],
                ),
                Text(widget.rating),
              ],
            ),
          )
        ],
      ),
    );
  }
}
