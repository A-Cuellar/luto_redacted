import 'package:flutter/material.dart';
import 'package:luto_redacted/src/core/luto_enums.dart';
import 'luto_text.dart';

/// Specialized widget for phone numbers.
///
/// Masks the middle digits, keeping first and last 3 visible.
///
/// Example:
/// ```dart
/// LutoPhone(phoneNumber: '+34 600 123 456')
/// ```
class LutoPhone extends StatelessWidget {
  /// Full phone number.
  final String phoneNumber;

  /// Optional text style.
  final TextStyle? style;

  /// Visual style when obscured.
  final LutoStyle lutoStyle;

  ///Creates a masked phone number widget.
  final bool masked;

  final Widget? obscuredBuilder;
  final Color color;

  /// Creates a redacted phone widget.
  const LutoPhone({
    super.key,
    required this.phoneNumber,
    this.style,
    this.masked = true,
    this.lutoStyle = LutoStyle.blackBar,
    this.obscuredBuilder,
    this.color = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    final maskedPhoneNumber = phoneNumber.length > 9
        ? '${phoneNumber.substring(0, 3)} ***** ${phoneNumber.substring(phoneNumber.length - 3)}'
        : '${phoneNumber.substring(0, 3)} ***** ${phoneNumber.substring(phoneNumber.length - 1)}';

    return LutoText(
      masked ? maskedPhoneNumber : phoneNumber,
      style: style,
      lutoStyle: lutoStyle,
      obscuredBuilder: obscuredBuilder,
      barColor: color,
    );
  }
}
