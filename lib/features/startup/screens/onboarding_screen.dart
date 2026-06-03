import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../config/routes/route_names.dart';
import '../../../core/theme/app_theme.dart';
import '../../auth/presentation/screens/sign_in_screen.dart';

class OnboardingData {
  final String image;
  final String title;
  final String subtitle;
  final Color bgColor;

  const OnboardingData({
    required this.image,
    required this.title,
    required this.subtitle,
    required this.bgColor,
  });
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  late AnimationController _imageController;
  late AnimationController _contentController;
  late Animation<double> _imageScale;
  late Animation<double> _contentOpacity;
  late Animation<Offset> _contentSlide;

  final List<OnboardingData> _pages = const [
    OnboardingData(
      image: 'assets/images/shopping_bag.png',
      title: 'Explore New\nArrivals Daily',
      subtitle:
          'Discover thousands of trending styles and\nbrand-new collections every day.',
      bgColor: Color(0xFFFFF0F2),
    ),
    OnboardingData(
      image: 'assets/images/sales_consulting.png',
      title: 'Easy &\nSecure Checkout',
      subtitle:
          'Shop with confidence using our fast,\nsecure, and seamless payment system.',
      bgColor: Color(0xFFF0F4FF),
    ),
    OnboardingData(
      image: 'assets/images/fashion_shop.png',
      title: 'Your Style,\nYour Story',
      subtitle:
          'Find the perfect fit for every occasion\nand express yourself with fashion.',
      bgColor: Color(0xFFFFF8F0),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _imageController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _contentController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _imageScale = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _imageController, curve: Curves.easeOutBack),
    );
    _contentOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _contentController, curve: Curves.easeIn),
    );
    _contentSlide = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _contentController, curve: Curves.easeOut),
        );
    _playAnimations();
  }

  void _playAnimations() {
    _imageController.forward(from: 0);
    _contentController.forward(from: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _imageController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _goToNextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
      );
    } else {
      _navigateToSignIn();
    }
  }
  void _navigateToSignIn() {
    context.go(RouteNames.login);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Page view
          PageView.builder(
            controller: _pageController,
            itemCount: _pages.length,
            onPageChanged: (index) {
              setState(() => _currentPage = index);
              _playAnimations();
            },
            itemBuilder: (context, index) {
              return _buildPage(_pages[index], size);
            },
          ),
          // Skip button
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            right: 24,
            child: GestureDetector(
              onTap: _navigateToSignIn,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  'Skip',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          ),
          // Bottom controls
          Positioned(
            bottom: MediaQuery.of(context).padding.bottom + 40,
            left: 32,
            right: 32,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Page indicator
                SmoothPageIndicator(
                  controller: _pageController,
                  count: _pages.length,
                  effect: ExpandingDotsEffect(
                    activeDotColor: AppColors.primary,
                    dotColor: AppColors.primary.withOpacity(0.2),
                    dotHeight: 8,
                    dotWidth: 8,
                    expansionFactor: 3.5,
                    spacing: 6,
                  ),
                ),
                // Next / Get Started button
                GestureDetector(
                  onTap: _goToNextPage,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: _currentPage == _pages.length - 1 ? 160 : 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.35),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Center(
                      child: _currentPage == _pages.length - 1
                          ? Text(
                              'Get Started',
                              style: GoogleFonts.poppins(
                                color: AppColors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            )
                          : const Icon(
                              Icons.arrow_forward_rounded,
                              color: AppColors.white,
                              size: 26,
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(OnboardingData data, Size size) {
    return Column(
      children: [
        // Image section with colored background
        AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          height: size.height * 0.52,
          width: double.infinity,
          decoration: BoxDecoration(
            color: data.bgColor,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(40),
              bottomRight: Radius.circular(40),
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: AnimatedBuilder(
              animation: _imageController,
              builder: (context, child) {
                return Transform.scale(
                  scale: _imageScale.value,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
                    child: Image.asset(data.image, fit: BoxFit.contain),
                  ),
                );
              },
            ),
          ),
        ),
        // Content section
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(32, 40, 32, 100),
            child: AnimatedBuilder(
              animation: _contentController,
              builder: (context, child) {
                return Opacity(
                  opacity: _contentOpacity.value,
                  child: SlideTransition(
                    position: _contentSlide,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data.title,
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                            height: 1.25,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          data.subtitle,
                          style: GoogleFonts.poppins(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textSecondary,
                            height: 1.7,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
