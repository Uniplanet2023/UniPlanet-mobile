import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniplanet/bloc/admin/admin_bloc.dart';
import 'package:uniplanet/features/account/screens/advertiser_detail.dart';
import 'package:uniplanet/models/advertiser.dart';

class AdvertiserControlPanelScreen extends StatefulWidget {
  const AdvertiserControlPanelScreen({super.key});

  @override
  State<AdvertiserControlPanelScreen> createState() =>
      _AdvertiserControlPanelScreenState();
}

class _AdvertiserControlPanelScreenState
    extends State<AdvertiserControlPanelScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_loadMoreAdvertiser);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _loadMoreAdvertiser() {
    if (_scrollController.position.atEdge) {}
  }

  @override
  Widget build(BuildContext context) {
    List<Advertiser> advertiserList =
        context.read<AdminBloc>().state.advertiserList;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Advertiser Control Panel'),
      ),
      body: BlocBuilder<AdminBloc, AdminState>(
        builder: (context, state) {
          if (state is GotAdvertiserListState ||
              state is GotMoreAdvertiserListState) {
            return SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: advertiserList
                    .map((advertiser) => ListTile(
                          title: Text(advertiser.account.user.name),
                          subtitle: Text(advertiser.account.user.email),
                          trailing: IconButton(
                            icon: const Icon(Icons.chevron_right_rounded),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      AdvertiserDetail(advertiser: advertiser),
                                ),
                              );
                            },
                          ),
                        ))
                    .toList(),
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
