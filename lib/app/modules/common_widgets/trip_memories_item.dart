import 'package:flutter/material.dart';
import 'package:lesgo/app/modules/common_widgets/trip_memories_gridview.dart';
import 'package:lesgo/master/general_utils/app_dimens.dart';

class TripMemoriesItem extends StatelessWidget {
  const TripMemoriesItem({
    Key? key,
    required this.tripMemoriesModel,
    required this.onTap,
    required this.onLongPress,
    required this.gridRestorationId,
  }) : super(key: key);

  //final TripMemoriesModel tripMemoriesModel;
  final Function onTap;
  final Function onLongPress;
  final String gridRestorationId;
  final List<dynamic> tripMemoriesModel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          left: AppDimens.paddingExtraLarge,
          right: AppDimens.paddingExtraLarge),
      child: Padding(
        padding: const EdgeInsets.only(top: AppDimens.paddingMedium),
        child: TripMemoriesGridView(
          lstTripMemoriesImage: tripMemoriesModel,
          onTap: (gridIndex) {
            onTap(gridIndex);
          },
          onLongPress: (gridIndex) {
            onLongPress(gridIndex);
          },
          gridRestorationId: gridRestorationId,
        ),
      ),
    );
  }
}
