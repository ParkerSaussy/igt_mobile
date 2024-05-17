import 'package:flutter/material.dart';
import 'package:lesgo/app/models/added_guest_model.dart';
import 'package:lesgo/app/modules/common_widgets/trip_guest_item.dart';

class TripGuestList extends StatelessWidget {
  const TripGuestList(
      {Key? key,
      required this.lstAddedGuest,
      required this.onTap,
      required this.restorationId})
      : super(key: key);

  final List<AddedGuestmodel> lstAddedGuest;
  final Function onTap;
  final String restorationId;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: lstAddedGuest.length,
      restorationId: restorationId,
      itemBuilder: (BuildContext context, int index) {
        return TripGuestItem(
          addedGuestModel: lstAddedGuest[index],
          onTap: () {
            onTap(index);
          },
        );
      },
    );
  }
}
