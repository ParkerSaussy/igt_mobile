import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lesgo/master/general_utils/constants.dart';
import 'package:lesgo/master/general_utils/images_path.dart';
import 'package:lesgo/master/general_utils/label_key.dart';
import 'package:lesgo/master/general_utils/text_styles.dart';

import '../../../master/general_utils/app_dimens.dart';

class NoInternetConnection extends StatelessWidget {
  const NoInternetConnection({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            IconPath.noInternetConnection,
            height: 200,
            width: 200,
          ),
          Text(LabelKeys.noRecordFound.tr,
              style: onBackGroundTextStyleMedium(
                fontSize: AppDimens.textLarge,
              ),
              overflow: TextOverflow.ellipsis),
          Text(
              "Whoops, no internet connection \nfound. Please check your connection",
              maxLines: 2,
              style: onBackgroundTextStyleRegular(
                  fontSize: AppDimens.textSmall, alpha: Constants.lightAlfa),
              overflow: TextOverflow.ellipsis)
        ],
      ),
    );
  }
}
