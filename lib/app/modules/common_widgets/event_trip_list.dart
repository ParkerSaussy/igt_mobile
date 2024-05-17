import 'package:flutter/material.dart';
import 'package:lesgo/app/models/trip_list_model.dart';
import 'package:lesgo/app/modules/common_widgets/event_trip_item.dart';

class EventTripList extends StatelessWidget {
  const EventTripList(
      {Key? key,
      required this.onTap,
      required this.lstTrip,
      required this.restorationId})
      : super(key: key);

  final Function onTap;
  final List<TripListModel> lstTrip;
  final String restorationId;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: lstTrip.length,
      restorationId: restorationId,
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        return EventTripItem(
          tripListModel: lstTrip[index],
          onTap: () {
            onTap(index);
          },
        );
      },
    );
  }
}
