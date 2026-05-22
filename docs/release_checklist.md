# Hesteka Mobile Release Checklist

Use this checklist before every Play Store or App Store submission.

## Required Production Values

Pass these values at build time. Do not commit live keys to source control.

- `API_BASE_URL`: Production HTTPS API, for example `https://api.hesteka.com/api/v1`
- `GOOGLE_MAPS_API_KEY`: Android/iOS Maps key restricted in Google Cloud
- `STRIPE_PUBLISHABLE_KEY`: Live Stripe publishable key, beginning with `pk_live_`
- `PAYPAL_CLIENT_ID`: Live PayPal REST app client ID

Create a local env file from `env/example.json`, for example `env/local.json` for development and `env/production.json` for store builds. These files are ignored by git.

Example local run:

```bash
flutter run --dart-define-from-file=env/local.json
```

Example Android build:

```bash
flutter build appbundle \
  --dart-define-from-file=env/production.json \
  --obfuscate \
  --split-debug-info=build/debug-info/android
```

Example iOS build:

```bash
flutter build ipa \
  --dart-define-from-file=env/production.json \
  --obfuscate \
  --split-debug-info=build/debug-info/ios
```

## Android Signing

Create `android/key.properties` locally:

```properties
storeFile=C:\\absolute\\path\\to\\upload-keystore.jks
storePassword=your_store_password
keyAlias=upload
keyPassword=your_key_password
```

The release build intentionally fails if this file is missing or incomplete.

## Store Readiness

- Confirm app name, package name, bundle ID, icon, and splash screen.
- Run `flutter analyze`.
- Run `flutter test`.
- Test a release build on a physical Android device.
- Test a TestFlight build on a physical iPhone.
- Confirm maps render streets, labels, and place names when using `--dart-define-from-file`.
- Confirm login, registration, OTP, password reset, logout, and token refresh.
- Confirm account deletion path exists if users can create accounts.
- Confirm privacy policy, legal notices, support, and account deletion URLs are live.
- Complete Google Play Data Safety accurately.
- Complete App Store privacy details accurately, including third-party SDK practices.
- Verify production payments with Stripe live mode.
- Verify PayPal live mode order creation, approval, capture, and webhook confirmation.
- Keep store-facing language as nonprofit support/fundraising, not paid features or digital purchases.
- Verify push notifications on Android and iOS.
- Verify location permission denied and permanently denied flows.
- Verify app behavior on slow/no network.
- Ensure screenshots match the submitted app build.

## Current Local Follow-Ups

- Replace placeholder app description in `pubspec.yaml`.
- Review iOS privacy manifest requirements for the Flutter plugins and Firebase/Stripe SDKs before App Store upload.
- Confirm Google Maps API key restrictions include Android package/signing certificate and iOS bundle ID.
