import 'package:empiregarage_mobile/common/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  final Color? backgroundColor;
  final Color? iconColor;
  const Loading({super.key, this.backgroundColor, this.iconColor = AppColors.blueTextColor});

  const Loading.whiteIcon({super.key, this.backgroundColor, this.iconColor = Colors.white});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FittedBox(
        child: SpinKitThreeBounce(
          color: iconColor,
          size: 30,
        ),
      ),
    );
  }
}
