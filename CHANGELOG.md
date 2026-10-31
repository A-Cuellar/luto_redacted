# Changelog

All notable changes to this project will be documented in this file.

## 0.1.0 - 2026-10-22

* Initial release.
* Added `LutoGuard` with lifecycle-aware auto-hiding.
* Added `LutoController` with `show()`, `hide()`, `toggle()`.
* Added `LutoMode` (selective, secure, both) and `LutoStyle` (blackBar, shredded, blur, noise, cubism).
* Added `LutoText` with zero layout shift support via `obscuredBuilder`.
* Added specialized widgets: `LutoIban`, `LutoMoney`, `LutoPhone`.
* Added `LutoSecure` native channel for Android FLAG_SECURE.
* Added `revealDelayOnResume` to prevent capture in recent apps preview.
* Tests included.

