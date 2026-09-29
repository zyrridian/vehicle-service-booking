import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../core/theme/app_colors.dart';
import '../../home/pages/home_page.dart';
import '../../garage/pages/garage_page.dart';
import '../../history/pages/history_page.dart';
import '../../account/pages/account_page.dart';
import '../../booking/pages/booking_select_vehicles_page.dart';

class MainLayoutPage extends StatefulWidget {
  const MainLayoutPage({super.key});

  @override
  State<MainLayoutPage> createState() => _MainLayoutPageState();
}

class _MainLayoutPageState extends State<MainLayoutPage> {
  int _currentIndex = 0;

  void _switchTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      HomePage(onNavigateToTab: _switchTab),
      const GaragePage(),
      const HistoryPage(),
      const AccountPage(),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      extendBody: true,
      body: pages[_currentIndex],
      floatingActionButton: Container(
        height: 72,
        width: 72,
        padding: const EdgeInsets.all(6.0),
        child: SizedBox(
          width: 60,
          height: 60,
          child: FloatingActionButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (_) => const BookingSelectVehiclesPage()),
              );
            },
            elevation: 2,
            highlightElevation: 4,
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
      bottomNavigationBar: CustomPaint(
        painter: _BottomNavShadowPainter(),
        child: BottomAppBar(
          color: Colors.transparent,
          elevation: 0,
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
                const SizedBox(width: 80),
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

class _BottomNavShadowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final host = Rect.fromLTWH(0, 0, size.width, size.height);
    final guest = Rect.fromCenter(
      center: Offset(size.width / 2, 0),
      width: 72,
      height: 72,
    ).inflate(8);

    final notchPath =
        const CircularNotchedRectangle().getOuterPath(host, guest);
    final rrectPath = Path()
      ..addRRect(RRect.fromRectAndCorners(
        host,
        topLeft: const Radius.circular(24),
        topRight: const Radius.circular(24),
      ));
    final path = Path.combine(PathOperation.intersect, notchPath, rrectPath);

    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.08)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    canvas.save();
    canvas.translate(0, -2);
    canvas.drawPath(path, shadowPaint);
    canvas.restore();

    final fillPaint = Paint()..color = Colors.white;
    canvas.drawPath(path, fillPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
