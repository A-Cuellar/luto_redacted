# luto_redacted

> **Selective black-bar redaction for sensitive data. Zero layout shift.**

`luto_redacted` is a Flutter privacy toolkit to hide IBAN, money, phone and any sensitive text when the app goes to background. Instead of turning the whole screen black (like `FLAG_SECURE`), it applies a **luto effect**: only the sensitive data wears mourning black.

**A selective, beautiful, zero-layout-shift alternative to `screen_protector` and `privacy_lens`.**

[pub package](https://pub.dev/packages/luto_redacted)

## Features

- **Zero Layout Shift:** Uses a transparent placeholder with the exact same size. No jumps.
- **5 Luto Styles:** `blackBar`, `blur`, `shredded`, `noise`, `cubism`
- **Specialized widgets:** `LutoIban`, `LutoMoney`, `LutoPhone`, `LutoText`
- **Two protection modes:**
  - `LutoMode.selective` -> only masks widgets (ideal for modern fintech UX)
  - `LutoMode.secure` -> enables native `FLAG_SECURE` (total black screen + screenshot blocking)
- **Auto-protection:** Listens to `inactive / paused / hidden` via `WidgetsBindingObserver`
- **Manual control:** `LutoController` for toggle 
- **Custom builder:** Provide your own `obscuredBuilder`
- **Anti-capture delay:** `revealDelayOnResume` prevents a sensitive frame being captured

## Screenshots

| State | Description |
|-------|-------------|
| **Visible** | App without protection - all data visible, as the user sees it |

[Visible - No luto activated](screenshots/visible.png)

#### Luto Styles

| Style | Description | Preview |
|-------|-------------|---------|
| **blackBar** | Solid black bar covering the text. The default banking classic. | [blackBar - default](screenshots/blackbar.png) |
| **blur** | Blurs with `ImageFilter.blur(sigmaX: 8, sigmaY: 8)`. Elegant. | [blur style](screenshots/blur.png) |
| **noise** | Static TV noise with 2000 gray particles. Max privacy feeling. | [noise style](screenshots/noise.png) |
| **shredded** | Diagonal lines, shredded document effect via CustomPainter. | [shredded style](screenshots/shredded.png) |
| **cubism** | Colorful mosaic with 120 random circles/squares. Artistic. | [cubism style](screenshots/cubism.png) |

#### Masked Data

`LutoIban` and `LutoPhone` support partial masking even when visible.

[masked data - phone and IBAN](screenshots/masked.png)
> `ES93 **** **** 7890` and `+34 ***** 456` - useful to show IBAN partially even without luto


## Installation
Add the dependency to your project and import the library:

```yaml
dependencies:
  luto_redacted: ^0.1.0
```

```bash
flutter pub get
```

```dart
import 'package:luto_redacted/luto_redacted.dart';
```

### Quick Start

**1. Wrap your app with `LutoGuard`:**

```dart
import 'package:luto_redacted/luto_redacted.dart';
final lutoController = LutoController(mode: LutoMode.selective);
void main() {
  runApp(
    LutoGuard(
      controller: lutoController,
      mode: LutoMode.selective,
      style: LutoStyle.blackBar,
      revealDelayOnResume: Duration(milliseconds: 500),
      child: const MyApp(),
    ),
  );
}
```

**2. Use Luto widgets:**

```dart
// Generic sensitive text - base widget
LutoText(
  '€ 2.520,40',
  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
  lutoStyle: LutoStyle.blur, // blackBar, shredded, noise, cubism
)

// Money
LutoMoney(amount: 2520.40, currency: '€')

// IBAN with smart masking
LutoIban(
  iban: 'ES93 1234 5678 9012 3456 7890',
  masked: true, // shows ES93 **** **** 7890 even when visible
  lutoStyle: LutoStyle.blackBar,
)

// Phone
LutoPhone(
  phoneNumber: '+34 606 123 456',
  masked: true, // +34 ***** 456,
  barColor: Colors.black,
  obscuredBuilder: MyCustomWidget(), // optional
)

// Manual control with toggle
IconButton(
  icon: Icon(Icons.visibility_off),
  onPressed: () => LutoGuard.of(context).toggle(),
)
```

### API Reference

#### `LutoGuard`

Root widget that auto-protects when app goes to background.

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `child` | `Widget` | required | Your app tree |
| `mode` | `LutoMode` | `selective` | How it protects on backgrounding |
| `style` | `LutoStyle` | `blackBar` | Default visual style |
| `controller` | `LutoController?` | internal | For external manual control |
| `enableOnInactive` | `bool` | `true` | Auto-protection |
| `revealDelayOnResume` | `Duration` | `500ms` | Delay to avoid frame capture in recents |

Retrieve controller anywhere: `LutoGuard.of(context)`

#### `LutoController`

ValueNotifier<bool> to share across many widgets.

```dart
final controller = LutoController(mode: LutoMode.selective);
controller.obscure();   // obscures data (isObscured = true)
controller.reveal();    // reveals data (isObscured = false)
controller.toggle();    // toggles between obscured and visible
controller.isObscured
controller.isSelectiveMode
controller.isSecureMode
```

#### `LutoMode`

- `selective`: Only `LutoText`/`LutoMoney`/`LutoIban`/`LutoPhone` are obscured. App switcher preview remains visible but safe. **Main purpose of this package.**
- `secure`: Only enables native `FLAG_SECURE`. Total black screen in multitasking + blocks system screenshots. Best for banking apps.

#### `LutoStyle`

- `blackBar`: Solid bar with TextPainter size measurement.
- `blur`: `ImageFiltered` blur.
- `shredded`: Diagonal lines.
- `noise`: Random Gray dots.
- `cubism`: Colorful circles/squares.

### Advanced Security: FLAG_SECURE

If you need total blocking (no-op on iOS):

```dart
// Automatic via LutoGuard
LutoGuard(mode: LutoMode.secure, child: ...)

// Manual anytime
await LutoSecure.enable();
await LutoSecure.disable();
await LutoSecure.toggle();
```



### Example App

The screenshots above come from the example app showing:
- Total Balance with IBAN and amount
- Income / Expenses cards
- Recent transactions
- Luto toggle + FLAG_SECURE toggle

### Contributing

If you liked `luto_redacted` or found it helpful, please consider leaving a like on [pub.dev](https://pub.dev/packages/luto_redacted) and a star on GitHub.

