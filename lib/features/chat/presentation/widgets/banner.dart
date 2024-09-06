import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniplanet/features/chat/domain/entities/banner_ad.dart';
import 'package:uniplanet/features/chat/presentation/blocs/banner/banner_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class AutoChangingBanner extends StatefulWidget {
  const AutoChangingBanner({super.key});

  @override
  AutoChangingBannerState createState() => AutoChangingBannerState();
}

class AutoChangingBannerState extends State<AutoChangingBanner> {
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startAutoScroll(List<BannerAd> bannerImages) {
    _timer
        ?.cancel(); // Cancel any previous timer to avoid multiple timers running simultaneously
    if (bannerImages.isNotEmpty) {
      _timer = Timer.periodic(const Duration(seconds: 4), (Timer timer) {
        if (mounted) {
          // Check if the widget is still mounted before calling setState
          setState(() {
            if (_currentPage < bannerImages.length - 1) {
              _currentPage++;
            } else {
              _currentPage = 0; // Reset to the first ad
            }
          });
        } else {
          _timer?.cancel(); // Cancel the timer if the widget is not mounted
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BannerBloc, BannerState>(
      builder: (context, state) {
        if (state is BannerLoaded) {
          _startAutoScroll(state.bannerAds);
          return GestureDetector(
            onTap: () async {
              final Uri url = Uri.parse(state.bannerAds[_currentPage].link);
              if (await canLaunchUrl(url)) {
                await launchUrl(url, mode: LaunchMode.externalApplication);
              } else {
                throw 'Could not launch $url';
              }
            },
            child: Container(
              margin: const EdgeInsets.only(top: 10),
              width: 380,
              height: 50.0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: AnimatedSwitcher(
                  duration: const Duration(seconds: 1),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: child,
                    );
                  },
                  child: Image.network(
                    state.bannerAds[_currentPage].image,
                    key: ValueKey<int>(_currentPage),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          );
        }
        return const SizedBox();
      },
    );
  }
}
