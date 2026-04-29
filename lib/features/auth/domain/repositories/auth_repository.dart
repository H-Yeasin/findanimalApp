import '../../data/models/auth_session_model.dart';
import '../../data/models/login_request_model.dart';
import '../../data/models/register_partner_request_model.dart';
import '../../data/models/register_request_model.dart';

abstract class AuthRepository {
  Future<AuthSessionModel> login(LoginRequestModel request);

  Future<void> registerUser(RegisterRequestModel request);

  Future<void> registerPartner(RegisterPartnerRequestModel request);

  Future<void> verifyAccount({required String email, required String otp});

  Future<void> forgetPassword({required String email});

  Future<String> verifyPasswordOtp({
    required String email,
    required String otp,
  });

  Future<void> resetPassword({
    required String token,
    required String password,
    required String confirmPassword,
  });

  Future<void> logout();

  Future<String> generateAccessToken(String refreshToken);
}
