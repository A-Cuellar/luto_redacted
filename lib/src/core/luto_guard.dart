import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'luto_controller.dart';
import 'luto_enums.dart';
import 'luto_secure.dart';

/// Root widget that automatically protects sensitive data when the app
/// goes to background / inactive state.
///
/// Wrap your MaterialApp or Scaffold with it. All [LutoText] widgets inside
/// will react to the same controller.
///
/// It listens to [WidgetsBindingObserver] and when the app goes to
/// [AppLifecycleState.inactive] or [paused], it obscures data and/or
/// enables FLAG_SECURE depending on [mode].
///
/// When the app resumes, it keeps data hidden for [revealDelayOnResume]
/// to prevent a frame of sensitive data being captured in the screenshot
/// preview of recent apps.
///
/// Example:
/// ```dart
/// LutoGuard(
///   mode: LutoMode.selective,
///   style: LutoStyle.blackBar,
///   child: MyApp(),
/// )
/// ```
class LutoGuard extends StatefulWidget {
  /// The child widget tree that contains sensitive data.
  final Widget child;

  /// Optional external controller. If null, an internal one is created.
  ///
  /// Use an external controller if you want to toggle manually with a button.
  final LutoController? controller;

  /// Whether to enable protection when app becomes inactive.
  ///
  /// Defaults to true. Set to false if you only want manual control.
  final bool enableOnInactive;

  /// How protection is applied when backgrounding.
  ///
  /// See [LutoMode] for options.
  final LutoMode mode;

  /// Visual style for hiding.
  ///
  /// Currently only affects widgets that use the default implementation.
  final LutoStyle style;

  /// Delay before revealing data again after resume.
  ///
  /// This prevents the sensitive frame being captured in the multitasking
  /// screenshot. Defaults to 500ms.
  final Duration revealDelayOnResume;

  /// Creates a guard that watches app lifecycle and protects data.
  const LutoGuard({
    super.key,
    required this.child,
    this.controller,
    this.enableOnInactive = true,
    this.mode = LutoMode.selective,
    this.style = LutoStyle.blackBar,
    this.revealDelayOnResume = const Duration(milliseconds: 500),
  });

  /// Retrieves the nearest [LutoController] from the context.
  ///
  /// Used internally by [LutoText] via `LutoGuard.of(context)`.
  /// Throws if no [LutoGuard] is found above in the tree.
  static LutoController of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_LutoInherited>()!
        .controller;
  }

  @override
  State<LutoGuard> createState() => _LutoGuardState();
}

class _LutoGuardState extends State<LutoGuard> with WidgetsBindingObserver {
  late final LutoController _internalController;
  LutoController get _controller => widget.controller ?? _internalController;

  @override
  void initState() {
    super.initState();
    _internalController = LutoController(mode: widget.mode);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    if (widget.controller == null) {
      _internalController.dispose();
    }
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!widget.enableOnInactive) return;

    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.hidden ||
        state == AppLifecycleState.paused) {
      if (widget.mode == LutoMode.selective) {
        _controller.reveal();
      }
      if (widget.mode == LutoMode.secure) {
        LutoSecure.enable();
      }
    }

    if (state == AppLifecycleState.resumed) {
      //if (widget.mode == LutoMode.secure) {
      //  LutoSecure.enable();
      //}
      // INTENTO DE ANTI-CAPTURA: mantenemos tapado X ms después de volver
      // TODO: Mejorarlo o eliminarlo, se verá más adelante
      if (widget.mode == LutoMode.selective) {
        Future.delayed(widget.revealDelayOnResume, () {
          if (mounted) {
            //LutoSecure.disable();
            _controller.obscure();
          }
        });
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    assert(() {
      // En este momento, mi propio _LutoInherited aún NO está en el árbol,
      // porque lo creo en build(). Así que si encuentro uno, es mi padre.
      final parent = context.getInheritedWidgetOfExactType<_LutoInherited>();
      if (parent != null) {
        developer.log(
          level: 900,
          name: 'luto_redacted',
          '⚠️ [luto_redacted] WARNING: Nested LutoGuard detected. '
          'LutoText will use the nearest guard.',
        );
      }
      return true;
    }());
  }

  @override
  Widget build(BuildContext context) {
    return _LutoInherited(controller: _controller, child: widget.child);
  }

  @override
  void didUpdateWidget(LutoGuard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.mode != widget.mode) {
      _controller.mode = widget.mode;
    }
  }
}

/// The controller shared down the tree.
class _LutoInherited extends InheritedWidget {
  final LutoController controller;
  const _LutoInherited({required this.controller, required super.child});

  @override
  bool updateShouldNotify(_LutoInherited oldWidget) =>
      controller != oldWidget.controller;
}
