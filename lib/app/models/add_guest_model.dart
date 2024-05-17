class AddGuestModel {
  String tripId;
  String firstName;
  String lastName;
  String emailId;
  String phone;
  String role;
  bool isCoHost;
  String inviteStatus;

  AddGuestModel({
    required this.tripId,
    required this.firstName,
    required this.lastName,
    required this.emailId,
    required this.phone,
    required this.role,
    required this.isCoHost,
    required this.inviteStatus,
  });
}
