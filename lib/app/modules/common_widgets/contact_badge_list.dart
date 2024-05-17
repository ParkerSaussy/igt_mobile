import 'package:flutter/material.dart';
import 'package:lesgo/app/models/added_guest_model.dart';
import 'package:lesgo/app/modules/common_widgets/contact_badge_with_close.dart';

import '../../../master/general_utils/app_dimens.dart';

class ContactBadgeList extends StatelessWidget {
  const ContactBadgeList(
      {super.key,
      required this.lstAddedGuest,
      required this.onRemoveTap,
      required this.isTripFinalized});

  final List<AddedGuestmodel> lstAddedGuest;
  final Function onRemoveTap;
  final bool isTripFinalized;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      //restorationId: restorationId,
      scrollDirection: /*scrollDirection ??*/ Axis.horizontal,
      itemCount: lstAddedGuest.length,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppDimens.paddingSmall),
        child: ContactBadgeWithClose(
          addedGuestModel: lstAddedGuest[index],
          onRemoveTap: () {
            onRemoveTap(index);
          },
          isTripFinalized: isTripFinalized,
        ),
      ),
    );
  }
}
