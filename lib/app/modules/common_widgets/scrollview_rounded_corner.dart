import 'package:flutter/material.dart';
import 'package:lesgo/app/modules/common_widgets/remove_over_scroll_effect.dart';

import '../../../master/general_utils/app_dimens.dart';

class ScrollViewRoundedCorner extends StatelessWidget {
  const ScrollViewRoundedCorner({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(AppDimens.radiusCircle),
        topRight: Radius.circular(AppDimens.radiusCircle),
      ),
      child: RemoveOverScrollEffect(
        child: SingleChildScrollView(child: child),
      ),
    );
  }
}
