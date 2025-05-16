import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/wallet_service.dart';
import '../theme/app_theme.dart';
import '../widgets/main_layout.dart';
import '../utils/formatters.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final walletService = Provider.of<WalletService>(context);
    final wallet = walletService.wallet;

    if (wallet == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: AppTheme.bitcoinOrange,
          ),
        ),
      );
    }

    return MainLayout(
      currentIndex: -1, // No item selected in bottom nav
      currentRoute: '/account',
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'My Account',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 24),
            
            // Wallet Info Card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Wallet Information',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    
                    _buildInfoRow(
                      context, 
                      title: 'Wallet Address', 
                      value: Formatters.shortenAddress(wallet.address, start: 10, end: 10),
                      canCopy: true,
                      copyValue: wallet.address,
                    ),
                    const Divider(height: 32),
                    
                    _buildInfoRow(
                      context, 
                      title: 'Current Balance', 
                      value: '${Formatters.formatBitcoin(wallet.balance)} sBTC',
                    ),
                    const Divider(height: 32),
                    
                    _buildInfoRow(
                      context, 
                      title: 'Status', 
                      value: wallet.connected ? 'Connected' : 'Disconnected',
                      valueColor: wallet.connected ? Colors.green : Colors.red,
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Security Section
            Text(
              'Security',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  _buildSettingTile(
                    context,
                    icon: Icons.backup,
                    title: 'Backup Wallet',
                    subtitle: 'Create a backup of your wallet',
                    onTap: () {
                      // TODO: Implement backup functionality
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Backup feature coming soon'),
                        ),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  _buildSettingTile(
                    context,
                    icon: Icons.password,
                    title: 'Change PIN',
                    subtitle: 'Update your wallet security PIN',
                    onTap: () {
                      // TODO: Implement PIN change functionality
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('PIN change feature coming soon'),
                        ),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  _buildSettingTile(
                    context,
                    icon: Icons.refresh,
                    title: 'Refresh Wallet Data',
                    subtitle: 'Sync with latest blockchain data',
                    onTap: () {
                      // TODO: Implement refresh functionality
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Refreshing wallet data...'),
                        ),
                      );
                      // This would call a wallet service method
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required String title,
    required String value,
    Color? valueColor,
    bool canCopy = false,
    String? copyValue,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondary,
              ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Flexible(
                child: Text(
                  value,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: valueColor ?? AppTheme.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                  textAlign: TextAlign.right,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (canCopy && copyValue != null)
                IconButton(
                  icon: const Icon(Icons.copy, size: 16),
                  onPressed: () {
                    // Copy to clipboard
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Address copied to clipboard'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  constraints: const BoxConstraints(
                    minHeight: 24,
                    minWidth: 24,
                  ),
                  padding: EdgeInsets.zero,
                  iconSize: 16,
                  splashRadius: 16,
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSettingTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppTheme.bitcoinOrange.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: AppTheme.bitcoinOrange,
          size: 20,
        ),
      ),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
