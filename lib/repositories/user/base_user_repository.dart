import '../../models/user_model.dart';

abstract class BaseUserRepository {
  Stream<List<User>> getAllUser();
  Stream<User> getUser(String userId);
  Future<void> createUser(User user);
  Future<void> editUserDetails(User user);
}
