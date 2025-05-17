import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/wallet_service.dart';
import '../theme/app_theme.dart';
import '../widgets/bitcoin_logo.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final walletService = Provider.of<WalletService>(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Background pattern (subtle Bitcoin pattern)
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              image: DecorationImage(
                image: const AssetImage('assets/images/pattern.png'),
                fit: BoxFit.cover,
                opacity: 0.05,
                colorFilter: ColorFilter.mode(
                  AppTheme.bitcoinOrange.withOpacity(0.2),
                  BlendMode.srcOver,
                ),
              ),
            ),
          ),
          
          // Content
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo and title
                    const BitcoinLogo(size: 80),
                    const SizedBox(height: 32),
                    Text(
                      'Welcome to Your Bitcoin Wallet',
                      style: Theme.of(context).textTheme.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Manage your tokenized Bitcoin via the sBTC protocol on Stacks blockchain',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    
                    SizedBox(height: size.height * 0.08),
                    
                    // Connect wallet button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: walletService.isLoading
                            ? null
                            : () async {
                                final success = await walletService.connectWallet();
                                if (success && context.mounted) {
                                  // Rediriger vers l'onboarding au lieu de l'écran d'accueil
                                  Navigator.pushReplacementNamed(context, '/onboarding');
                                }
                              },
                        child: walletService.isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text('Connect Wallet'),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Create wallet link
                    TextButton(
                      onPressed: walletService.isLoading
                          ? null
                          : () async {
                              final success = await walletService.createWallet();
                              if (success && context.mounted) {
                                Navigator.pushReplacementNamed(context, '/onboarding');
                              }
                            },
                      child: Text(
                        "Don't have a wallet? Create one",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppTheme.bitcoinOrange,
                            ),
                      ),
                    ),
                    
                    // Error message if any
                    if (walletService.error != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 24),
                        child: Text(
                          walletService.error!,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.red,
                              ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
