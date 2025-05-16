import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Import services
import 'services/wallet_service.dart';

// Import screens
import 'screens/auth_screen.dart';
import 'screens/home_screen.dart';
import 'screens/send_screen.dart';
import 'screens/receive_screen.dart';
import 'screens/transactions_screen.dart';
import 'screens/onboarding_screen.dart';

// Import theme
import 'theme/app_theme.dart';

// Import utils
import 'utils/constants.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WalletService()),
      ],
      child: MaterialApp(
        title: Constants.appName,
        theme: AppTheme.lightTheme,
        initialRoute: Constants.routeAuth,
        routes: {
          Constants.routeAuth: (context) => const AuthScreen(),
          Constants.routeHome: (context) => const HomeScreen(),
          Constants.routeSend: (context) => const SendScreen(),
          Constants.routeReceive: (context) => const ReceiveScreen(),
          Constants.routeTransactions: (context) => const TransactionsScreen(),
          Constants.routeOnboarding: (context) => const OnboardingScreen(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
