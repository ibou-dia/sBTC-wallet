import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';
import '../utils/formatters.dart';

class AddressCard extends StatelessWidget {
  final String address;
  final bool showCopyButton;
  final bool showFullAddress;

  const AddressCard({
    super.key,
    required this.address,
    this.showCopyButton = true,
    this.showFullAddress = false,
  });

  @override
  Widget build(BuildContext context) {
    final displayAddress = showFullAddress 
        ? address 
        : Formatters.shortenAddress(address);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Text(
              displayAddress,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          if (showCopyButton) 
            IconButton(
              icon: const Icon(Icons.copy, size: 20),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: address));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Address copied to clipboard'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              splashRadius: 20,
              color: AppTheme.bitcoinOrange,
            ),
        ],
      ),
    );
  }
}
