import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/wallet_service.dart';
import '../utils/formatters.dart';
import '../theme/app_theme.dart';
import '../widgets/address_card.dart';
import '../widgets/transaction_item.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // App Bar Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'sBTC Wallet',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  IconButton(
                    icon: const Icon(Icons.settings_outlined),
                    onPressed: () {
                      // TODO: Implement settings
                    },
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // Balance Card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.bitcoinOrange,
                        AppTheme.bitcoinOrange.withOpacity(0.8),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your Balance',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Colors.white.withOpacity(0.8),
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${Formatters.formatBitcoin(wallet.balance)} sBTC',
                        style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 24),
                      AddressCard(
                        address: wallet.address,
                        showFullAddress: false,
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Action Buttons
              Row(
                children: [
                  _buildActionButton(
                    context,
                    icon: Icons.arrow_upward_rounded,
                    label: 'Send',
                    onTap: () => Navigator.pushNamed(context, '/send'),
                  ),
                  const SizedBox(width: 16),
                  _buildActionButton(
                    context,
                    icon: Icons.arrow_downward_rounded,
                    label: 'Receive',
                    onTap: () => Navigator.pushNamed(context, '/receive'),
                  ),
                  const SizedBox(width: 16),
                  _buildActionButton(
                    context,
                    icon: Icons.history,
                    label: 'History',
                    onTap: () => Navigator.pushNamed(context, '/transactions'),
                  ),
                ],
              ),
              
              const SizedBox(height: 32),
              
              // Recent Transactions
              Text(
                'Recent Transactions',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              
              if (walletService.transactions.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      children: [
                        Icon(
                          Icons.history,
                          size: 64,
                          color: AppTheme.textSecondary.withOpacity(0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No transactions yet',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: AppTheme.textSecondary,
                              ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: walletService.transactions.length > 3
                      ? 3
                      : walletService.transactions.length,
                  itemBuilder: (context, index) {
                    final transaction = walletService.transactions[index];
                    return TransactionItem(
                      transaction: transaction,
                      onTap: () {
                        // TODO: Show transaction details
                      },
                    );
                  },
                ),
              
              // View all transactions button  
              if (walletService.transactions.length > 3)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Center(
                    child: TextButton(
                      onPressed: () => Navigator.pushNamed(context, '/transactions'),
                      child: Text(
                        'View all transactions',
                        style: TextStyle(
                          color: AppTheme.bitcoinOrange,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
  
  Expanded _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
          decoration: BoxDecoration(
            color: AppTheme.cardBackground,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: AppTheme.bitcoinOrange,
                size: 28,
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
