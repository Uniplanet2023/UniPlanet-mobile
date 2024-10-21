import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:uniplanet/features/account/presentation/blocs/account/account_bloc.dart';
import 'package:uniplanet/features/account/presentation/blocs/admin/admin_bloc.dart';
import 'package:uniplanet/features/account/presentation/blocs/advertiser/advertiser_bloc.dart';
import 'package:uniplanet/features/advertiser/presentation/blocs/advertisement/advertisement_bloc.dart';
import 'package:uniplanet/features/advertiser/presentation/blocs/mail/mail_bloc.dart';
import 'package:uniplanet/features/category/presentation/blocs/category/category_bloc.dart';
import 'package:uniplanet/features/category/presentation/blocs/free_product/free_product_bloc.dart';
import 'package:uniplanet/features/chat/presentation/blocs/banner/banner_bloc.dart';
import 'package:uniplanet/features/home/presentation/blocs/advertisement/advertisement_bloc.dart';
import 'package:uniplanet/features/housing/presentation/housing/housing_bloc.dart';
import 'package:uniplanet/features/chat/presentation/blocs/chat/chat_bloc.dart';
import 'package:uniplanet/features/chat/presentation/blocs/message/message_bloc.dart';
import 'package:uniplanet/features/chat/presentation/blocs/status/status_bloc.dart';
import 'package:uniplanet/features/chat/presentation/blocs/typing/typing_bloc.dart';
import 'package:uniplanet/features/chat/presentation/get_product/get_product_bloc.dart';
import 'package:uniplanet/features/category/presentation/blocs/hot_product/hot_product_bloc.dart';
import 'package:uniplanet/features/auth/presention/blocs/auth/auth_bloc.dart';
import 'package:uniplanet/features/auth/presention/blocs/like/like_bloc.dart';
import 'package:uniplanet/features/job/presentation/blocs/job_post/job_post_bloc.dart';
import 'package:uniplanet/features/offer/presentation/blocs/offer/offer_bloc.dart';
import 'package:uniplanet/features/offer/presentation/blocs/qr_code_scan/qr_code_scan_bloc.dart';
import 'package:uniplanet/features/upload/presentation/blocs/job/job_bloc.dart';
import 'package:uniplanet/features/upload/presentation/blocs/offer/offer_bloc.dart';
import 'package:uniplanet/features/upload/presentation/blocs/product/product_bloc.dart';
import 'package:uniplanet/features/report/presentation/bloc/report_bloc.dart';
import 'package:uniplanet/features/account/presentation/blocs/sale_product/sale_product_bloc.dart';
import 'package:uniplanet/features/search/presentation/blocs/search_history/search_history_bloc.dart';
import 'package:uniplanet/features/product_details/presentation/blocs/seller_sale_product/seller_sale_product_bloc.dart';
import 'package:uniplanet/features/product_details/presentation/blocs/seller_sold_product/sold_product_bloc.dart';
import 'package:uniplanet/features/account/presentation/blocs/sold_product/sold_product_bloc.dart';
import 'package:uniplanet/features/auth/presention/blocs/theme/theme_cubit.dart';
import 'package:uniplanet/features/category/presentation/blocs/buying/wanted_product_bloc.dart';
import 'package:uniplanet/features/search/presentation/blocs/search_product/search_product_bloc.dart';
import 'package:uniplanet/features/upload/presentation/blocs/housing/housing_bloc.dart';
import 'package:uniplanet/features/upload/presentation/blocs/payment/payment_bloc.dart';
import 'package:uniplanet/main.dart';

final getIt = GetIt.instance;

class StateManagerProvider extends StatelessWidget {
  const StateManagerProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<GetHousingBloc>()),
        BlocProvider(create: (context) => getIt<HousingBloc>()),
        BlocProvider(create: (context) => getIt<AuthBloc>()),
        BlocProvider(create: (context) => getIt<ProductBloc>()),
        BlocProvider(create: (context) => getIt<CategoryBloc>()),
        BlocProvider(create: (context) => getIt<HotProductBloc>()),
        BlocProvider(create: (context) => getIt<SearchProductBloc>()),
        BlocProvider(create: (context) => getIt<AccountBloc>()),
        BlocProvider(create: (context) => getIt<ChatBloc>()),
        BlocProvider(create: (context) => getIt<MessageBloc>()),
        BlocProvider(create: (context) => getIt<StatusBloc>()),
        BlocProvider(create: (context) => getIt<TypingBloc>()),
        BlocProvider(create: (context) => getIt<LikeBloc>()),
        BlocProvider(create: (context) => getIt<SearchHistoryBloc>()),
        BlocProvider(create: (context) => getIt<OnSaleProductBloc>()),
        BlocProvider(create: (context) => getIt<SoldProductBloc>()),
        BlocProvider(create: (context) => getIt<SellerSaleProductBloc>()),
        BlocProvider(create: (context) => getIt<SellerSoldProductBloc>()),
        BlocProvider(create: (context) => getIt<GetProductBloc>()),
        BlocProvider(create: (context) => getIt<FreeProductBloc>()),
        BlocProvider(create: (context) => getIt<WantedProductBloc>()),
        BlocProvider(create: (context) => getIt<ReportBloc>()),
        BlocProvider(create: (context) => getIt<AdvertiserBloc>()),
        BlocProvider(create: (context) => getIt<AdminBloc>()),
        BlocProvider(create: (context) => getIt<ThemeCubit>()),
        BlocProvider(create: (context) => getIt<BannerBloc>()),
        BlocProvider(create: (context) => getIt<PaymentBloc>()),
        BlocProvider(create: (context) => getIt<AdvertisementBloc>()),
        BlocProvider(create: (context) => getIt<MyAdvertisementBloc>()),
        BlocProvider(create: (context) => getIt<MailBloc>()),
        BlocProvider(create: (context) => getIt<JobBloc>()),
        BlocProvider(create: (context) => getIt<JobPostBloc>()),
        BlocProvider(create: (context) => getIt<OfferBloc>()),
        BlocProvider(create: (context) => getIt<GetOfferBloc>()),
        BlocProvider(create: (context) => getIt<QrCodeScanBloc>()),
      ],
      child: const MyApp(),
    );
  }
}
