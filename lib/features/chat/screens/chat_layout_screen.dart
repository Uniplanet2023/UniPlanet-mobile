import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:uniplanet/bloc/chat/chat_bloc.dart';
import 'package:uniplanet/constants/global_variables.dart';
import 'package:uniplanet/features/chat/widgets/contacts_list.dart';
import 'package:uniplanet/api/ads/ad_mob_service.dart';

class ChatList extends StatefulWidget {
  const ChatList({super.key});

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  BannerAd? _bannerAd;
  NativeAd? _nativeAd;
  bool _isAdLoaded = false;

  @override
  void initState() {
    super.initState();
    _createBannerAd();
    // _createNativeAd();
  }

  void _createBannerAd() {
    _bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: AdMobService.bannerAdUnitId!,
      listener: AdMobService.createBannerListener(() {
        setState(() {
          _isAdLoaded = true;
        });
      }),
      request: const AdRequest(),
    )..load();
  }

  // void _createNativeAd() {
  //   _nativeAd = NativeAd(
  //     adUnitId: AdMobService.nativeAdUnitId!,
  //     factoryId: 'listTile',
  //     listener: AdMobService.createNativeAdListener(() {
  //       setState(() {
  //         _isAdLoaded = true;
  //       });
  //     }),
  //     request: const AdRequest(),
  //     nativeTemplateStyle: NativeTemplateStyle(
  //       templateType: TemplateType.small,
  //       mainBackgroundColor: Colors.white,
  //     ),
  //   )..load();
  // }

  @override
  void dispose() {
    _nativeAd?.dispose();
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatBlocState>(
      builder: (context, state) {
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: AppBar(
              elevation: 0,
              backgroundColor: GlobalVariables.backgroundColor,
              centerTitle: false,
              title: const Text(
                'Chats',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          body: Column(
            children: [
              DefaultTabController(
                length: 2,
                child: Expanded(
                  child: Column(
                    children: [
                      const TabBar(
                        indicatorColor: GlobalVariables.secondaryColor,
                        indicatorWeight: 4,
                        labelColor: GlobalVariables.secondaryColor,
                        unselectedLabelColor: Colors.grey,
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                        tabs: [
                          Tab(
                            text: 'By User',
                          ),
                          Tab(
                            text: 'By Product',
                          ),
                        ],
                      ),
                      _isAdLoaded
                          ? Container(
                              margin: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: SizedBox(
                                  height: _bannerAd!.size.height.toDouble(),
                                  child: AdWidget(ad: _bannerAd!),
                                ),
                              ),
                            )
                          : Container(),
                      Expanded(
                        child: TabBarView(
                          children: [
                            // User Tab
                            ContactsList(
                              list: state.chatRooms,
                              sort: 'user',
                            ),
                            // Product Tab
                            ContactsList(
                              list: state.chatRooms,
                              sort: 'product',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              )
            ],
          ),
        );
      },
    );
  }
}
