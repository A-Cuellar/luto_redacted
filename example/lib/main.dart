import 'package:flutter/material.dart';
import 'package:luto_redacted/luto_redacted.dart';

void main() {
  runApp(LutoGuard(mode: LutoMode.selective, child: const BankApp()));
}

class BankApp extends StatelessWidget {
  const BankApp({super.key});

  @override
  Widget build(BuildContext context) {
    //final LutoController controller = LutoGuard.of(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6C5CE7),
          brightness: Brightness.dark,
        ),
      ),
      home: const BankDashboard(),
    );
  }
}

class BankDashboard extends StatefulWidget {
  const BankDashboard({super.key});

  @override
  State<BankDashboard> createState() => _BankDashboardState();
}

class _BankDashboardState extends State<BankDashboard> {
  @override
  Widget build(BuildContext context) {
    final LutoController controller = LutoGuard.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F13),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Good morning,',
                      style: TextStyle(color: Colors.white54),
                    ),
                    Text(
                      'Jhon Doe',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(Icons.phone, size: 15),
                        SizedBox(width: 10),
                        LutoPhone(
                          phoneNumber: '+34 606 123 456',
                          masked: true,
                          lutoStyle: LutoStyle.blur,
                        ),
                      ],
                    ),
                  ],
                ),
                CircleAvatar(
                  backgroundColor: Colors.white12,
                  child: Icon(Icons.person, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 32),

            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6C5CE7), Color(0xFFA29BFE)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(28),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Balance',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white.withValues(alpha: 0.8),
                        ),
                      ),

                      ValueListenableBuilder<bool>(
                        valueListenable: controller,
                        builder: (context, _, _) {
                          final isVisible = controller.isObscured;
                          return IconButton(
                            onPressed: () {
                              if (isVisible) {
                                controller.hide(); // tap
                              } else {
                                controller.show();
                              }
                            },
                            icon: Icon(
                              isVisible
                                  ? Icons.visibility_off_rounded
                                  : Icons.visibility_rounded,
                              color: Colors.white,
                            ),
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.white.withValues(
                                alpha: .2,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  LutoIban(
                    iban: 'ES93 1234 5678 9012 3456 7890',
                    masked: true,
                    lutoStyle: LutoStyle.blackBar,
                    obscuredBuilder: Text(
                      "▒▒▒▒▒▓▓▓▓▓███████████",
                      style: TextStyle(
                        color: const Color.fromARGB(255, 143, 138, 220),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  LutoText(
                    '€ 2.520,40',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -1,
                    ),
                    lutoStyle: LutoStyle.blur,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '+ 2.4% this month',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    title: 'Income',
                    value: '€ 4.200',
                    icon: Icons.arrow_upward,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _StatCard(
                    title: 'Expenses',
                    value: '€ 1.830',
                    icon: Icons.arrow_downward,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),
            const Text(
              'Recent transactions',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            _TxTile(name: 'Spotify', amount: '- € 9.99'),
            _TxTile(name: 'Salary', amount: '+ € 4.200', isIncome: true),
            SizedBox(height: 20),
            FilledButton(
              onPressed: () {
                LutoSecure.toggle();
              },
              child: Text('Activar/Desactivar FLAG_SECURE'),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title, value;
  final IconData icon;
  final Color color;
  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C20),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(color: Colors.white54)),
          const SizedBox(height: 4),
          LutoText(
            value,
            lutoStyle: LutoStyle.blur,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _TxTile extends StatelessWidget {
  final String name, amount;
  final bool isIncome;
  const _TxTile({
    required this.name,
    required this.amount,
    this.isIncome = false,
  });
  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: Colors.white12,
        child: Icon(isIncome ? Icons.work : Icons.music_note),
      ),
      title: Text(name, style: const TextStyle(color: Colors.white)),
      trailing: LutoText(
        amount,
        lutoStyle: LutoStyle.blur,
        style: TextStyle(
          color: isIncome ? Colors.green : Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
