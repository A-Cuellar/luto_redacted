import 'package:flutter/material.dart';
import 'luto_text.dart';
import '../core/luto_enums.dart';

/// Specialized widget for monetary amounts.
///
/// Formats the amount with 2 decimals and a currency symbol.
///
/// Example:
/// ```dart
/// LutoMoney(amount: 1250.5, currency: '€')
/// ```
class LutoMoney extends StatelessWidget {
  /// The monetary amount.
  final double amount;

  /// Currency symbol or code, defaults to €.
  final String currency;

  /// Optional text style.
  final TextStyle? style;

  /// Visual style when obscured.
  final LutoStyle lutoStyle;

  /// Creates a redacted money widget.
  const LutoMoney({
    super.key,
    required this.amount,
    this.currency = '€',
    this.style,
    this.lutoStyle = LutoStyle.blackBar,
  });

  @override
  Widget build(BuildContext context) {
    final formatted = '$currency ${amount.toStringAsFixed(2)}';
    return LutoText(
      formatted,
      style:
          style ?? const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      lutoStyle: lutoStyle,
    );
  }
}
