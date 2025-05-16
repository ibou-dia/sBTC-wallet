import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/wallet_service.dart';
import '../models/transaction.dart';
import '../theme/app_theme.dart';
import '../widgets/main_layout.dart';
import '../utils/formatters.dart';

class TrackScreen extends StatelessWidget {
  const TrackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final walletService = Provider.of<WalletService>(context);
    final wallet = walletService.wallet;
    final transactions = walletService.transactions;

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
      currentIndex: -1, // No bottom nav item selected
      currentRoute: '/track',
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Track sBTC',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Monitor your sBTC on the Stacks blockchain',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
            ),
            const SizedBox(height: 24),
            
            // Status Card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Current Status',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'sBTC Balance',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: AppTheme.textSecondary,
                                    ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${Formatters.formatBitcoin(wallet.balance)} sBTC',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ],
                          ),
                        ),
                        OutlinedButton.icon(
                          icon: const Icon(Icons.open_in_new),
                          label: const Text('Explorer'),
                          onPressed: () {
                            final url = 'https://explorer.stacks.co/address/${wallet.address}?chain=mainnet';
                            _launchUrl(url);
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppTheme.bitcoinOrange,
                            side: BorderSide(
                              color: AppTheme.bitcoinOrange,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 32),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Storage Status',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: AppTheme.textSecondary,
                                    ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Securely Held in Stacks Contract',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'ACTIVE',
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Recent Activity
            Text(
              'Recent Activity',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: transactions.isEmpty
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.all(32.0),
                          child: Text('No recent transactions'),
                        ),
                      )
                    : Column(
                        children: transactions.take(3).map((tx) {
                          return _buildTransactionStatusItem(context, tx, walletService);
                        }).toList(),
                      ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // sBTC Network Info
            Text(
              'sBTC Network Info',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildNetworkInfoRow(
                      context, 
                      title: 'Network', 
                      value: 'Stacks Mainnet',
                    ),
                    const Divider(height: 24),
                    _buildNetworkInfoRow(
                      context, 
                      title: 'Contract', 
                      value: 'sBTC Peg Contract',
                      isContract: true,
                    ),
                    const Divider(height: 24),
                    _buildNetworkInfoRow(
                      context, 
                      title: 'Status', 
                      value: 'Operational',
                      valueColor: Colors.green,
                    ),
                    const Divider(height: 24),
                    _buildNetworkInfoRow(
                      context, 
                      title: 'Last Peg-in', 
                      value: '2 hours ago',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildTransactionStatusItem(BuildContext context, Transaction transaction, WalletService walletService) {
    final isReceived = transaction.type == TransactionType.received;
    
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isReceived
                    ? Colors.green.withOpacity(0.1)
                    : Colors.orange.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isReceived
                    ? Icons.arrow_downward_rounded
                    : Icons.arrow_upward_rounded,
                color: isReceived ? Colors.green : Colors.orange,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isReceived ? 'Received sBTC' : 'Sent sBTC',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    '${Formatters.formatBitcoin(transaction.amount)} sBTC',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  Formatters.formatDate(transaction.timestamp),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: transaction.confirmed
                        ? Colors.green.withOpacity(0.1)
                        : Colors.amber.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    transaction.confirmed ? 'CONFIRMED' : 'PENDING',
                    style: TextStyle(
                      color: transaction.confirmed ? Colors.green : Colors.amber[800],
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        InkWell(
          onTap: () {
            final url = 'https://explorer.stacks.co/txid/${transaction.hash}?chain=mainnet';
            _launchUrl(url);
          },
          child: Padding(
            padding: const EdgeInsets.only(top: 8, left: 56),
            child: Row(
              children: [
                Text(
                  'View on Explorer',
                  style: TextStyle(
                    color: AppTheme.bitcoinOrange,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.open_in_new,
                  size: 14,
                  color: AppTheme.bitcoinOrange,
                ),
              ],
            ),
          ),
        ),
        if (transaction != walletService.transactions.last)
          const Divider(height: 24),
      ],
    );
  }
  
  Widget _buildNetworkInfoRow(
    BuildContext context, {
    required String title,
    required String value,
    Color? valueColor,
    bool isContract = false,
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
        Row(
          children: [
            Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: valueColor ?? AppTheme.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
            ),
            if (isContract) ...[
              const SizedBox(width: 4),
              InkWell(
                onTap: () {
                  const url = 'https://explorer.stacks.co/address/SP000000000000000000002Q6VF78.pox-3?chain=mainnet';
                  _launchUrl(url);
                },
                child: Icon(
                  Icons.open_in_new,
                  size: 14,
                  color: AppTheme.bitcoinOrange,
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
  
  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }
}
