import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6F4EA),
      appBar: AppBar(
        title: const Text(
          "Über diese App",
          style: TextStyle(color: Colors.black87),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 4,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(LucideIcons.info, size: 32, color: Colors.black87),
                SizedBox(width: 12),
                Text(
                  "Shoplist – Free to Use",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            const Text(
              "Diese App ist komplett kostenlos und frei nutzbar.",
              style: TextStyle(fontSize: 18, height: 1.4),
            ),

            const SizedBox(height: 16),

            const Text(
              "Es werden keinerlei persönliche Daten online gespeichert. "
              "Alle deine Einkaufslisten, Items und Einstellungen bleiben "
              "ausschließlich lokal auf deinem Gerät.",
              style: TextStyle(fontSize: 18, height: 1.4),
            ),

            const SizedBox(height: 16),

            const Text(
              "Es gibt keine Accounts, keine Cloud‑Synchronisation und "
              "keine Übertragung deiner Daten an Server oder Dritte.",
              style: TextStyle(fontSize: 18, height: 1.4),
            ),

            const SizedBox(height: 32),

            const Text(
              "Wenn du Fragen oder Feedback hast, freue ich mich jederzeit!",
              style: TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
