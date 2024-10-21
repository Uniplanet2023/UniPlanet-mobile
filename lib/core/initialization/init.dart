import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:uniplanet/core/dependency_injection/account_feature/account.dart';
import 'package:uniplanet/core/dependency_injection/account_feature/admin_injection.dart';
import 'package:uniplanet/core/dependency_injection/account_feature/advertiser_injection.dart';
import 'package:uniplanet/core/dependency_injection/advertisement_feature/mail.dart';
import 'package:uniplanet/core/dependency_injection/advertisement_feature/my_adversiement.dart';
import 'package:uniplanet/core/dependency_injection/auth_feature/auth.dart';
import 'package:uniplanet/core/dependency_injection/chat_feature/banner.dart';
import 'package:uniplanet/core/dependency_injection/dependency_injection.dart';
import 'package:uniplanet/core/dependency_injection/home_feature/advertisement.dart';
import 'package:uniplanet/core/dependency_injection/housing_feature/get_housing.dart';
import 'package:uniplanet/core/dependency_injection/job_feature/get_job.dart';
import 'package:uniplanet/core/dependency_injection/offer_feature/offer.dart';
import 'package:uniplanet/core/dependency_injection/offer_feature/qr_code.dart';
import 'package:uniplanet/core/dependency_injection/upload_feature/housing.dart';
import 'package:uniplanet/core/dependency_injection/upload_feature/job.dart';
import 'package:uniplanet/core/dependency_injection/upload_feature/offer.dart';
import 'package:uniplanet/core/dependency_injection/upload_feature/payment.dart';
import 'package:uniplanet/core/helper/dio_helper.dart';
import 'package:uniplanet/config/firebase_options.dart';
import 'package:uniplanet/core/network/notification/local_notification.dart';
import 'package:uniplanet/core/network/notification/remote_notification_controller.dart';
import 'package:uniplanet/core/network/socket/socket_channel.dart';
import 'package:uniplanet/core/local_stoarage/shared_preferences_helper.dart';
import 'package:uniplanet/core/utils/utils.dart';
import 'package:uniplanet/features/common/presentation/widgets/error_screen.dart';
import 'package:uniplanet/purchase_observer.dart';

class Initialization {
  static late SocketService socketService;
  static Future init() async {
    WidgetsFlutterBinding.ensureInitialized();
    // Firebase initialization
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    // Mobile Ads initialization
    MobileAds.instance.initialize();

    // Notification initialization
    await LocalNotificationController.init(debug: true);
    await LocalNotificationController.getInitialNotificationAction();
    await NotificationController.requestFirebaseToken();

    // Dio initialization (API client)
    await DioHelper.instance.init();
    // Shared Preference initialization
    await SharedPreferencesHelper().init();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    await dotenv.load();
    PurchasesObserver().initialize();
    if (dotenv.env['STRIPE_PUBLISHABLE_KEY'] != null) {
      Stripe.publishableKey = dotenv.get('STRIPE_PUBLISHABLE_KEY');
    } else {
      log('Stripe publishable key is not set');
    }

    //setup block
    setup();
    accountSetup();
    advertiserInjectionSetup();
    adminInjectionSetup();
    setupAuth();
    setupHousing();
    initGetHouse();
    bannerInit();
    setupPayment();
    initAdvertisement();
    advertisementSetup();
    setupMail();
    jobSetup();
    jobPostSetup();
    setupOffer();
    getOfferInit();
    initQrScanner();
    ErrorWidget.builder = (FlutterErrorDetails details) {
      bool inDebug = false;
      assert(() {
        inDebug = true;
        return true;
      }());
      if (inDebug) {
        return ErrorWidget(details.exception);
      }
      return const ErrorScreen();
    };
  }
}
