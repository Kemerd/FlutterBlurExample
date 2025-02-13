# Flutter Blur Rendering Test

A minimal test application to demonstrate blur rendering issues reported in [Flutter issue #162951](https://github.com/flutter/flutter/issues/162951).

## Purpose

This app provides a simple way to test and demonstrate BackdropFilter blur rendering behavior across different platforms and devices. It features:

- A checkerboard background pattern to make blur effects clearly visible
- A frosted glass container with adjustable blur intensity
- A slider to control blur amount from 0-30
- Device Preview support for testing different screen sizes and devices

## Running the Test

1. Clone this repository
2. Run `flutter pub get`
3. Launch on your target platform:
   ```bash
   flutter run -d windows  # For Windows
   flutter run -d macos   # For macOS
   flutter run -d chrome  # For web
   flutter run -d ios # For iOS
   ```

## Expected vs Actual Behavior

The app allows testing blur rendering differences between platforms and comparing against expected visual results. Use the slider to adjust blur intensity and observe any rendering artifacts or inconsistencies.

When using iOS 18 on an iPhone 16 Pro Max, the blur strength is significantly weaker than Windows.

## Related Links

- [Flutter Issue #162951](https://github.com/flutter/flutter/issues/162951)
- [BackdropFilter Documentation](https://api.flutter.dev/flutter/widgets/BackdropFilter-class.html)

## Contributing

If you observe specific blur rendering issues, please add your findings to the main issue thread with:
- Your platform/device details
- Screenshots/video demonstrating the problem
- Steps to reproduce
- Any relevant system information
