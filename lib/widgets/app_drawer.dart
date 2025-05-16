import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../services/wallet_service.dart';
import '../utils/formatters.dart';
import '../utils/constants.dart';

class AppDrawer extends StatelessWidget {
  final String currentRoute;

  const AppDrawer({super.key, required this.currentRoute});

  @override
  Widget build(BuildContext context) {
    final walletService = Provider.of<WalletService>(context);
    final wallet = walletService.wallet;

    return Drawer(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      elevation: 5,
      child: Column(
        children: [
          // Drawer header
          _buildDrawerHeader(context, wallet?.address),
          
          // Drawer items
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(
                  context,
                  icon: Icons.home,
                  title: 'Home',
                  route: Constants.routeHome,
                  isSelected: currentRoute == Constants.routeHome,
                ),
                const Divider(height: 1),
                _buildDrawerItem(
                  context,
                  icon: Icons.person,
                  title: 'My Account',
                  route: Constants.routeAccount,
                  isSelected: currentRoute == Constants.routeAccount,
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.location_on,
                  title: 'Track sBTC',
                  route: Constants.routeTrack,
                  isSelected: currentRoute == Constants.routeTrack,
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.currency_exchange,
                  title: 'Currency Preferences',
                  route: Constants.routeCurrency,
                  isSelected: currentRoute == Constants.routeCurrency,
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.settings,
                  title: 'Settings',
                  route: Constants.routeSettings,
                  isSelected: currentRoute == Constants.routeSettings,
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.info,
                  title: 'About',
                  route: Constants.routeAbout,
                  isSelected: currentRoute == Constants.routeAbout,
                ),
                
                const Divider(),
                
                // Disconnect wallet option at the bottom
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextButton.icon(
                    onPressed: () async {
                      await walletService.disconnectWallet();
                      if (context.mounted) {
                        Navigator.pushReplacementNamed(context, Constants.routeAuth);
                      }
                    },
                    icon: const Icon(Icons.logout, color: Colors.red),
                    label: const Text(
                      'Disconnect Wallet',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // App version at the bottom
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'v1.0.0',
              style: TextStyle(
                color: AppTheme.textSecondary.withOpacity(0.6),
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader(BuildContext context, String? walletAddress) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.bitcoinOrange,
            AppTheme.bitcoinOrange.withOpacity(0.8),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.account_balance_wallet,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'sBTC Wallet',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
          if (walletAddress != null) ...[
            const SizedBox(height: 8),
            Text(
              Formatters.shortenAddress(walletAddress),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white.withOpacity(0.8),
                  ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String route,
    required bool isSelected,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: isSelected
            ? AppTheme.bitcoinOrange.withOpacity(0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected
              ? AppTheme.bitcoinOrange
              : AppTheme.textSecondary,
          size: 24,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isSelected
                ? AppTheme.bitcoinOrange
                : AppTheme.textPrimary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        onTap: () {
          Navigator.pop(context); // Close drawer
          if (currentRoute != route) {
            Navigator.pushNamed(context, route);
          }
        },
      ),
    );
  }
}
