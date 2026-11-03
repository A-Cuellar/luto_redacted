import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:luto_redacted/luto_redacted.dart';

/// Controls whether sensitive widgets are currently obscured.
///
/// This is a [ValueNotifier] so you can share one controller across many
/// [LutoText] widgets and toggle them all at once.
///
/// The controller starts in visible state (`false`).
///
/// Example:
/// ```dart
/// final controller = LutoController();
/// controller.obscure(); // hide data
/// controller.reveal(); // show data
/// ```
class LutoController extends ValueNotifier<bool> {
  /// Creates a controller that starts as visible (not obscured).
  LutoController({required this.mode}) : super(false);

  LutoMode mode;

  /// Whether the data is currently obscured.
  ///
  /// `true` means the content is hidden, `false` means visible.
  bool get isObscured => value;

  /// Whether the controller is configured to use [LutoMode.selective].
  ///
  /// When `true`, only [LutoText], [LutoMoney], [LutoIban] and [LutoPhone] widgets are obscured
  /// with a black bar or other style. The app switcher preview remains visible.
  ///
  /// Returns `true` if [mode] is [LutoMode.selective], `false` otherwise.
  bool get isSelectiveMode => mode == LutoMode.selective ? true : false;

  /// Whether the controller is configured to use [LutoMode.secure].
  ///
  /// When `true`, the native `FLAG_SECURE` is enabled on Android, showing a
  /// completely black screen in the app switcher and blocking screenshots.
  ///
  /// Returns `true` if [mode] is [LutoMode.secure], `false` otherwise.
  bool get isSecureMode => mode == LutoMode.secure ? true : false;

  /// Show the sensitive data (sets [isObscured] to false).
  ///
  /// Does nothing if already obscured, to avoid unnecessary rebuilds.
  void reveal() {
    if (!value) value = true;
  }

  /// Hide the sensitive data (sets [isObscured] to true).
  void obscure() {
    if (value) value = false;
  }

  /// Toggles between obscured and visible.
  void toggle() {
    value = !value;
  }
}
