import 'package:flutter/material.dart';
import 'package:lesgo/app/models/added_guest_model.dart';
import 'package:lesgo/app/models/search_contact_model.dart';
import 'package:lesgo/app/modules/common_widgets/contact_badge_with_close.dart';
import 'package:lesgo/app/modules/common_widgets/search_contact_badge_with_close.dart';

import '../../../master/general_utils/app_dimens.dart';

class SearchContactBadgeList extends StatelessWidget {
  const SearchContactBadgeList(
      {super.key,
        required this.lstSearchContact,
        required this.onRemoveTap,
        required this.isTripFinalized});

  final List<SearchContactModel> lstSearchContact;
  final Function onRemoveTap;
  final bool isTripFinalized;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      //restorationId: restorationId,
      scrollDirection: /*scrollDirection ??*/ Axis.horizontal,
      itemCount: lstSearchContact.length,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppDimens.paddingSmall),
        child: SearchContactBadgeWithClose(
          searchContactModel: lstSearchContact[index],
          onRemoveTap: () {
            onRemoveTap(index);
          },
          isTripFinalized: isTripFinalized,
        ),
      ),
    );
  }
}
