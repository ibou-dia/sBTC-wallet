import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class BitcoinLogo extends StatelessWidget {
  final double size;
  final Color? color;

  const BitcoinLogo({
    super.key, 
    this.size = 48, 
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color ?? AppTheme.bitcoinOrange,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          '₿',
          style: TextStyle(
            color: Colors.white,
            fontSize: size * 0.6,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
