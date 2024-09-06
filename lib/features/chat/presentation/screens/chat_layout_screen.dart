import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniplanet/features/chat/presentation/blocs/chat/chat_bloc.dart';
import 'package:uniplanet/features/chat/presentation/widgets/banner.dart';
import 'package:uniplanet/features/chat/presentation/widgets/contacts_list.dart';

class ChatListPage extends StatefulWidget {
  final ScrollController controller; // Accept ScrollController
  const ChatListPage({super.key, required this.controller});

  @override
  State<ChatListPage> createState() => _ChatListState();
}

class _ChatListState extends State<ChatListPage> {
  // BannerAd? _bannerAd;
  // bool _isAdLoaded = false;

  @override
  void initState() {
    super.initState();
    // _bannerAd = AdsRepositoryImpl().createBannerAd(() {
    //   setState(() {
    //     _isAdLoaded = true;
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatBlocState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(0),
            child: AppBar(
              elevation: 0,
              backgroundColor: Theme.of(context).colorScheme.surface,
              centerTitle: false,
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
                      const AutoChangingBanner(),
                      Expanded(
                        child: TabBarView(
                          children: [
                            // User Tab
                            ContactsList(
                              list: state.chatRooms,
                              sort: 'user',
                              controller: widget
                                  .controller, // Pass the ScrollController
                            ),
                            // Product Tab
                            ContactsList(
                              list: state.chatRooms,
                              sort: 'product',
                              controller: widget
                                  .controller, // Pass the ScrollController
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
