import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../core/theme/app_colors.dart';
import '../../home/pages/home_page.dart';
import '../../garage/pages/garage_page.dart';
import '../../history/pages/history_page.dart';
import '../../account/pages/account_page.dart';

class MainLayoutPage extends StatefulWidget {
  const MainLayoutPage({super.key});

  @override
  State<MainLayoutPage> createState() => _MainLayoutPageState();
}

class _MainLayoutPageState extends State<MainLayoutPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomePage(),
    GaragePage(),
    HistoryPage(),
    AccountPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _pages[_currentIndex],
      floatingActionButton: Container(
        height: 72,
        width: 72,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.brand.withValues(alpha: 0.2),
        ),
        padding: const EdgeInsets.all(6.0),
        child: SizedBox(
          width: 60,
          height: 60,
          child: FloatingActionButton(
            onPressed: () {},
            elevation: 0,
            backgroundColor: AppColors.brand,
            shape: const CircleBorder(),
            child: Icon(
              PhosphorIcons.wrench(PhosphorIconsStyle.regular),
              color: Colors.white,
              size: 32,
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 4,
              spreadRadius: 0,
              offset: const Offset(0, -1),
            ),
          ],
        ),
        child: BottomAppBar(
          color: Colors.white,
          elevation: 0,
          notchMargin: 8,
          clipBehavior: Clip.antiAlias,
          shape: const AutomaticNotchedShape(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
          ),
          child: SizedBox(
            height: 64,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildNavItem(
                        0,
                        PhosphorIcons.house(PhosphorIconsStyle.regular),
                        PhosphorIcons.house(PhosphorIconsStyle.fill),
                        'Home',
                      ),
                      _buildNavItem(
                        1,
                        PhosphorIcons.motorcycle(PhosphorIconsStyle.regular),
                        PhosphorIcons.motorcycle(PhosphorIconsStyle.fill),
                        'Garage',
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 56),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildNavItem(
                        2,
                        PhosphorIcons.clockCounterClockwise(
                            PhosphorIconsStyle.regular),
                        PhosphorIcons.clockCounterClockwise(
                            PhosphorIconsStyle.fill),
                        'History',
                      ),
                      _buildNavItem(
                        3,
                        PhosphorIcons.user(PhosphorIconsStyle.regular),
                        PhosphorIcons.user(PhosphorIconsStyle.fill),
                        'Profile',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
      int index, IconData iconRegular, IconData iconFill, String label) {
    final isSelected = _currentIndex == index;
    final color = isSelected ? AppColors.brand : const Color(0xFF94A3B8);

    return Expanded(
      child: InkWell(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        onTap: () {
          setState(() {
            _currentIndex = index;
          });
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSelected ? iconFill : iconRegular,
              color: color,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
