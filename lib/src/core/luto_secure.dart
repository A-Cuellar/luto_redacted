import 'package:flutter/services.dart';

/// Native bridge to enable Android FLAG_SECURE.
///
/// This makes the app show a black screen in recent apps and blocks
/// system screenshots on Android.
///
/// On iOS it is a no-op; protection on iOS is done via [LutoGuard] selective
/// masking.
///
/// Channel name must match the native side: `com.armando.luto/secure`
class LutoSecure {
  static const _channel = MethodChannel('com.armando.luto/secure');

  /// Enables FLAG_SECURE. Total white screen in multitasking.
  static Future<void> enable() async {
    try {
      await _channel.invokeMethod('enableSecure');
    } catch (_) {}
  }

  /// Disables FLAG_SECURE, allowing screenshots again.
  static Future<void> disable() async {
    try {
      await _channel.invokeMethod('disableSecure');
    } catch (_) {}
  }

  /// Toggles FLAG_SECURE state.
  static Future<void> toggle() async {
    try {
      await _channel.invokeMethod('toggleSecure');
    } catch (_) {}
  }
}
