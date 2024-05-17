import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../master/general_utils/app_dimens.dart';

class ContainerTopRoundedCorner extends StatelessWidget {
  const ContainerTopRoundedCorner({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
        //margin:const EdgeInsets.only(top: 50),
        width: Get.width,
        decoration: BoxDecoration(
          color: Get.theme.colorScheme.onPrimary,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(AppDimens.radiusCircle),
            topRight: Radius.circular(AppDimens.radiusCircle),
          ),
        ),
        child: child);
  }
}
