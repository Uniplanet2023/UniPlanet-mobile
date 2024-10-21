import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:uniplanet/config/statemanager_provider.dart';
import 'package:uniplanet/core/ads/ads_repository_impl.dart';
import 'package:uniplanet/features/account/presentation/blocs/account/account_bloc.dart';
import 'package:uniplanet/features/chat/presentation/blocs/chat/chat_bloc.dart';
import 'package:uniplanet/models/product.dart';

Widget chatButton(ChatBlocState state, Product product, BuildContext context,
    int availableFreeItems) {
  return Container(
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [
          Colors.purple,
          Colors.blue,
        ],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ),
      borderRadius: BorderRadius.circular(8.0), // Rounded corners
    ),
    child: TextButton(
      onPressed: () {
        if (product.type == 'Free Item' || product.price == 0) {
          AdsRepositoryImpl().showRewardedAd();
        }
        getIt<ChatBloc>().add(CreateChatRoomEvent(
          buyer: getIt<AccountBloc>().state.account.user,
          seller: product.seller,
          productId: product.id,
          productName: product.name,
          productType: product.type,
          type: 'product',
        ));
      },
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
        backgroundColor: Colors.transparent, // Transparent to show gradient
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      child: state is CreatingChatRoomState
          ? const CircularProgressIndicator()
          : product.type == 'Free Item' || product.price == 0
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const FaIcon(
                      FontAwesomeIcons.gift,
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Get Free Item! ($availableFreeItems)',
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                )
              : const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FaIcon(
                      FontAwesomeIcons.message,
                      color: Colors.white,
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Chat',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
    ),
  );
}
