import 'package:uniplanet/config/statemanager_provider.dart';
import 'package:uniplanet/core/entities/user.dart';
import 'package:uniplanet/features/account/presentation/blocs/account/account_bloc.dart';
import 'package:uniplanet/features/account/presentation/blocs/admin/admin_bloc.dart';
import 'package:uniplanet/features/account/presentation/blocs/advertiser/advertiser_bloc.dart';
import 'package:uniplanet/features/auth/domain/repository/user_repository.dart';
import 'package:uniplanet/features/category/presentation/blocs/free_product/free_product_bloc.dart';
import 'package:uniplanet/features/category/presentation/blocs/hot_product/hot_product_bloc.dart';
import 'package:uniplanet/features/account/presentation/blocs/sale_product/sale_product_bloc.dart';
import 'package:uniplanet/features/account/presentation/blocs/sold_product/sold_product_bloc.dart';
import 'package:uniplanet/features/category/presentation/blocs/buying/wanted_product_bloc.dart';
import 'package:uniplanet/core/initialization/init.dart';
import 'package:uniplanet/core/network/notification/remote_notification_controller.dart';
import 'package:uniplanet/core/network/socket/socket_channel.dart';
import 'package:uniplanet/features/chat/presentation/blocs/chat/chat_bloc.dart';
import 'package:uniplanet/features/auth/presention/blocs/like/like_bloc.dart';
import 'package:uniplanet/features/auth/presention/blocs/product/product_bloc.dart';

Future<void> initData(User user) async {
  await NotificationController.initializeRemoteNotifications(debug: true);

  Initialization.socketService = SocketService(user.id);
  Initialization.socketService.connect();

  getIt<ProductBloc>().add(const LoadProductEvent());
  getIt<AccountBloc>().add(const GetAccountInfoEvent());
  getIt<ChatBloc>().add(const LoadChatRoomEvent());
  getIt<LikeBloc>().add(const LoadLikeEvent());
  getIt<WantedProductBloc>().add(const LoadWantedProductEvent());
  getIt<FreeProductBloc>()
      .add(const LoadFreeProductEvent(category: "Free Products"));
  getIt<SoldProductBloc>().add(LoadSoldProductEvent(userId: user.id));
  getIt<OnSaleProductBloc>().add(LoadOnSaleProductEvent(userId: user.id));
  getIt<HotProductBloc>().add(const LoadHotProductsEvent());

  if (user.type == 'advertiser' || user.type == 'admin') {
    getIt<AdvertiserBloc>().add(const GetAdvertiserInfoEvent());
    getIt<AdvertiserBloc>().add(const GetAdStatisticEvent());
    getIt<AdvertiserBloc>().add(const GetUserInteractionEvent());
  }
  if (user.type == 'admin') {
    getIt<AdminBloc>().add(const GetAdvertiserListEvent());
  }
}
