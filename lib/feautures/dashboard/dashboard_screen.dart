import 'package:flutter/material.dart';
import 'package:smartversemobile/app/app_route.dart';
import 'package:smartversemobile/feautures/dashboard/presentation/screens/account/presentation/screens/account.dart';
import 'package:smartversemobile/feautures/dashboard/presentation/screens/home/presentation/screens/home.dart';
import 'package:smartversemobile/feautures/dashboard/presentation/screens/load%20Calculator/presentation/screens/load_calculator.dart';
import 'package:smartversemobile/feautures/dashboard/presentation/screens/saved/presentation/screens/saved.dart';
import 'package:smartversemobile/feautures/dashboard/presentation/widgets/dashboard.dart';

class DashboardScreen extends StatefulWidget {
  final int initialIndex;
  const DashboardScreen({super.key, this.initialIndex = 0});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  final List<Widget> _tabRoots = const [
    Home(),
    LoadCalculator(),
    Saved(),
    Account(),
  ];

  Widget _buildTabNavigator(int index) {
    return Navigator(
      key: _navigatorKeys[index],
      onGenerateRoute: (settings) {
        if (settings.name == '/') {
          return MaterialPageRoute(builder: (_) => _tabRoots[index]);
        }

        final builder = AppRoute.routes[settings.name];
        if (builder != null) {
          return MaterialPageRoute(builder: builder, settings: settings);
        }
        return null;
      },
    );
  }

  void _onNavTap(int index) {
    if (index == _currentIndex) {
      _navigatorKeys[index].currentState?.popUntil((route) => route.isFirst);
    } else {
      setState(() => _currentIndex = index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: List.generate(_tabRoots.length, _buildTabNavigator),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onNavTap,
      ),
    );
  }
}
