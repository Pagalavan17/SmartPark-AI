import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/primary_button.dart';

/// Onboarding Data Item Model
class OnboardingData {
  final IconData icon;
  final String title;
  final String description;
  final Color accentColor;

  const OnboardingData({
    required this.icon,
    required this.title,
    required this.description,
    required this.accentColor,
  });
}

/// Interactive 3-Step Onboarding Screen
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<OnboardingData> _pages = const [
    OnboardingData(
      icon: Icons.local_parking,
      title: 'Real-Time Smart Parking',
      description: 'Find open parking spots in real-time near your destination powered by AI predictions.',
      accentColor: AppColors.primary,
    ),
    OnboardingData(
      icon: Icons.alt_route_rounded,
      title: 'AI Traffic & Smart Routes',
      description: 'Avoid traffic bottlenecks with real-time congestion forecasting and route optimization.',
      accentColor: AppColors.secondary,
    ),
    OnboardingData(
      icon: Icons.qr_code_2_rounded,
      title: 'Instant Booking & QR Pass',
      description: 'Reserve your spot in advance, pay securely via Razorpay, and enter using contactless QR code.',
      accentColor: Color(0xFF00E676),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar with Skip Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.local_parking_rounded, color: AppColors.primary, size: 28),
                      const SizedBox(width: 6),
                      Text(
                        'SmartPark AI',
                        style: AppTextStyles.headingSmall.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  if (_currentIndex < _pages.length - 1)
                    TextButton(
                      onPressed: () => context.go('/login'),
                      child: Text(
                        'Skip',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // PageView Content
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  final item = _pages[index];
                  return Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Illustration Container
                        Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            color: item.accentColor.withValues(alpha: 0.12),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Icon(
                              item.icon,
                              size: 100,
                              color: item.accentColor,
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                        Text(
                          item.title,
                          style: AppTextStyles.headingLarge,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 14),
                        Text(
                          item.description,
                          style: AppTextStyles.bodyLarge.copyWith(
                            color: AppColors.textSecondary,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Bottom Navigation Area (Indicators + Buttons)
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  // Smooth Dot Indicators
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _pages.length,
                      (index) => AnimatedContainer(
                        duration: AppConstants.defaultAnimationDuration,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _currentIndex == index ? 28 : 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: _currentIndex == index
                              ? AppColors.primary
                              : AppColors.border,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Dynamic Next / Get Started Button
                  PrimaryButton(
                    text: _currentIndex == _pages.length - 1 ? 'Get Started' : 'Next',
                    onPressed: () {
                      if (_currentIndex < _pages.length - 1) {
                        _pageController.nextPage(
                          duration: AppConstants.defaultAnimationDuration,
                          curve: Curves.easeInOut,
                        );
                      } else {
                        context.go('/login');
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
