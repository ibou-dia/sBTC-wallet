import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/currency_service.dart';
import '../theme/app_theme.dart';
import '../widgets/main_layout.dart';

class CurrencyScreen extends StatelessWidget {
  const CurrencyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currencyService = Provider.of<CurrencyService>(context);
    
    return MainLayout(
      currentIndex: -1, // No bottom nav item selected
      currentRoute: '/currency',
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Currency Preferences',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Choose your preferred currency for sBTC conversions',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
            ),
            const SizedBox(height: 24),
            
            // Current Exchange Rate Info
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Current Bitcoin Price',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        if (currencyService.isLoading)
                          const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppTheme.bitcoinOrange,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '1 BTC = ${currencyService.formatFiatAmount(currencyService.currentRate)}',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    if (currencyService.lastUpdated != null)
                      Text(
                        'Last updated: ${_formatDateTime(currencyService.lastUpdated!)}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.textSecondary,
                            ),
                      ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.refresh),
                        label: const Text('Refresh Rates'),
                        onPressed: () {
                          currencyService.fetchExchangeRates();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Currency Selection
            Text(
              'Select Currency',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  children: currencyService.availableCurrencies.map((currency) {
                    final isSelected = currency == currencyService.selectedCurrency;
                    final rate = currencyService.exchangeRates[currency] ?? 0.0;
                    
                    return _buildCurrencyOption(
                      context,
                      currency: currency,
                      symbol: _getCurrencySymbol(currency),
                      rate: rate,
                      isSelected: isSelected,
                      onTap: () {
                        currencyService.setSelectedCurrency(currency);
                      },
                    );
                  }).toList(),
                ),
              ),
            ),
            
            // Exchange rate info
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Colors.blue[700],
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Exchange rates are provided by Coingecko API and are updated regularly.',
                      style: TextStyle(
                        color: Colors.blue[700],
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Error message if any
            if (currencyService.error != null)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: Colors.red[700],
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          currencyService.error!,
                          style: TextStyle(
                            color: Colors.red[700],
                            fontSize: 14,
                          ),
                        ),
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
  
  Widget _buildCurrencyOption(
    BuildContext context, {
    required String currency,
    required String symbol,
    required double rate,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppTheme.bitcoinOrange.withOpacity(0.1)
                    : Colors.grey.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  symbol,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isSelected
                        ? AppTheme.bitcoinOrange
                        : AppTheme.textPrimary,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    currency,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: isSelected
                              ? AppTheme.bitcoinOrange
                              : AppTheme.textPrimary,
                        ),
                  ),
                  if (rate > 0)
                    Text(
                      '1 BTC = ${rate.toStringAsFixed(2)} $currency',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                    ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: AppTheme.bitcoinOrange,
              ),
          ],
        ),
      ),
    );
  }
  
  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);
    
    if (diff.inSeconds < 60) {
      return 'Just now';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes} ${diff.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours} ${diff.inHours == 1 ? 'hour' : 'hours'} ago';
    } else {
      final day = dateTime.day.toString().padLeft(2, '0');
      final month = dateTime.month.toString().padLeft(2, '0');
      final hour = dateTime.hour.toString().padLeft(2, '0');
      final minute = dateTime.minute.toString().padLeft(2, '0');
      return '$day/$month/${dateTime.year} $hour:$minute';
    }
  }
  
  String _getCurrencySymbol(String currencyCode) {
    switch (currencyCode) {
      case 'USD': return '\$';
      case 'EUR': return '€';
      case 'GBP': return '£';
      case 'JPY': return '¥';
      case 'CAD': return 'C\$';
      case 'AUD': return 'A\$';
      case 'CHF': return 'Fr';
      default: return currencyCode[0];
    }
  }
}
