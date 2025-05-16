class Wallet {
  final String address;
  final double balance;
  final bool connected;

  const Wallet({
    required this.address,
    required this.balance,
    this.connected = false,
  });

  // Create a copy of the wallet with updated properties
  Wallet copyWith({
    String? address,
    double? balance,
    bool? connected,
  }) {
    return Wallet(
      address: address ?? this.address,
      balance: balance ?? this.balance,
      connected: connected ?? this.connected,
    );
  }
}
