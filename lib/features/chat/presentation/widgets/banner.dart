import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
    // Start auto-scroll when the widget is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _startAutoScroll();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startAutoScroll() {
    _timer
        ?.cancel(); // Cancel any previous timer to avoid multiple timers running simultaneously
    _timer = Timer.periodic(const Duration(seconds: 4), (Timer timer) {
      if (mounted) {
        // Check if the widget is still mounted before calling setState
        setState(() {
          _currentPage++;
        });
      } else {
        _timer?.cancel(); // Cancel the timer if the widget is not mounted
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BannerBloc, BannerState>(
      builder: (context, state) {
        if (state is BannerLoaded && state.bannerAds.isNotEmpty) {
          final bannerAds = state.bannerAds;
          _currentPage = _currentPage % bannerAds.length;
          return GestureDetector(
            onTap: () async {
              final Uri url = Uri.parse(bannerAds[_currentPage].link);
              if (await canLaunchUrl(url)) {
                await launchUrl(url, mode: LaunchMode.externalApplication);
              } else {
                throw 'Could not launch $url';
              }
            },
            child: Container(
              margin: const EdgeInsets.only(top: 5),
              child: SizedBox(
                width: 360,
                height: 60.0,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      CachedNetworkImage(
                        imageUrl: bannerAds[_currentPage].image,
                        width: 370,
                        height: 60.0,
                        fit: BoxFit
                            .cover, // Ensure the image covers the entire width

                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ],
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
