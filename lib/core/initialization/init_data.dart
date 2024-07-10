import 'package:flutter/material.dart';
import 'package:uniplanet/bloc/admin/admin_bloc.dart';
import 'package:uniplanet/bloc/advertiser/advertiser_bloc.dart';
import 'package:uniplanet/bloc/free_product/free_product_bloc.dart';
import 'package:uniplanet/bloc/hot_product/hot_product_bloc.dart';
import 'package:uniplanet/bloc/index.dart';
import 'package:uniplanet/bloc/sale_product/sale_product_bloc.dart';
import 'package:uniplanet/bloc/sold_product/sold_product_bloc.dart';
import 'package:uniplanet/bloc/wanted_product/wanted_product_bloc.dart';
import 'package:uniplanet/core/utils/utils.dart';
import 'package:uniplanet/core/initialization/init.dart';
import 'package:uniplanet/core/network/notification/remote_notification_controller.dart';
import 'package:uniplanet/core/network/repository/auth_repository/auth_repo.dart';
import 'package:uniplanet/core/network/socket/socket_channel.dart';

Future<void> initData() async {
  await NotificationController.initializeRemoteNotifications(debug: true);

  Initialization.socketService = SocketService(AuthRepository.userId!);
  Initialization.socketService.connect();
  BuildContext context = SnackbarGlobal.key.currentContext!;

  if (!context.mounted) return;
  context.read<ProductBloc>().add(const LoadProductEvent());
  context.read<AccountBloc>().add(const GetAccountInfoEvent());
  context.read<ChatBloc>().add(const LoadChatRoomEvent());
  context.read<LikeBloc>().add(const LoadLikeEvent());
  context.read<WantedProductBloc>().add(const LoadWantedProductEvent());
  context
      .read<FreeProductBloc>()
      .add(const LoadFreeProductEvent(category: "Free Products"));
  context
      .read<SoldProductBloc>()
      .add(LoadSoldProductEvent(userId: AuthRepository.userId!));
  context
      .read<OnSaleProductBloc>()
      .add(LoadOnSaleProductEvent(userId: AuthRepository.userId!));
  context.read<HotProductBloc>().add(const LoadHotProductsEvent());

  if (AuthRepository.type == 'advertiser' || AuthRepository.type == 'admin') {
    context.read<AdvertiserBloc>().add(const GetAdvertiserInfoEvent());
    context.read<AdvertiserBloc>().add(const GetAdStatisticEvent());
    context.read<AdvertiserBloc>().add(const GetUserInteractionEvent());
  }
  if (AuthRepository.type == 'admin') {
    context.read<AdminBloc>().add(const GetAdvertiserListEvent());
  }
}
