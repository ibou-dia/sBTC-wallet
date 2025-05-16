import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/transaction.dart';
import '../services/wallet_service.dart';
import '../theme/app_theme.dart';
import '../widgets/transaction_item.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  TransactionType? _filterType;
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final walletService = Provider.of<WalletService>(context);
    final allTransactions = walletService.transactions;
    
    // Apply filters
    var filteredTransactions = allTransactions;
    if (_filterType != null) {
      filteredTransactions = filteredTransactions
          .where((t) => t.type == _filterType)
          .toList();
    }
    
    // Apply search if not empty
    if (_searchQuery.isNotEmpty) {
      filteredTransactions = filteredTransactions
          .where((t) => 
              t.address.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              t.hash.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction History'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Search and filter
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Search bar
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Search by address or hash',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              setState(() {
                                _searchQuery = '';
                              });
                            },
                          )
                        : null,
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
                
                const SizedBox(height: 16),
                
                // Filter chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip(
                        label: 'All',
                        selected: _filterType == null,
                        onSelected: (selected) {
                          setState(() {
                            _filterType = null;
                          });
                        },
                      ),
                      const SizedBox(width: 8),
                      _buildFilterChip(
                        label: 'Received',
                        selected: _filterType == TransactionType.received,
                        onSelected: (selected) {
                          setState(() {
                            _filterType = selected ? TransactionType.received : null;
                          });
                        },
                      ),
                      const SizedBox(width: 8),
                      _buildFilterChip(
                        label: 'Sent',
                        selected: _filterType == TransactionType.sent,
                        onSelected: (selected) {
                          setState(() {
                            _filterType = selected ? TransactionType.sent : null;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Transactions list
          Expanded(
            child: filteredTransactions.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.history,
                          size: 64,
                          color: AppTheme.textSecondary.withOpacity(0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _searchQuery.isNotEmpty || _filterType != null
                              ? 'No transactions match your filter'
                              : 'No transactions yet',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: AppTheme.textSecondary,
                              ),
                        ),
                        if (_searchQuery.isNotEmpty || _filterType != null)
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _searchQuery = '';
                                _filterType = null;
                              });
                            },
                            child: const Text('Clear filters'),
                          ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filteredTransactions.length,
                    itemBuilder: (context, index) {
                      final transaction = filteredTransactions[index];
                      return TransactionItem(
                        transaction: transaction,
                        onTap: () {
                          _showTransactionDetails(context, transaction);
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool selected,
    required Function(bool) onSelected,
  }) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: onSelected,
      backgroundColor: AppTheme.cardBackground,
      selectedColor: AppTheme.bitcoinOrange.withOpacity(0.2),
      checkmarkColor: AppTheme.bitcoinOrange,
      labelStyle: TextStyle(
        color: selected ? AppTheme.bitcoinOrange : AppTheme.textPrimary,
        fontWeight: selected ? FontWeight.w500 : FontWeight.normal,
      ),
    );
  }

  void _showTransactionDetails(BuildContext context, Transaction transaction) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Transaction header
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: transaction.type == TransactionType.received
                            ? Colors.green.withOpacity(0.2)
                            : Colors.red.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        transaction.type == TransactionType.received
                            ? Icons.arrow_downward_rounded
                            : Icons.arrow_upward_rounded,
                        color: transaction.type == TransactionType.received
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            transaction.type == TransactionType.received
                                ? 'Received sBTC'
                                : 'Sent sBTC',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          Text(
                            transaction.timestamp.toString().substring(0, 16),
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppTheme.textSecondary,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                
                const Divider(height: 32),
                
                // Transaction details
                _buildDetailRow(context, 'Amount', 
                  '${transaction.type == TransactionType.received ? '+' : '-'} ${transaction.amount} sBTC',
                  valueColor: transaction.type == TransactionType.received
                      ? Colors.green
                      : Colors.red,
                ),
                const SizedBox(height: 16),
                _buildDetailRow(context, 
                  transaction.type == TransactionType.received ? 'From' : 'To', 
                  transaction.address,
                ),
                const SizedBox(height: 16),
                _buildDetailRow(context, 'Transaction Hash', transaction.hash),
                const SizedBox(height: 16),
                _buildDetailRow(context, 'Status', 
                  transaction.confirmed ? 'Confirmed' : 'Pending',
                  valueColor: transaction.confirmed ? Colors.green : Colors.orange,
                ),
                
                const SizedBox(height: 32),
                
                // View on explorer button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.open_in_new),
                    label: const Text('View on Stacks Explorer'),
                    onPressed: () {
                      // TODO: Open transaction in Stacks Explorer
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value, {Color? valueColor}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondary,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: valueColor,
              ),
        ),
      ],
    );
  }
}
