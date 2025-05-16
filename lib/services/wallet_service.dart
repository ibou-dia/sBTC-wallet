import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/wallet.dart';
import '../models/transaction.dart';
import '../utils/constants.dart';

// Note: We removed flutter_secure_storage dependency due to Android SDK platform issues
// and we're now using only shared_preferences for storage

class WalletService extends ChangeNotifier {
  Wallet? _wallet;
  List<Transaction> _transactions = [];
  bool _isLoading = false;
  String? _error;

  WalletService() {
    _loadWallet();
    _loadTransactions();
  }

  // Getters
  Wallet? get wallet => _wallet;
  List<Transaction> get transactions => _transactions;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isConnected => _wallet != null && _wallet!.connected;

  // Load wallet data from storage
  Future<void> _loadWallet() async {
    _setLoading(true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final address = prefs.getString(Constants.keyWalletAddress);
      final balance = prefs.getDouble(Constants.keyWalletBalance) ?? 0.0;

      if (address != null) {
        _wallet = Wallet(
          address: address,
          balance: balance,
          connected: true,
        );
      }
      _setLoading(false);
    } catch (e) {
      _setError('Failed to load wallet: ${e.toString()}');
    }
  }

  // Load transaction history (currently using sample data)
  Future<void> _loadTransactions() async {
    _transactions = Transaction.getSampleTransactions();
    notifyListeners();
  }

  // Connect wallet
  Future<bool> connectWallet() async {
    _setLoading(true);
    _clearError();
    
    try {
      // In a real app, this would connect to an actual wallet
      // For demo purposes, we're just creating a wallet with sample data
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(Constants.keyWalletAddress, Constants.dummyWalletAddress);
      await prefs.setDouble(Constants.keyWalletBalance, 0.0125);
      
      _wallet = Wallet(
        address: Constants.dummyWalletAddress,
        balance: 0.0125,
        connected: true,
      );
      
      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Failed to connect wallet: ${e.toString()}');
      return false;
    }
  }

  // Create a new wallet
  Future<bool> createWallet() async {
    _setLoading(true);
    _clearError();
    
    try {
      // In a real app, this would actually create a wallet
      // For demo purposes, we're just simulating wallet creation
      await Future.delayed(const Duration(seconds: 2)); // Simulate API call
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(Constants.keyWalletAddress, Constants.dummyWalletAddress);
      await prefs.setDouble(Constants.keyWalletBalance, 0);
      
      _wallet = Wallet(
        address: Constants.dummyWalletAddress,
        balance: 0,
        connected: true,
      );
      
      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Failed to create wallet: ${e.toString()}');
      return false;
    }
  }

  // Send sBTC transaction
  Future<bool> sendTransaction(String toAddress, double amount) async {
    if (_wallet == null) return false;
    if (amount <= 0 || amount > _wallet!.balance) return false;
    
    _setLoading(true);
    _clearError();
    
    try {
      // In a real app, this would send an actual transaction
      // For demo purposes, we're just simulating a transaction
      await Future.delayed(const Duration(seconds: 2)); // Simulate blockchain confirmation
      
      // Create new transaction
      final newTransaction = Transaction(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: TransactionType.sent,
        amount: amount,
        address: toAddress,
        timestamp: DateTime.now(),
        hash: '0x${DateTime.now().millisecondsSinceEpoch.toRadixString(16)}',
        confirmed: true,
      );
      
      // Update wallet balance
      final newBalance = _wallet!.balance - amount;
      _wallet = _wallet!.copyWith(balance: newBalance);
      
      // Update shared preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble(Constants.keyWalletBalance, newBalance);
      
      // Add transaction to history
      _transactions.insert(0, newTransaction);
      
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Failed to send transaction: ${e.toString()}');
      return false;
    }
  }

  // Disconnect wallet
  Future<void> disconnectWallet() async {
    _setLoading(true);
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(Constants.keyWalletAddress);
      await prefs.remove(Constants.keyWalletBalance);
      
      _wallet = null;
      _transactions = [];
      
      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setError('Failed to disconnect wallet: ${e.toString()}');
    }
  }

  // Helper methods for state management
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? errorMessage) {
    _error = errorMessage;
    _isLoading = false;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }
}
