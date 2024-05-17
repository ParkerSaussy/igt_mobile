import 'dart:typed_data';

import 'package:flutter_contacts/flutter_contacts.dart';

class SearchContactModel {
  String id;
  Name name;
  Uint8List? photo;
  List<Phone> phones;
  List<Email> emails;
  bool isSelected = false;
  String selectedRole = "Guest";
  bool isCoHost = false;

  SearchContactModel(
      {required this.id,
      required this.name,
      this.photo,
      required this.phones,
      required this.emails,
      this.isSelected = false,
      this.selectedRole = "Guest",
      this.isCoHost = false});
}
