import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';
import '../theme/app_theme.dart';
import '../utils/constants.dart';

class MainLayout extends StatefulWidget {
  final Widget child;
  final int currentIndex;
  final String currentRoute;

  const MainLayout({
    super.key, 
    required this.child, 
    required this.currentIndex,
    required this.currentRoute,
  });

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: AppDrawer(currentRoute: widget.currentRoute),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: AppTheme.textPrimary),
          onPressed: () {
            _scaffoldKey.currentState!.openDrawer();
            _animationController.forward();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: AppTheme.textPrimary),
            onPressed: () {
              // TODO: Implement notifications
            },
          ),
        ],
      ),
      body: widget.child,
      bottomNavigationBar: widget.currentIndex < 0 ? null : Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              spreadRadius: 1,
              blurRadius: 10,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: BottomNavigationBar(
            currentIndex: widget.currentIndex,
            backgroundColor: Colors.white,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: AppTheme.bitcoinOrange,
            unselectedItemColor: AppTheme.textSecondary,
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
            unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
            elevation: 0,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.arrow_upward_outlined),
                activeIcon: Icon(Icons.arrow_upward),
                label: 'Send',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.arrow_downward_outlined),
                activeIcon: Icon(Icons.arrow_downward),
                label: 'Receive',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.history_outlined),
                activeIcon: Icon(Icons.history),
                label: 'History',
              ),
            ],
            onTap: (index) {
              if (index != widget.currentIndex) {
                switch (index) {
                  case 0:
                    Navigator.pushReplacementNamed(context, Constants.routeHome);
                    break;
                  case 1:
                    Navigator.pushReplacementNamed(context, Constants.routeSend);
                    break;
                  case 2:
                    Navigator.pushReplacementNamed(context, Constants.routeReceive);
                    break;
                  case 3:
                    Navigator.pushReplacementNamed(context, Constants.routeTransactions);
                    break;
                }
              }
            },
          ),
        ),
      ),
    );
  }
}
