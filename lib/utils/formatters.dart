class Formatters {
  /// Abbreviates an address to show the first and last few characters
  static String shortenAddress(String address, {int start = 6, int end = 4}) {
    if (address.length <= start + end) {
      return address;
    }
    return '${address.substring(0, start)}...${address.substring(address.length - end)}';
  }

  /// Formats a Bitcoin amount with the appropriate number of decimal places
  static String formatBitcoin(double amount, {int decimals = 8}) {
    return amount.toStringAsFixed(decimals).replaceAll(RegExp(r'([.]*0+)$'), '');
  }

  /// Format transaction date
  static String formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    
    if (diff.inDays == 0) {
      if (diff.inHours == 0) {
        return '${diff.inMinutes} min ago';
      }
      return '${diff.inHours} hours ago';
    } else if (diff.inDays < 7) {
      return '${diff.inDays} days ago';
    } else {
      final month = _getMonthName(date.month);
      return '${date.day} $month, ${date.year}';
    }
  }

  static String _getMonthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }
}
