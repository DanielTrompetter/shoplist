import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _darkMode = false;
  bool _isLoggedIn = false;
  String? _userEmail;

  Future<void> _showLoginDialog() async {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Login"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: "E-Mail"),
              ),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(labelText: "Passwort"),
                obscureText: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Abbrechen"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _showRegisterDialog(); // Registrierung öffnen
              },
              child: const Text("Registrieren"),
            ),
            ElevatedButton(
              onPressed: () async {
                // TODO: Firebase Auth Login
                // await FirebaseAuth.instance.signInWithEmailAndPassword(
                //   email: emailController.text.trim(),
                //   password: passwordController.text.trim(),
                // );

                setState(() {
                  _isLoggedIn = true;
                  _userEmail = emailController.text.trim();
                });

                Navigator.pop(context);
              },
              child: const Text("Login"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showRegisterDialog() async {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Registrieren"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: "E-Mail"),
              ),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(labelText: "Passwort"),
                obscureText: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Abbrechen"),
            ),
            ElevatedButton(
              onPressed: () async {
                // TODO: Firebase Auth Registrierung
                // await FirebaseAuth.instance.createUserWithEmailAndPassword(
                //   email: emailController.text.trim(),
                //   password: passwordController.text.trim(),
                // );

                setState(() {
                  _isLoggedIn = true;
                  _userEmail = emailController.text.trim();
                });

                Navigator.pop(context);
              },
              child: const Text("Registrieren"),
            ),
          ],
        );
      },
    );
  }

  void _logout() {
    // TODO: FirebaseAuth.instance.signOut();
    setState(() {
      _isLoggedIn = false;
      _userEmail = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Einstellungen')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Theme Switch
          SwitchListTile(
            title: const Text('Dark Mode'),
            value: _darkMode,
            onChanged: (val) {
              setState(() => _darkMode = val);
              // TODO: Theme wechseln (Provider oder Riverpod nutzen)
            },
          ),
          const Divider(),

          // Login / Logout Switch
          SwitchListTile(
            title: const Text('Login'),
            subtitle: Text(
              _isLoggedIn
                  ? 'Angemeldet als $_userEmail'
                  : 'Optional anmelden, um Listen zu teilen',
            ),
            value: _isLoggedIn,
            onChanged: (val) {
              if (val) {
                _showLoginDialog();
              } else {
                _logout();
              }
            },
          ),
          const Divider(),

          // Sprache / Scheme
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Sprache'),
            subtitle: const Text('Deutsch'),
            onTap: () {
              // TODO: Sprachwechsel-Dialog
            },
          ),
          const Divider(),

          // Weitere Settings
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('Über diese App'),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'ShopList',
                applicationVersion: '1.0.0',
                applicationLegalese: '© 2025 Daniel',
              );
            },
          ),
        ],
      ),
    );
  }
}
