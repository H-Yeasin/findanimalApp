import '../../data/models/profile_model.dart';

abstract class ProfileRepository {
  Future<ProfileModel> getMyProfile();
  Future<ProfileModel> updateProfile(Map<String, dynamic> data);
  Future<void> updateFcmToken(String token);
  Future<void> deleteAccount(String password);
  Future<void> submitSupportMessage(Map<String, dynamic> data);
}
