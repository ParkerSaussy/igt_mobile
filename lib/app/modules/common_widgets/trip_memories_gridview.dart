import 'package:flutter/material.dart';
import 'package:lesgo/app/modules/common_widgets/trip_memories_grid_item.dart';
import 'package:lesgo/master/generic_class/sliver_grid_delegate.dart';

class TripMemoriesGridView extends StatelessWidget {
  const TripMemoriesGridView(
      {Key? key,
      required this.lstTripMemoriesImage,
      required this.onTap,
      required this.onLongPress,
      required this.gridRestorationId})
      : super(key: key);

  final dynamic lstTripMemoriesImage;
  final Function onTap;
  final Function onLongPress;
  final String gridRestorationId;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: lstTripMemoriesImage.length,
      restorationId: gridRestorationId,
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCountAndFixedHeight(
        crossAxisCount: 3,
        crossAxisSpacing: 1,
        mainAxisSpacing: 2,
        height: 160.0,
      ),
      itemBuilder: (BuildContext context, int gridIndex) {
        return TripMemoriesGridItem(
          tripMemoriesImageModel: lstTripMemoriesImage[gridIndex],
          onTap: () {
            onTap(gridIndex);
          },
          onLongPress: () {
            onLongPress(gridIndex);
          },
        );
      },
    );
  }
}
