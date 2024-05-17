import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:lesgo/app/modules/common_widgets/trip_card_item.dart';

import '../../../master/general_utils/app_dimens.dart';
import '../../../master/general_utils/constants.dart';
import '../../models/trip_details_model.dart';

class TripCardList extends StatelessWidget {
  final List<TripDetailsModel> modelList;
  final Axis? scrollDirection;
  final String restorationId;
  final double? childWidth;
  final ScrollPhysics? scrollPhysics;
  final Function onItemClicked;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Function onBarChartTap;
  final Function onChatTap;
  final bool? isTop;
  final bool? showStatus;
  final ScrollController? scrollController;
  final bool isLast;
  final bool isPastTrip;

  const TripCardList({
    Key? key,
    required this.modelList,
    this.scrollDirection,
    required this.onItemClicked,
    required this.restorationId,
    this.childWidth,
    this.scrollPhysics,
    this.margin,
    this.isTop = false,
    this.showStatus = false,
    this.scrollController,
    required this.isLast,
    this.padding,
    required this.onChatTap,
    required this.onBarChartTap,
    required this.isPastTrip,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: padding ?? EdgeInsets.zero,
        restorationId: restorationId,
        scrollDirection: scrollDirection ?? Axis.vertical,
        itemCount: modelList.length,
        controller: scrollController,
        shrinkWrap: true,
        physics: scrollPhysics ?? const BouncingScrollPhysics(),
        itemBuilder: (context, int index) {
          return Bounce(
            duration: const Duration(milliseconds: Constants.bounceDuration),
            onPressed: () {
              onItemClicked(index);
            },
            child: TripCardItem(
              isPastTrip: isPastTrip,
              childWidth: childWidth ?? double.infinity,
              margin: margin ??
                  const EdgeInsets.symmetric(
                    horizontal: AppDimens.paddingSmall,
                  ),
              model: modelList[index],
              index: index,
              showStatus: showStatus,
              onChatTap: () {
                onChatTap(index);
              },
              onBarChartTap: () {
                onBarChartTap(index);
              },
            ),
          );
        });
  }
}
