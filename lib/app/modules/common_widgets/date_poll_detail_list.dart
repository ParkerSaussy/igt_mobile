import 'package:flutter/material.dart';
import 'package:lesgo/app/models/trip_date_poll_model.dart';
import 'package:lesgo/app/modules/common_widgets/date_poll_detail_item.dart';

class DatePollDetailList extends StatelessWidget {
  const DatePollDetailList({super.key, required this.lstDatePollDetail});

  final List<TripDetailsDatePollModel> lstDatePollDetail;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: lstDatePollDetail.length,
      //add restorationId
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return DatePollDetailsItem(
          tripDetailsDatePollModel: lstDatePollDetail[index],
        );
      },
    );
  }
}
