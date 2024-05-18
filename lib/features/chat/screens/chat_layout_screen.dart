import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:uniplanet/bloc/chat/chat_bloc.dart';
import 'package:uniplanet/constants/global_variables.dart';
import 'package:uniplanet/features/chat/widgets/contacts_list.dart';
import 'package:uniplanet/network/ads/ad_mob_service.dart';

class ChatList extends StatefulWidget {
  const ChatList({super.key});

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  BannerAd? _bannerAd;
  bool _isAdLoaded = false;
  @override
  void initState() {
    super.initState();
    _createBannerAd();
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

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: BlocBuilder<ChatBloc, ChatBlocState>(
        builder: (context, state) {
          return Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(50),
              child: AppBar(
                elevation: 0,
                backgroundColor: GlobalVariables.backgroundColor,
                centerTitle: false,
                title: Text(
                  'Chats',
                  style: TextStyle(
                    fontStyle: GoogleFonts.roboto().fontStyle,
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            body: Column(
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
          );
        },
      ),
    );
  }
}
