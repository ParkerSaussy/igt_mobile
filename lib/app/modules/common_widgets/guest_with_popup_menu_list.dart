import 'package:flutter/material.dart';
import 'package:lesgo/app/models/added_guest_model.dart';

import 'guest_with_popup_menu_item.dart';

class GuestWithPopupMenuList extends StatelessWidget {
  const GuestWithPopupMenuList({
    Key? key,
    required this.onGuestTap,
    required this.onVIPTap,
    required this.onCoHostTap,
    required this.lstAddedGuest,
    required this.onSendTap,
    required this.onResendTap,
    required this.onRemoveTap,
    required this.isHostOrCoHost,
    required this.isTripFinalized,
    required this.onChatTapped,
  }) : super(key: key);

  final Function onGuestTap;
  final Function onVIPTap;
  final Function onCoHostTap;
  final List<AddedGuestmodel> lstAddedGuest;
  final Function onSendTap;
  final Function onResendTap;
  final Function onRemoveTap;
  final bool isHostOrCoHost;
  final bool isTripFinalized;
  final Function onChatTapped;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: lstAddedGuest.length,
      //restorationId: restorationId,
      itemBuilder: (BuildContext context, int index) {
        return GuestWithPopupMenuItem(
          isHostOrCoHost: isHostOrCoHost,
          addedGuestModel: lstAddedGuest[index],
          onChatTapped: () {
            onChatTapped(index);
          },
          onResendTap: () {
            onResendTap(index);
          },
          onRemoveTap: () {
            onRemoveTap(index);
          },
          onSendTap: () {
            onSendTap(index);
          },
          onGuestTap: () {
            onGuestTap(index);
          },
          onVIPTap: () {
            onVIPTap(index);
          },
          onCoHostTap: () {
            onCoHostTap(index);
          },
          isTripFinalized: isTripFinalized,
        );
      },
    );
  }
}
