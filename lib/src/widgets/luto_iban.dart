import 'package:flutter/material.dart';
import 'package:luto_redacted/luto_redacted.dart';

/// Specialized widget for IBAN numbers.
///
/// Shows only first 4 and last 4 characters when obscured, masking the
/// middle with `****`.
///
/// Example:
/// ```dart
/// LutoIban(iban: 'ES91 2100 0418 4502 0005 1332')
/// // shows: ES91 **** **** 1332 when obscured logic is in LutoText,
/// // and full IBAN when visible
/// ```
class LutoIban extends StatelessWidget {
  /// The full IBAN string.
  final String iban;

  /// Optional text style.
  final TextStyle? style;

  /// Visual style used when obscured.
  final LutoStyle lutoStyle;

  /// Creates a masked IBAN widget.
  final bool masked;

  final Widget? obscuredBuilder;
  final Color color;

  /// Creates a redacted IBAN widget.
  const LutoIban({
    super.key,
    required this.iban,
    this.masked = true,
    this.style,
    this.lutoStyle = LutoStyle.blackBar,
    this.obscuredBuilder,
    this.color = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    final maskedIban = iban.length == 29 && masked
        ? '${iban.substring(0, 4)} **** **** ${iban.substring(iban.length - 4)}'
        : iban;

    return LutoText(
      maskedIban,
      style: style,
      lutoStyle: lutoStyle,
      obscuredBuilder: obscuredBuilder,
      barColor: color,
    );
  }
}
