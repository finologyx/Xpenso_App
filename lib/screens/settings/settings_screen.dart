import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../services/pro_service.dart';
import '../../utils/constants.dart';
import '../auth/login_screen.dart';
import '../pro/pro_upgrade_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _selectedTheme = 'blue';
  String _selectedCurrency = 'USD';
  bool _isProUser = false;

  @override
  void initState() {
    super.initState();
    _checkProStatus();
  }

  Future<void> _checkProStatus() async {
    bool isPro = await ProService.instance.isProUser();
    if (mounted) {
      setState(() {
        _isProUser = isPro;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const SizedBox(height: 20),
          const Text(
            'Preferences',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          ListTile(
            title: const Text('Theme'),
            subtitle: Text(
              _selectedTheme == 'red'
                  ? 'Red-White'
                  : _selectedTheme == 'blue'
                  ? 'Blue-White'
                  : 'Dark Mode',
            ),
            trailing: DropdownButton<String>(
              value: _selectedTheme,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedTheme = newValue;
                  });
                }
              },
              items:
                  <String>['red', 'blue', 'dark'].map<DropdownMenuItem<String>>(
                    (String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value == 'red'
                              ? 'Red-White'
                              : value == 'blue'
                              ? 'Blue-White'
                              : 'Dark Mode',
                        ),
                      );
                    },
                  ).toList(),
            ),
          ),
          ListTile(
            title: const Text('Currency'),
            subtitle: Text(
              '$_selectedCurrency (${AppConstants.currencies[_selectedCurrency]})',
            ),
            trailing: DropdownButton<String>(
              value: _selectedCurrency,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedCurrency = newValue;
                  });
                }
              },
              items:
                  AppConstants.currencies.entries.map<DropdownMenuItem<String>>(
                    (MapEntry<String, String> entry) {
                      return DropdownMenuItem<String>(
                        value: entry.key,
                        child: Text('${entry.key} (${entry.value})'),
                      );
                    },
                  ).toList(),
            ),
          ),
          const SizedBox(height: 40),
          const Text(
            'Account',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          ListTile(
            title: const Text('Change Password'),
            onTap: () {
              // Implement change password functionality
            },
          ),
          if (!_isProUser)
            ListTile(
              title: const Text('Upgrade to Pro'),
              subtitle: const Text('Unlock all premium features'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProUpgradeScreen(),
                  ),
                );
                if (result == true) {
                  // Refresh Pro status
                  _checkProStatus();
                }
              },
            ),
          ListTile(
            title: const Text('Privacy Policy'),
            onTap: () {
              // Implement privacy policy view
            },
          ),
          ListTile(
            title: const Text('Terms of Service'),
            onTap: () {
              // Implement terms of service view
            },
          ),
          const SizedBox(height: 40),
          const Text(
            'About',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          ListTile(title: const Text('Version'), subtitle: const Text('1.0.0')),
          ListTile(
            title: const Text('Developer'),
            subtitle: const Text('Xpenso Team'),
          ),
          const SizedBox(height: 40),
          ListTile(
            title: const Text(
              'Logout',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
            onTap: () async {
              final navigatorContext = context;
              await AuthService.instance.signOut();
              if (mounted) {
                // ignore: use_build_context_synchronously
                Navigator.pushAndRemoveUntil(
                  navigatorContext,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
