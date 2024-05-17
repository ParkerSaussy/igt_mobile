import 'package:flutter/material.dart';
import 'package:lesgo/app/modules/common_widgets/select_display_image_item.dart';
import 'package:lesgo/master/generic_class/sliver_grid_delegate.dart';

import '../../models/trip_cover_images_model.dart';

class SelectDisplayImageListView extends StatelessWidget {
  const SelectDisplayImageListView(
      {Key? key,
      required this.lstTripCoverImage,
      required this.restorationId,
      required this.onTap,
      required this.selectedIndex})
      : super(key: key);

  final List<TripCoverImages> lstTripCoverImage;
  final String restorationId;
  final Function onTap;
  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: lstTripCoverImage.length,
      restorationId: restorationId,
      physics: const ClampingScrollPhysics(),
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCountAndFixedHeight(
        crossAxisCount: 3,
        crossAxisSpacing: 1,
        mainAxisSpacing: 2,
        height: 160.0,
      ),
      itemBuilder: (BuildContext context, int index) {
        return SelectDisplayImageItem(
          onTap: () {
            onTap(index);
          },
          selectedIndex: selectedIndex,
          index: index,
          tripCoverImages: lstTripCoverImage[index],
        );
      },
    );
  }
}
