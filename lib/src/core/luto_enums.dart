/// Defines how the guard protects the app when it goes to background.
enum LutoMode {
  /// Only masks widgets with a black bar / style ([LutoGuard] selective mode).
  /// This is the main purpose of this package.
  ///
  /// Best for keeping the app usable in recent apps while hiding data.
  selective, // solo banda negra
  /// Only enables native FLAG_SECURE (total white screen in multitasking).
  ///
  /// Best for banking apps that want full screenshot blocking.
  secure, // solo FLAG_SECURE (pantalla negra total)
}

/// Defines the visual style used to hide text when obscured.
enum LutoStyle {
  /// Simple black bar covering the text.
  blackBar,

  /// Shredded lines effect, like a shredded document.
  shredded,

  /// Blurs the underlying text with [ImageFilter.blur].
  blur,

  /// Random pixel noise, like static TV.
  noise,

  /// Colorful cubism / pixel mosaic effect.
  cubism,
}
