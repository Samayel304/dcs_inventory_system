import 'package:dcs_inventory_system/utils/type_def.dart';

import '../../models/user_model.dart';

abstract class BaseUserRepository {
  Stream<List<UserModel>> getAllUser();
  Stream<UserModel> getUser(String userId);
  FutureVoid createUser(UserModel user, String password);
  FutureVoid editUserDetails(UserModel user);
  FutureVoid changeUserPassword(String userUid, String password);
  Future<void> addDeviceToken(UserModel user, String deviceToken);
  FutureVoid changeProfilePicture(UserModel user);
}
