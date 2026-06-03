import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'dart:io' show Platform;

class SocialAuthResult {
  final String idToken;
  final String? authCode;
  final String? firstName;
  final String? lastName;

  SocialAuthResult({
    required this.idToken,
    this.authCode,
    this.firstName,
    this.lastName,
  });
}

final socialAuthSourceProvider = Provider<SocialAuthSource>((ref) {
  return SocialAuthSource();
});

class SocialAuthSource {
  bool _googleSignInInitialized = false;

  Future<void> _ensureGoogleSignInInitialized() async {
    if (!_googleSignInInitialized) {
      // GOOGLE_SERVER_CLIENT_ID can be provided in env/local.json
      // Make sure to add it there, e.g., "GOOGLE_SERVER_CLIENT_ID": "your-web-client-id.apps.googleusercontent.com"
      const serverClientId = String.fromEnvironment('GOOGLE_SERVER_CLIENT_ID');
      
      await GoogleSignIn.instance.initialize(
        serverClientId: serverClientId.isNotEmpty ? serverClientId : null,
      );
      _googleSignInInitialized = true;
    }
  }

  /// Signs in with Google and returns the ID token.
  /// Returns null if the user cancels the sign-in flow.
  Future<String?> signInWithGoogle() async {
    try {
      await _ensureGoogleSignInInitialized();
      
      final GoogleSignInAccount account = await GoogleSignIn.instance.authenticate(
        scopeHint: ['email', 'profile'],
      );
      
      final GoogleSignInAuthentication auth = account.authentication;
      return auth.idToken;
    } catch (e) {
      // In v7, cancellation might throw GoogleSignInException, handle it
      if (e is GoogleSignInException && e.code == GoogleSignInExceptionCode.canceled) {
        return null;
      }
      throw Exception('Google Sign-In failed: $e');
    }
  }

  /// Signs in with Apple and returns the identity token and optional user info.
  /// Returns null if the user cancels or Apple Sign-In is unavailable.
  Future<SocialAuthResult?> signInWithApple() async {
    try {
      final isAvailable = await SignInWithApple.isAvailable();
      if (!isAvailable) {
        throw Exception('Sign in with Apple is not available on this device');
      }

      // For Android (and Web), Apple Sign-In requires a clientId and redirectUri.
      // These should be configured in env/local.json:
      // "APPLE_CLIENT_ID": "com.your.bundle.id",
      // "APPLE_REDIRECT_URI": "https://your-backend.com/callbacks/sign_in_with_apple"
      const appleClientId = String.fromEnvironment('APPLE_CLIENT_ID');
      const appleRedirectUri = String.fromEnvironment('APPLE_REDIRECT_URI');

      WebAuthenticationOptions? webOptions;
      if (Platform.isAndroid || Platform.isWindows) {
        if (appleClientId.isEmpty || appleRedirectUri.isEmpty) {
          throw Exception(
              'APPLE_CLIENT_ID and APPLE_REDIRECT_URI must be provided in env/local.json for Apple Sign-In on Android.');
        }
        webOptions = WebAuthenticationOptions(
          clientId: appleClientId,
          redirectUri: Uri.parse(appleRedirectUri),
        );
      }

      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        webAuthenticationOptions: webOptions,
      );

      final identityToken = credential.identityToken;
      if (identityToken == null) {
        throw Exception('Failed to get identity token from Apple');
      }

      return SocialAuthResult(
        idToken: identityToken,
        authCode: credential.authorizationCode,
        firstName: credential.givenName,
        lastName: credential.familyName,
      );
    } on SignInWithAppleAuthorizationException catch (e) {
      if (e.code == AuthorizationErrorCode.canceled) {
        return null;
      }
      throw Exception('Apple Sign-In authorization failed: ${e.message}');
    } catch (e) {
      throw Exception('Apple Sign-In failed: $e');
    }
  }

  /// Signs out of Google.
  Future<void> signOut() async {
    try {
      await _ensureGoogleSignInInitialized();
      await GoogleSignIn.instance.signOut();
    } catch (e) {
      // Ignore errors on sign out
    }
  }
}
