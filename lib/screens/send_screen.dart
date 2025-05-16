import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/wallet_service.dart';
import '../services/currency_service.dart';
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
  final _btcAmountController = TextEditingController();
  final _fiatAmountController = TextEditingController();
  bool _isSending = false;
  String? _errorMessage;
  bool _inputInFiat = false; // Track whether user is inputting in sBTC or fiat

  @override
  void initState() {
    super.initState();
    _btcAmountController.addListener(_onBtcAmountChanged);
    _fiatAmountController.addListener(_onFiatAmountChanged);
  }

  @override
  void dispose() {
    _btcAmountController.removeListener(_onBtcAmountChanged);
    _fiatAmountController.removeListener(_onFiatAmountChanged);
    _addressController.dispose();
    _btcAmountController.dispose();
    _fiatAmountController.dispose();
    super.dispose();
  }

  // When BTC amount changes, update the fiat amount
  void _onBtcAmountChanged() {
    if (_inputInFiat) return; // Avoid infinite loop
    
    final currencyService = Provider.of<CurrencyService>(context, listen: false);
    
    if (_btcAmountController.text.isEmpty) {
      _fiatAmountController.text = '';
      return;
    }
    
    try {
      final btcAmount = double.parse(_btcAmountController.text);
      final fiatAmount = currencyService.btcToFiat(btcAmount);
      
      _inputInFiat = true; // Prevent callback loop
      _fiatAmountController.text = fiatAmount.toStringAsFixed(2);
      _inputInFiat = false;
    } catch (e) {
      // Invalid input, ignore
    }
  }

  // When fiat amount changes, update the BTC amount
  void _onFiatAmountChanged() {
    if (!_inputInFiat) return; // Avoid infinite loop
    
    final currencyService = Provider.of<CurrencyService>(context, listen: false);
    
    if (_fiatAmountController.text.isEmpty) {
      _btcAmountController.text = '';
      return;
    }
    
    try {
      final fiatAmount = double.parse(_fiatAmountController.text);
      final btcAmount = currencyService.fiatToBtc(fiatAmount);
      
      _inputInFiat = false; // Prevent callback loop
      _btcAmountController.text = btcAmount.toStringAsFixed(8);
    } catch (e) {
      // Invalid input, ignore
    }
  }

  void _toggleInputMode() {
    setState(() {
      _inputInFiat = !_inputInFiat;
    });
  }

  Future<void> _sendTransaction(WalletService walletService) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSending = true;
      _errorMessage = null;
    });

    try {
      final address = _addressController.text.trim();
      final amount = double.parse(_btcAmountController.text);
      
      final success = await walletService.sendTransaction(address, amount);
      
      if (success && mounted) {
        // Show success message and go back to home
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Transaction sent successfully'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pushReplacementNamed(context, '/home');
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
    final currencyService = Provider.of<CurrencyService>(context);
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
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textPrimary),
          onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
        ),
        title: const Text(
          'Send sBTC',
          style: TextStyle(color: AppTheme.textPrimary),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Balance info
              Card(
                elevation: 2,
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
              
              // Amount with currency converter
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Amount',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  TextButton.icon(
                    icon: Icon(
                      _inputInFiat ? Icons.currency_bitcoin : Icons.attach_money,
                      size: 18,
                    ),
                    label: Text(
                      _inputInFiat 
                          ? 'Switch to sBTC' 
                          : 'Switch to ${currencyService.selectedCurrency}',
                      style: const TextStyle(fontSize: 14),
                    ),
                    onPressed: _toggleInputMode,
                    style: TextButton.styleFrom(
                      foregroundColor: AppTheme.bitcoinOrange,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              
              // Currency conversion UI
              AnimatedCrossFade(
                firstChild: _buildBtcInput(wallet),
                secondChild: _buildFiatInput(currencyService),
                crossFadeState: _inputInFiat 
                    ? CrossFadeState.showSecond 
                    : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 300),
              ),
              
              // Conversion display
              const SizedBox(height: 16),
              _buildConversionDisplay(currencyService),
              
              // Send button
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSending || _btcAmountController.text.isEmpty
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
    );
  }
  
  Widget _buildBtcInput(wallet) {
    return TextFormField(
      controller: _btcAmountController,
      decoration: const InputDecoration(
        hintText: 'Enter amount',
        prefixIcon: Icon(Icons.currency_bitcoin),
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
    );
  }
  
  Widget _buildFiatInput(CurrencyService currencyService) {
    return TextFormField(
      controller: _fiatAmountController,
      decoration: InputDecoration(
        hintText: 'Enter amount',
        prefixIcon: const Icon(Icons.attach_money),
        suffixText: currencyService.selectedCurrency,
      ),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      onChanged: (value) {
        setState(() {
          _inputInFiat = true;
        });
      },
    );
  }
  
  Widget _buildConversionDisplay(CurrencyService currencyService) {
    String displayText = 'Enter an amount to see conversion';
    
    try {
      if (_inputInFiat) {
        if (_fiatAmountController.text.isNotEmpty) {
          final fiatAmount = double.parse(_fiatAmountController.text);
          final btcAmount = currencyService.fiatToBtc(fiatAmount);
          displayText = '${fiatAmount.toStringAsFixed(2)} ${currencyService.selectedCurrency} = ${Formatters.formatBitcoin(btcAmount)} sBTC';
        }
      } else {
        if (_btcAmountController.text.isNotEmpty) {
          final btcAmount = double.parse(_btcAmountController.text);
          final fiatAmount = currencyService.btcToFiat(btcAmount);
          displayText = '${Formatters.formatBitcoin(btcAmount)} sBTC = ${fiatAmount.toStringAsFixed(2)} ${currencyService.selectedCurrency}';
        }
      }
    } catch (e) {
      displayText = 'Invalid amount';
    }
    
    return Card(
      elevation: 0,
      color: AppTheme.cardBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(
              Icons.sync_alt,
              size: 16,
              color: AppTheme.textSecondary,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                displayText,
                style: TextStyle(
                  fontSize: 14,
                  color: AppTheme.textSecondary,
                ),
              ),
            ),
            if (currencyService.isLoading)
              const SizedBox(
                height: 16,
                width: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
