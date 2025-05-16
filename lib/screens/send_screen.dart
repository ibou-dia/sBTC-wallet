import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/wallet_service.dart';
import '../theme/app_theme.dart';
import '../utils/formatters.dart';

class SendScreen extends StatefulWidget {
  const SendScreen({super.key});

  @override
  State<SendScreen> createState() => _SendScreenState();
}

class _SendScreenState extends State<SendScreen> {
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  final _amountController = TextEditingController();
  bool _isSending = false;
  String? _errorMessage;

  @override
  void dispose() {
    _addressController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _sendTransaction(WalletService walletService) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSending = true;
      _errorMessage = null;
    });

    try {
      final address = _addressController.text.trim();
      final amount = double.parse(_amountController.text);
      
      final success = await walletService.sendTransaction(address, amount);
      
      if (success && mounted) {
        // Show success message and go back to home
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Transaction sent successfully'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } else {
        setState(() {
          _errorMessage = 'Failed to send transaction';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isSending = false;
      });
    }
  }

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
        title: const Text('Send sBTC'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Balance info
                Card(
                  elevation: 0,
                  color: AppTheme.cardBackground,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: const BoxDecoration(
                            color: AppTheme.bitcoinOrange,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.account_balance_wallet,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Available Balance',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: AppTheme.textSecondary,
                                    ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${Formatters.formatBitcoin(wallet.balance)} sBTC',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Recipient address
                Text(
                  'Recipient Address',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _addressController,
                  decoration: const InputDecoration(
                    hintText: 'Enter sBTC address',
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter an address';
                    }
                    // In a real app, validate the sBTC address format
                    if (value.length < 10) {
                      return 'Please enter a valid sBTC address';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 24),
                
                // Amount
                Text(
                  'Amount',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _amountController,
                  decoration: const InputDecoration(
                    hintText: 'Enter amount',
                    prefixIcon: Icon(Icons.monetization_on),
                    suffixText: 'sBTC',
                  ),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter an amount';
                    }
                    try {
                      final amount = double.parse(value);
                      if (amount <= 0) {
                        return 'Amount must be greater than 0';
                      }
                      if (amount > wallet.balance) {
                        return 'Insufficient balance';
                      }
                    } catch (e) {
                      return 'Please enter a valid amount';
                    }
                    return null;
                  },
                ),
                
                // Send button
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isSending
                        ? null
                        : () => _sendTransaction(walletService),
                    child: _isSending
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text('Send sBTC'),
                  ),
                ),
                
                // Error message
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text(
                      _errorMessage!,
                      style: TextStyle(
                        color: Colors.red[700],
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  
                // Transaction note
                const SizedBox(height: 24),
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
                          'Transactions may take a few minutes to be confirmed on the Stacks blockchain.',
                          style: TextStyle(
                            color: Colors.blue[700],
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
      ),
    );
  }
}
