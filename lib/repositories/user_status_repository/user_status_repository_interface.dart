abstract class UserStatusRepository {
  connect();
  disconnect({String? familyId = ''});
  heartBeat({String? familyId = ''});
  subscribe({String? familyId = ''});
  dispose();
}
