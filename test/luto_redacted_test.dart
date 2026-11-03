import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:luto_redacted/luto_redacted.dart';

void main() {
  group('LutoController', () {
    test('empieza en false (visible)', () {
      final controller = LutoController(mode: LutoMode.selective);
      expect(controller.value, false);
      expect(controller.isObscured, false);
    });

    test('show() pone isObscured en true y notifica', () {
      final controller = LutoController(mode: LutoMode.selective);
      var notified = false;
      controller.addListener(() => notified = true);
      controller.reveal();
      expect(controller.isObscured, true);
      expect(controller.value, true);
      expect(notified, true);
    });

    test('hide() vuelve a false', () {
      final controller = LutoController(mode: LutoMode.selective);
      controller.reveal();
      controller.obscure();
      expect(controller.isObscured, false);
    });

    test('toggle() alterna', () {
      final controller = LutoController(mode: LutoMode.selective);
      controller.toggle();
      expect(controller.isObscured, true);
      controller.toggle();
      expect(controller.isObscured, false);
    });
  });

  group('LutoGuard', () {
    testWidgets('of() devuelve el controller', (tester) async {
      late LutoController found;
      await tester.pumpWidget(
        LutoGuard(
          child: Builder(
            builder: (context) {
              found = LutoGuard.of(context);
              return const SizedBox();
            },
          ),
        ),
      );
      expect(found, isA<LutoController>());
    });

    testWidgets('controla manualmente el obscurecido', (tester) async {
      final controller = LutoController(mode: LutoMode.selective);
      await tester.pumpWidget(
        MaterialApp(
          home: LutoGuard(
            controller: controller,
            mode: LutoMode.selective,
            child: const Scaffold(body: LutoText('1234')),
          ),
        ),
      );
      expect(controller.isObscured, false);
      controller.reveal();
      await tester.pump();
      expect(controller.isObscured, true);
      controller.obscure();
      await tester.pump();
      expect(controller.isObscured, false);
    });
  });

  group('LutoText', () {
    testWidgets('muestra texto normal cuando no está obscurecido', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: LutoGuard(child: Scaffold(body: LutoText('1234 5678'))),
        ),
      );
      expect(find.text('1234 5678'), findsOneWidget);
    });

    testWidgets('muestra barra negra cuando está obscurecido', (tester) async {
      final controller = LutoController(mode: LutoMode.selective);
      controller.reveal();
      await tester.pumpWidget(
        MaterialApp(
          home: LutoGuard(
            controller: controller,
            child: const Scaffold(
              body: LutoText('1234 5678', lutoStyle: LutoStyle.blackBar),
            ),
          ),
        ),
      );
      await tester.pump();
      expect(find.byType(Container), findsOneWidget);
    });
  });

  group('LutoMoney', () {
    testWidgets('renderiza sin crash', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: LutoGuard(child: Scaffold(body: LutoMoney(amount: 1500.50))),
        ),
      );
      expect(find.byType(LutoMoney), findsOneWidget);
    });
  });

  group('LutoMode', () {
    test('hay dos modos disponibles', () {
      expect(LutoMode.values, contains(LutoMode.secure));
      expect(LutoMode.values, contains(LutoMode.selective));
    });
  });
}
