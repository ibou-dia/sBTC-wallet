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
          topRight: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      child: Column(
        children: [
          // Drawer header
          _buildDrawerHeader(context, wallet?.address),
          
          // Drawer items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 16),
              children: [
                _buildDrawerItem(
                  context,
                  icon: Icons.home,
                  title: 'Home',
                  route: Constants.routeHome,
                  isSelected: currentRoute == Constants.routeHome,
                ),
                Container(
                  height: 1,
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.bitcoinOrange.withOpacity(0.1),
                        AppTheme.bitcoinOrange.withOpacity(0.3),
                        AppTheme.bitcoinOrange.withOpacity(0.1),
                      ],
                    ),
                  ),
                ),
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
                
                // Container(
                //   height: 1,
                //   margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                //   decoration: BoxDecoration(
                //     gradient: LinearGradient(
                //       colors: [
                //         Colors.grey.withOpacity(0.1),
                //         Colors.grey.withOpacity(0.3),
                //         Colors.grey.withOpacity(0.1),
                //       ],
                //     ),
                //   ),
                // ),
                
                // Disconnect wallet option at the bottom
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      // gradient: LinearGradient(
                      //   begin: Alignment.topLeft,
                      //   end: Alignment.bottomRight,
                      //   colors: [
                      //     Colors.red.shade50,
                      //     Colors.red.shade100.withOpacity(0.3),
                      //   ],
                      // ),
                      // boxShadow: [
                      //   BoxShadow(
                      //     color: Colors.red.withOpacity(0.1),
                      //     blurRadius: 8,
                      //     offset: const Offset(0, 2),
                      //   ),
                      // ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () async {
                          await walletService.disconnectWallet();
                          if (context.mounted) {
                            Navigator.pushReplacementNamed(context, Constants.routeAuth);
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                          child: Row(
                            children: [
                              Icon(
                                Icons.logout_rounded,
                                color: Colors.red.shade700,
                                size: 22,
                              ),
                              const SizedBox(width: 14),
                              Text(
                                'Disconnect Wallet',
                                style: TextStyle(
                                  color: Colors.red.shade700,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // App version at the bottom
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.verified_outlined,
                  size: 14,
                  color: AppTheme.textSecondary.withOpacity(0.7),
                ),
                const SizedBox(width: 6),
                Text(
                  'Version 1.0.0',
                  style: TextStyle(
                    color: AppTheme.textSecondary.withOpacity(0.7),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader(BuildContext context, String? walletAddress) {
    return Container(
      padding: const EdgeInsets.fromLTRB(60, 60, 107, 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.bitcoinOrange,
            AppTheme.bitcoinOrange.withOpacity(0.7),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withOpacity(0.2), width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: const Icon(
              Icons.account_balance_wallet,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'sBTC Wallet',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
          ),
          if (walletAddress != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.verified_user,
                    size: 14,
                    color: Colors.white.withOpacity(0.9),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    Formatters.shortenAddress(walletAddress),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white.withOpacity(0.9),
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.3,
                        ),
                  ),
                ],
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
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: isSelected
            ? AppTheme.bitcoinOrange.withOpacity(0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        boxShadow: isSelected ? [
          BoxShadow(
            color: AppTheme.bitcoinOrange.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ] : null,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        minLeadingWidth: 20,
        leading: Icon(
          icon,
          color: isSelected
              ? AppTheme.bitcoinOrange
              : AppTheme.textSecondary,
          size: 22,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isSelected
                ? AppTheme.bitcoinOrange
                : AppTheme.textPrimary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            fontSize: 15,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
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
