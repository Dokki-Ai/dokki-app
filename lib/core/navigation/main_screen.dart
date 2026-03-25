import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../theme/app_theme.dart';
import '../../features/catalog/presentation/screens/catalog_screen.dart';
import '../../features/my_bots/presentation/screens/my_bots_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/support/presentation/screens/support_screen.dart';
import '../localization/language_provider.dart';
import '../localization/app_strings.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    CatalogScreen(),
    MyBotsScreen(),
    SettingsScreen(),
    SupportScreen(),
  ];

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final AppStrings s = ref.watch(stringsProvider);

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTap,
        backgroundColor: AppColors.background,
        selectedItemColor: AppColors.accent,
        unselectedItemColor: AppColors.textSecondary,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: const FaIcon(FontAwesomeIcons.store),
            label: s.navShop,
          ),
          BottomNavigationBarItem(
            icon: const FaIcon(FontAwesomeIcons.robot),
            label: s.navMyBots,
          ),
          BottomNavigationBarItem(
            icon: const FaIcon(FontAwesomeIcons.gear),
            label: s.navSettings,
          ),
          BottomNavigationBarItem(
            icon: const FaIcon(FontAwesomeIcons.headset),
            label: s.navSupport,
          ),
        ],
      ),
    );
  }
}
