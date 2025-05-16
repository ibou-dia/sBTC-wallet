import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_theme.dart';
import '../widgets/main_layout.dart';
import '../widgets/bitcoin_logo.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      currentIndex: -1,
      currentRoute: '/about',
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'About',
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            
            // App logo and name
            const BitcoinLogo(size: 80),
            const SizedBox(height: 24),
            Text(
              'sBTC Wallet',
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Version 1.0.0',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            
            // App description
            const Text(
              'sBTC Wallet is a mobile application for managing your tokenized Bitcoin (sBTC) on the Stacks blockchain.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildLinkRow(
                      context,
                      icon: Icons.code,
                      title: 'GitHub Repository',
                      url: 'https://github.com/user/sbtc-wallet',
                    ),
                    const Divider(height: 24),
                    _buildLinkRow(
                      context,
                      icon: Icons.public,
                      title: 'sBTC Documentation',
                      url: 'https://docs.stacks.co/docs/sbtc/',
                    ),
                    const Divider(height: 24),
                    _buildLinkRow(
                      context,
                      icon: Icons.shield,
                      title: 'Privacy Policy',
                      url: 'https://example.com/privacy',
                    ),
                    const Divider(height: 24),
                    _buildLinkRow(
                      context,
                      icon: Icons.gavel,
                      title: 'Terms of Service',
                      url: 'https://example.com/terms',
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Info sections
            _buildInfoSection(
              context,
              title: 'What is sBTC?',
              content: 'sBTC is a tokenized version of Bitcoin that operates on the Stacks blockchain. It is backed 1:1 by BTC and enables smart contract functionality with Bitcoin-level security.',
            ),
            
            const SizedBox(height: 24),
            
            _buildInfoSection(
              context,
              title: 'How it works',
              content: 'sBTC uses a peg mechanism to lock BTC and mint an equivalent amount of sBTC on the Stacks blockchain. This allows Bitcoin to be used in decentralized applications while maintaining its value.',
            ),
            
            const SizedBox(height: 40),
            
            // Credits
            Text(
              '© 2025 sBTC Wallet Team',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Built with Flutter',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLinkRow(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String url,
  }) {
    return InkWell(
      onTap: () => _launchUrl(url),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppTheme.bitcoinOrange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: AppTheme.bitcoinOrange,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    url,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.open_in_new, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(
    BuildContext context, {
    required String title,
    required String content,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }
}
