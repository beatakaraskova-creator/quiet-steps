# Quiet Steps

Private offline step tracker. No GPS. No internet. Data stays on the phone.

Not a medical device. Does not diagnose, treat, cure or prevent any condition.

## What it does

- Counts steps from the phone hardware sensor
- Estimates km from your stride
- Estimates kcal from weight × distance
- Daily goal ring and 90-day local history
- Background counting via a quiet notification (Android)

## Run it on your Android phone

You need:

1. [Flutter](https://docs.flutter.dev/get-started/install)
2. Android Studio (for the Android SDK)
3. USB debugging on your phone

Then:

```bash
cd quiet_steps
flutter pub get
flutter run
```

The first time Android will ask for **Physical activity** and **Notifications**. Allow both. Location is not requested.

On some phones (Xiaomi, Huawei, Oppo, Samsung) also:

- Settings → Apps → Quiet Steps → Battery → **Unrestricted**
- Allow the app to auto-start if that menu exists

The emulator has no step sensor. Use a real phone.

## Build an install file

```bash
flutter build apk --release
```

APK path: `build/app/outputs/flutter-apk/app-release.apk`

Copy that file to the phone and open it.

For Play Store later:

```bash
flutter build appbundle --release
```

## Play Store notes

- Privacy policy page (public URL)
- Data safety: health / steps, stored on device, not shared
- Health declaration: activity and fitness
- Store text must include: not a medical device

Package name: `com.wain.quiet_steps`
