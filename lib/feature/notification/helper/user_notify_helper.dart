import '../../../utils/helpers/notification_helper.dart';

class UserChannel {
  final String create = "create-contact-notification";
  final String delete = "delete-contact-notification";
  final String update = "update-contact-notification";
  final String inviteAccepted = "invite-accepted-notification";
}

bool isUserOperation(String? type) {
  if (type == NotificationType.userCreated) {
    return true;
  } else if (type == NotificationType.userDeleted) {
    return true;
  } else if (type == NotificationType.userUpdated) {
    return true;
  } else if (type == NotificationType.inviteAccepted) {
    return true;
  }
  return false;
}
