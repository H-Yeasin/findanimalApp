# Hesteka Frontend

Hesteka is a mobile application designed for animal reporting, community support, association support, and partner services.

## Features
- **Animal Reporting:** Report animals in need.
- **Community Support:** Connect and collaborate with the community.
- **Association Support:** Work together with various animal associations.
- **Partner Services:** Access integrated partner services.

## Tech Stack
- **Framework:** [Flutter](https://flutter.dev/) (SDK ^3.11.5)
- **State Management:** Riverpod (`flutter_riverpod`, `riverpod_generator`)
- **Routing:** GoRouter (`go_router`)
- **Networking:** Dio (`dio`)
- **Mapping & Location:** Google Maps (`google_maps_flutter`), Geolocator (`geolocator`), Geocoding (`geocoding`)
- **Backend Services:** Firebase Core & Messaging (`firebase_core`, `firebase_messaging`)
- **Local Storage:** Secure Storage (`flutter_secure_storage`), Shared Preferences (`shared_preferences`)

## Getting Started

This project is a starting point for a Flutter application.

### Prerequisites
Ensure you have the Flutter SDK installed on your machine.

### Installation

1. Get the dependencies:
   ```bash
   flutter pub get
   ```

2. Run code generation for Riverpod and Freezed models:
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

3. Run the app:
   ```bash
   flutter run
   ```

## Additional Resources
- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)
