/// Luto Redacted — hide sensitive data with zero layout shift.
///
/// A privacy toolkit to protect IBAN, money, phone and any sensitive text.
/// Provides multiple masking styles, automatic protection on app background,
/// and optional native FLAG_SECURE for total screenshot blocking.
///
/// To get started, wrap your app with [LutoGuard] and use [LutoText] or the
/// specialized widgets [LutoIban], [LutoMoney], [LutoPhone].
library luto_redacted;

export 'src/core/luto_controller.dart';
export 'src/core/luto_guard.dart';
export 'src/core/luto_enums.dart';
export 'src/core/luto_secure.dart';
export 'src/widgets/luto_text.dart';
export 'src/widgets/luto_money.dart';
export 'src/widgets/luto_iban.dart';
export 'src/widgets/luto_phone.dart';
