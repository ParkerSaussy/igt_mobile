import 'package:flutter/material.dart';
import 'package:lesgo/app/models/trip_memories_model.dart';
import 'package:lesgo/app/modules/common_widgets/trip_memories_item.dart';
import 'package:lesgo/master/general_utils/app_dimens.dart';
import 'package:lesgo/master/general_utils/common_stuff.dart';
import 'package:lesgo/master/general_utils/date.dart';
import 'package:lesgo/master/general_utils/text_styles.dart';

class TripMemoriesListView extends StatelessWidget {
  const TripMemoriesListView(
      {Key? key,
      required this.onTap,
      required this.onLongPress,
      required this.newList,
      required this.gridRestorationId})
      : super(key: key);

  final Function onTap;
  final Function onLongPress;
  final String gridRestorationId;
  final Map<String?, List<TripMemoriesModel>>? newList;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: AppDimens.padding90),
      itemCount: newList!.length,
      itemBuilder: (context, index) {
        String? category = newList!.keys.elementAt(index);
        final dateTime = Date.shared().dateConverter(category!);
        List itemsInCategory = newList![category]!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppDimens.paddingMedium.ph,
            Padding(
              padding: const EdgeInsets.only(
                  left: AppDimens.paddingExtraLarge,
                  right: AppDimens.paddingExtraLarge),
              child: Text(
                dateTime,
                style: onBackGroundTextStyleMedium(),
              ),
            ),
            TripMemoriesItem(
              tripMemoriesModel: itemsInCategory,
              onTap: (gridIndex) {
                onTap(gridIndex, index);
              },
              onLongPress: (gridIndex) {
                onLongPress(gridIndex, index);
              },
              gridRestorationId: gridRestorationId,
            ),
          ],
        );
      },
    );
  }
}
