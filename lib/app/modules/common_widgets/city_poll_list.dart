import 'package:flutter/material.dart';
import 'package:lesgo/app/models/trip_city_poll_model.dart';
import 'package:lesgo/app/modules/common_widgets/city_poll_item.dart';

class CityPollListView extends StatelessWidget {
  const CityPollListView(
      {Key? key,
      required this.isDatePollExpanded,
      required this.lstPollModel,
      required this.onSelect,
      required this.restorationId})
      : super(key: key);

  final bool isDatePollExpanded;
  final List<TripDetailsCityPollModel> lstPollModel;
  final Function onSelect;
  final String restorationId;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: lstPollModel.length >= 2
          ? isDatePollExpanded
              ? lstPollModel.length
              : 2
          : lstPollModel.length,
      shrinkWrap: true,
      restorationId: restorationId,
      padding: EdgeInsets.zero,
      physics: const ClampingScrollPhysics(),
      itemBuilder: (context, index) {
        return CityPollItem(
          onSelect: () {
            onSelect(index);
          },
          pollModel: lstPollModel[index],
          index: index,
        );
      },
    );
  }
}
