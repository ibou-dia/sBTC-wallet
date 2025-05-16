import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/main_layout.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _darkMode = false;
  String _selectedLanguage = 'English';
  String _selectedNetwork = 'Mainnet';
  bool _biometricEnabled = false;
  bool _notificationsEnabled = true;

  final List<String> _availableLanguages = [
    'English',
    'Français',
    'Español',
    'Deutsch',
    '中文',
    '日本語',
  ];

  final List<String> _availableNetworks = [
    'Mainnet',
    'Testnet',
  ];

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      currentIndex: -1,
      currentRoute: '/settings',
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Settings',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 24),
            
            // Appearance Section
            _buildSectionHeader(context, 'Appearance'),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text('Dark Mode'),
                    subtitle: const Text('Switch between light and dark theme'),
                    value: _darkMode,
                    onChanged: (value) {
                      setState(() {
                        _darkMode = value;
                      });
                      // TODO: Implement theme change
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Dark mode coming soon'),
                        ),
                      );
                    },
                    secondary: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppTheme.cardBackground,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.dark_mode),
                    ),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppTheme.cardBackground,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.language),
                    ),
                    title: const Text('Language'),
                    subtitle: Text(_selectedLanguage),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      _showLanguageSelector(context);
                    },
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Network Section
            _buildSectionHeader(context, 'Network'),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppTheme.cardBackground,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.wifi),
                    ),
                    title: const Text('Network'),
                    subtitle: Text(_selectedNetwork),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      _showNetworkSelector(context);
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppTheme.cardBackground,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.sync),
                    ),
                    title: const Text('Auto-sync'),
                    subtitle: const Text('Sync wallet on startup'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      // TODO: Implement auto-sync settings
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Auto-sync settings coming soon'),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Security Section
            _buildSectionHeader(context, 'Security'),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text('Biometric Authentication'),
                    subtitle: const Text('Use fingerprint or Face ID'),
                    value: _biometricEnabled,
                    onChanged: (value) {
                      setState(() {
                        _biometricEnabled = value;
                      });
                      // TODO: Implement biometric authentication
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Biometric authentication coming soon'),
                        ),
                      );
                    },
                    secondary: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppTheme.cardBackground,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.fingerprint),
                    ),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppTheme.cardBackground,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.lock),
                    ),
                    title: const Text('Change PIN'),
                    subtitle: const Text('Update your wallet PIN'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      // TODO: Implement PIN change
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('PIN change coming soon'),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Notifications Section
            _buildSectionHeader(context, 'Notifications'),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: SwitchListTile(
                title: const Text('Enable Notifications'),
                subtitle: const Text('Get alerts for transactions'),
                value: _notificationsEnabled,
                onChanged: (value) {
                  setState(() {
                    _notificationsEnabled = value;
                  });
                  // TODO: Implement notification settings
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        value 
                            ? 'Notifications enabled' 
                            : 'Notifications disabled'
                      ),
                    ),
                  );
                },
                secondary: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppTheme.cardBackground,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.notifications),
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Clear Data Section
            _buildSectionHeader(context, 'Data'),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.delete, color: Colors.red),
                ),
                title: const Text('Clear Local Data'),
                subtitle: const Text('Remove cached data from device'),
                onTap: () {
                  _showClearDataConfirmation(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }
  
  void _showLanguageSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Select Language',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 24),
              ...List.generate(
                _availableLanguages.length,
                (index) {
                  final language = _availableLanguages[index];
                  final isSelected = language == _selectedLanguage;
                  
                  return ListTile(
                    title: Text(language),
                    trailing: isSelected
                        ? const Icon(
                            Icons.check_circle,
                            color: AppTheme.bitcoinOrange,
                          )
                        : null,
                    onTap: () {
                      setState(() {
                        _selectedLanguage = language;
                      });
                      Navigator.pop(context);
                      
                      // TODO: Implement language change
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Language changed to $language'),
                        ),
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  
  void _showNetworkSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Select Network',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 24),
              ...List.generate(
                _availableNetworks.length,
                (index) {
                  final network = _availableNetworks[index];
                  final isSelected = network == _selectedNetwork;
                  
                  return ListTile(
                    title: Text(network),
                    subtitle: Text(
                      network == 'Mainnet'
                          ? 'Live network with real funds'
                          : 'Test network with test funds'
                    ),
                    trailing: isSelected
                        ? const Icon(
                            Icons.check_circle,
                            color: AppTheme.bitcoinOrange,
                          )
                        : null,
                    onTap: () {
                      setState(() {
                        _selectedNetwork = network;
                      });
                      Navigator.pop(context);
                      
                      // TODO: Implement network change
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Network changed to $network'),
                        ),
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      color: Colors.amber,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Changing networks will require app restart and re-authentication',
                        style: TextStyle(color: Colors.amber),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  
  void _showClearDataConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Local Data'),
        content: const Text(
          'This will remove all cached data from your device. Your wallet and funds will not be affected, but you may need to re-authenticate. Are you sure?'
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              
              // TODO: Implement clear data
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Local data cleared'),
                ),
              );
            },
            child: const Text(
              'Clear Data',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
