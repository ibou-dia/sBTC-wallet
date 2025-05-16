import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../theme/app_theme.dart';
import '../utils/formatters.dart';

class TransactionItem extends StatelessWidget {
  final Transaction transaction;
  final VoidCallback? onTap;

  const TransactionItem({
    super.key,
    required this.transaction,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 0),
      elevation: 0,
      color: AppTheme.cardBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Transaction type icon
              Container(
                width: 40,
                height: 40,
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
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              // Transaction details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transaction.type == TransactionType.received
                          ? 'Received'
                          : 'Sent',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      Formatters.shortenAddress(transaction.address),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      Formatters.shortenAddress(transaction.hash, start: 8, end: 8),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.textSecondary.withOpacity(0.7),
                          ),
                    ),
                  ],
                ),
              ),
              // Amount and date
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${transaction.type == TransactionType.received ? '+' : '-'} ${Formatters.formatBitcoin(transaction.amount)} sBTC',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: transaction.type == TransactionType.received
                              ? Colors.green
                              : Colors.red,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    Formatters.formatDate(transaction.timestamp),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
