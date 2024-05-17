import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lesgo/app/modules/common_widgets/remove_over_scroll_effect.dart';
import 'package:lesgo/master/general_utils/images_path.dart';
import 'package:lesgo/master/general_utils/label_key.dart';
import 'package:lesgo/master/general_utils/text_styles.dart';

import '../../../master/general_utils/app_dimens.dart';

class NoRecordFound extends StatelessWidget {
  const NoRecordFound({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return Center(
      child: RemoveOverScrollEffect(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                IconPath.noRecordFound,
                height: 200,
                width: 200,
              ),
              Text(LabelKeys.noRecordFound.tr,
                  style: onBackGroundTextStyleMedium(
                    fontSize: AppDimens.textLarge,
                  ),
                  overflow: TextOverflow.ellipsis)
            ],
          ),
        ),
      ),
    );
  }
}
