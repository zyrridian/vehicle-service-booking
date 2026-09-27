import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../auth/pages/login_page.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

class OnboardingData {
  final String imagePath;
  final String title;
  final String subtitle;

  OnboardingData({
    required this.imagePath,
    required this.title,
    required this.subtitle,
  });
}

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingData> _pages = [
    OnboardingData(
      imagePath: 'assets/images/onboarding1.svg',
      title: 'Book Multiple Motorbikes at Once',
      subtitle: 'Manage services, parts, and issues for each bike\nin a single order',
    ),
    OnboardingData(
      imagePath: 'assets/images/onboarding2.svg',
      title: 'Track Service in Real Time',
      subtitle: 'Track each bike\'s progress from drop-off to\ncompletion',
    ),
    OnboardingData(
      imagePath: 'assets/images/onboarding3.svg',
      title: 'Organized History & Invoices',
      subtitle: 'All service records and receipts are saved\nautomatically',
    ),
  ];

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      FlutterNativeSplash.remove();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToLogin(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  Widget _buildDots() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(_pages.length, (index) {
        final isActive = _currentPage == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.only(right: 6),
          height: 6,
          width: isActive ? 24 : 6,
          decoration: BoxDecoration(
            color: isActive ? AppColors.brand : AppColors.line,
            borderRadius: BorderRadius.circular(3),
          ),
        );
      }),
    );
  }

  Widget _buildBackButton() {
    return InkWell(
      onTap: () {
        _pageController.previousPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      },
      borderRadius: BorderRadius.circular(28),
      child: Container(
        width: 56,
        height: 56,
        decoration: const BoxDecoration(
          color: AppColors.line, // light grey
          shape: BoxShape.circle,
        ),
        child: const Icon(
          LucideIcons.chevronLeft,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // LEFT COMPONENT
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _currentPage == 2
              ? Container(key: const ValueKey('back_left'), child: _buildBackButton())
              : Container(key: const ValueKey('dots'), child: _buildDots()),
        ),

        // RIGHT COMPONENT
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Back button on right for page 1
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: _currentPage == 1 ? 56 : 0,
              margin: EdgeInsets.only(right: _currentPage == 1 ? 16 : 0),
              child: ClipRRect( // To prevent overflow during animation
                borderRadius: BorderRadius.circular(28),
                child: _currentPage == 1 ? _buildBackButton() : const SizedBox.shrink(),
              ),
            ),
            
            // Next / Get Started button
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              height: 56,
              width: _currentPage == 2 ? 160 : 56,
              decoration: BoxDecoration(
                color: AppColors.brand,
                borderRadius: BorderRadius.circular(28),
              ),
              child: InkWell(
                onTap: () {
                  if (_currentPage == _pages.length - 1) {
                    _goToLogin(context);
                  } else {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  }
                },
                borderRadius: BorderRadius.circular(28),
                child: Center(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: _currentPage == 2
                        ? const Text(
                            'Get Started!',
                            key: ValueKey('get_started'),
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          )
                        : const Icon(
                            LucideIcons.chevronRight,
                            key: ValueKey('next_icon'),
                            color: Colors.white,
                          ),
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top row with Skip button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
              child: Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () => _goToLogin(context),
                  child: const Text(
                    'Skip',
                    style: TextStyle(
                      color: AppColors.brand,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
            
            // PageView for content
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Image
                        Expanded(
                          child: Center(
                            child: SvgPicture.asset(
                              page.imagePath,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        // Title
                        Text(
                          page.title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppColors.ink,
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Subtitle
                        Text(
                          page.subtitle,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.ink.withOpacity(0.5),
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 64),
                      ],
                    ),
                  );
                },
              ),
            ),
            
            // Bottom Navigation Row
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
              child: _buildBottomNav(),
            ),
          ],
        ),
      ),
    );
  }
}
