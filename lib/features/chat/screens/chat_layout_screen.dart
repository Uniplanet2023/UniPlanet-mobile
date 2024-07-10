import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:uniplanet/bloc/chat/chat_bloc.dart';
import 'package:uniplanet/features/ads/presentation/bloc/ads_bloc.dart';
import 'package:uniplanet/features/chat/widgets/contacts_list.dart';

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
    context.read<AdsBloc>().add(LoadBannerAdEvent(() {
      setState(() {
        _isAdLoaded = true;
      });
    }));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatBlocState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: AppBar(
              elevation: 0,
              backgroundColor: Theme.of(context).colorScheme.surface,
              centerTitle: false,
              title: Text(
                'Chats',
                style: TextStyle(
                  fontSize: 20,
                  color: Theme.of(context).colorScheme.tertiary,
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
                      TabBar(
                        indicatorColor: Theme.of(context).colorScheme.primary,
                        indicatorWeight: 4,
                        labelColor: Theme.of(context).colorScheme.primary,
                        unselectedLabelColor:
                            Theme.of(context).colorScheme.tertiaryContainer,
                        labelStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                        tabs: const [
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
