import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CurrencyService extends ChangeNotifier {
  static const String _priceApiUrl = 'https://api.coingecko.com/api/v3/simple/price?ids=bitcoin&vs_currencies=usd,eur,gbp,jpy,cad,aud,chf';
  static const String _prefKeyCurrency = 'selected_currency';
  
  Map<String, double> _exchangeRates = {
    'USD': 0.0,
    'EUR': 0.0,
    'GBP': 0.0,
    'JPY': 0.0,
    'CAD': 0.0,
    'AUD': 0.0,
    'CHF': 0.0,
  };
  
  String _selectedCurrency = 'USD';
  bool _isLoading = false;
  String? _error;
  DateTime? _lastUpdated;
  
  CurrencyService() {
    _loadSelectedCurrency();
    fetchExchangeRates();
  }
  
  // Getters
  Map<String, double> get exchangeRates => _exchangeRates;
  String get selectedCurrency => _selectedCurrency;
  bool get isLoading => _isLoading;
  String? get error => _error;
  DateTime? get lastUpdated => _lastUpdated;
  
  // Get the current exchange rate for the selected currency
  double get currentRate => _exchangeRates[_selectedCurrency] ?? 0.0;
  
  // Get available currencies
  List<String> get availableCurrencies => _exchangeRates.keys.toList();
  
  // Load the selected currency from SharedPreferences
  Future<void> _loadSelectedCurrency() async {
    final prefs = await SharedPreferences.getInstance();
    _selectedCurrency = prefs.getString(_prefKeyCurrency) ?? 'USD';
    notifyListeners();
  }
  
  // Change the selected currency
  Future<void> setSelectedCurrency(String currency) async {
    if (!_exchangeRates.containsKey(currency)) return;
    
    _selectedCurrency = currency;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefKeyCurrency, currency);
    notifyListeners();
  }
  
  // Convert from Bitcoin to fiat
  double btcToFiat(double btcAmount) {
    final rate = _exchangeRates[_selectedCurrency] ?? 0.0;
    return btcAmount * rate;
  }
  
  // Convert from fiat to Bitcoin
  double fiatToBtc(double fiatAmount) {
    final rate = _exchangeRates[_selectedCurrency] ?? 0.0;
    if (rate <= 0) return 0.0;
    return fiatAmount / rate;
  }
  
  // Format the currency amount for display
  String formatFiatAmount(double amount) {
    if (_selectedCurrency == 'JPY') {
      // No decimal places for Japanese Yen
      return '${amount.round()} $_selectedCurrency';
    } else {
      // 2 decimal places for other currencies
      return '${amount.toStringAsFixed(2)} $_selectedCurrency';
    }
  }
  
  // Fetch exchange rates from API
  Future<void> fetchExchangeRates() async {
    if (_isLoading) return;
    
    _setLoading(true);
    _clearError();
    
    try {
      final response = await http.get(Uri.parse(_priceApiUrl));
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        if (data.containsKey('bitcoin')) {
          final bitcoin = data['bitcoin'];
          
          // Update exchange rates
          _exchangeRates = {
            'USD': bitcoin['usd']?.toDouble() ?? 0.0,
            'EUR': bitcoin['eur']?.toDouble() ?? 0.0,
            'GBP': bitcoin['gbp']?.toDouble() ?? 0.0,
            'JPY': bitcoin['jpy']?.toDouble() ?? 0.0,
            'CAD': bitcoin['cad']?.toDouble() ?? 0.0,
            'AUD': bitcoin['aud']?.toDouble() ?? 0.0,
            'CHF': bitcoin['chf']?.toDouble() ?? 0.0,
          };
          
          _lastUpdated = DateTime.now();
        } else {
          _setError('Bitcoin data not found in response');
        }
      } else {
        _setError('Failed to fetch exchange rates: ${response.statusCode}');
      }
    } catch (e) {
      _setError('Error fetching exchange rates: ${e.toString()}');
      
      // Use fallback rates if API call fails
      if (_exchangeRates['USD'] == 0.0) {
        _exchangeRates = {
          'USD': 66000.0, // Fallback rates as of May 2025
          'EUR': 60500.0,
          'GBP': 52000.0,
          'JPY': 9900000.0,
          'CAD': 88000.0,
          'AUD': 97000.0,
          'CHF': 58000.0,
        };
      }
    } finally {
      _setLoading(false);
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
