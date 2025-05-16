import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../services/wallet_service.dart';
import '../theme/app_theme.dart';
import '../utils/formatters.dart';

class ReceiveScreen extends StatelessWidget {
  const ReceiveScreen({super.key});

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
      appBar: AppBar(
        title: const Text('Receive sBTC'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Your sBTC Address',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Share this address to receive sBTC from others',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              
              // QR Code
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: QrImageView(
                  data: wallet.address,
                  version: QrVersions.auto,
                  size: 200,
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.all(12),
                  embeddedImage: const AssetImage('assets/images/bitcoin-logo.png'),
                  embeddedImageStyle: const QrEmbeddedImageStyle(
                    size: Size(40, 40),
                  ),
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Address display
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.cardBackground,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            Formatters.shortenAddress(wallet.address, start: 12, end: 12),
                            style: Theme.of(context).textTheme.bodyLarge,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Divider(),
                    const SizedBox(height: 8),
                    // Full address (tap to show)
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Full Address'),
                            content: SelectableText(
                              wallet.address,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Close'),
                              ),
                            ],
                          ),
                        );
                      },
                      child: Text(
                        'Tap to view full address',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppTheme.bitcoinOrange,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Copy address button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: wallet.address));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Address copied to clipboard'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  icon: const Icon(Icons.copy),
                  label: const Text('Copy Address'),
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Information card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Colors.amber[800],
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Only send sBTC to this address. Sending other tokens may result in permanent loss.',
                        style: TextStyle(
                          color: Colors.amber[800],
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
