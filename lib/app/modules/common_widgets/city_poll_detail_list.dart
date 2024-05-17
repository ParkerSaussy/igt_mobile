import 'package:flutter/material.dart';
import 'package:lesgo/app/models/trip_city_poll_model.dart';
import 'package:lesgo/app/modules/common_widgets/city_poll_detail_item.dart';

class CityPollDetailList extends StatelessWidget {
  const CityPollDetailList({super.key, required this.lstPollDetailCity});

  final List<TripDetailsCityPollModel> lstPollDetailCity;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: lstPollDetailCity.length,
      //add restorationId
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return CityPollDetailItem(
          tripDetailsCityPollModel: lstPollDetailCity[index],
        );
      },
    );
  }
}
