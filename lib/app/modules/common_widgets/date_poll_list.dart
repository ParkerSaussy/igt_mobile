import 'package:flutter/material.dart';
import 'package:lesgo/app/models/trip_date_poll_model.dart';
import 'package:lesgo/app/modules/common_widgets/date_poll_item.dart';

class PollListView extends StatelessWidget {
  const PollListView(
      {Key? key,
      required this.isDatePollExpanded,
      required this.lstPollModel,
      required this.onSelect,
      required this.restorationId})
      : super(key: key);

  final bool isDatePollExpanded;
  final List<TripDetailsDatePollModel> lstPollModel;
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
        return PollItem(
          index: index,
          onSelect: () {
            onSelect(index);
          },
          pollModel: lstPollModel[index],
        );
      },
    );
  }
}
