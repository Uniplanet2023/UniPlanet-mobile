import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:uniket/constants/utils.dart';
import 'package:uniket/features/on_boarding/screens/first_page.dart';
import 'package:uniket/features/on_boarding/screens/second_page.dart';
import 'package:uniket/features/on_boarding/screens/third_page.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _controller = PageController();
  bool _isLastPage = false;

  void _onPageChanged(int index) {
    setState(() {
      _isLastPage = (index == 2); // Check if this is the last page
    });
  }

  void _skipOnboarding() {
    _controller.jumpToPage(2); // Skip to the last page
  }

  void _nextPage() {
    if (_isLastPage) {
      // Handle "Finish" or navigation to another part of your app
      log('Finish onboarding');
    } else {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose(); // Don't forget to dispose the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _controller, // Attach the controller here
            onPageChanged: _onPageChanged, // Handle page changes
            children: const [
              PageOne(),
              PageTwo(),
              PageThree(),
            ],
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Center(
              child: _isLastPage
                  ? const SizedBox()
                  : SmoothPageIndicator(
                      controller: _controller, // Attach the controller here
                      count: 3,
                      effect: const WormEffect(
                        dotWidth: 12,
                        dotHeight: 12,
                        spacing: 10,
                        activeDotColor: Colors.white,
                        dotColor: Colors.grey,
                      ),
                    ),
            ),
          ),
          _isLastPage
              ? const SizedBox()
              : Positioned(
                  bottom: 30,
                  left: 20,
                  child: TextButton(
                    onPressed: _skipOnboarding,
                    child: const Text("Skip",
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
          _isLastPage
              ? const SizedBox()
              : Positioned(
                  bottom: 30,
                  right: 20,
                  child: TextButton(
                    onPressed: _nextPage,
                    child: const Text("Next",
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
        ],
      ),
    );
  }
}
