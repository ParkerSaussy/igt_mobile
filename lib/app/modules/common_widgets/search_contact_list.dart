import 'package:flutter/material.dart';
import 'package:lesgo/app/models/search_contact_model.dart';
import 'package:lesgo/app/modules/common_widgets/search_contact_item.dart';

class SearchContactList extends StatelessWidget {
  const SearchContactList({
    Key? key,
    required this.allContacts,
    required this.restorationId,
    required this.onTap,
    required this.onGuestTap,
    required this.onVipTap,
    required this.onCoHostTap,
  }) : super(key: key);

  final String restorationId;
  final List<SearchContactModel> allContacts;
  final Function onTap;
  final Function onGuestTap;
  final Function onVipTap;
  final Function onCoHostTap;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: allContacts.length,
      restorationId: restorationId,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () {
            onTap(index);
          },
          child: SearchContactItem(
            selectedContact: allContacts[index],
            onGuestTap: () {
              onGuestTap(index);
            },
            onVipTap: () {
              onVipTap(index);
            },
            onCoHostTap: () {
              onCoHostTap(index);
            },
          ),
        );
      },
    );
  }
}
