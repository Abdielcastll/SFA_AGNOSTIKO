import 'dart:async';

import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:pwa_sales2go_flutter/helper/object_box.dart';
import 'package:pwa_sales2go_flutter/l10n/l10n.dart';
import 'package:pwa_sales2go_flutter/src/models/products_model.dart';
import 'package:pwa_sales2go_flutter/src/models/user_model.dart';
import 'package:pwa_sales2go_flutter/src/pages/amount_input/amount_input.dart';
import 'package:pwa_sales2go_flutter/src/pages/auth/login/email_page.dart';
import 'package:pwa_sales2go_flutter/src/pages/auth/wrapper/promo_video_player.dart';
import 'package:pwa_sales2go_flutter/src/pages/auth/wrapper/wrapper.dart';
import 'package:pwa_sales2go_flutter/src/pages/card_input/card_input.dart';
import 'package:pwa_sales2go_flutter/src/pages/catalogue/catalogue_page.dart';
import 'package:pwa_sales2go_flutter/src/pages/clients/clients_page.dart';
import 'package:pwa_sales2go_flutter/src/pages/cvv_input/cvv_input.dart';
import 'package:pwa_sales2go_flutter/src/pages/diary/diary_tabs.dart';
import 'package:pwa_sales2go_flutter/src/pages/emv_transaction_info/emv_transaction_info.dart';
import 'package:pwa_sales2go_flutter/src/pages/exp_date_input/exp_date_input.dart';
import 'package:pwa_sales2go_flutter/src/pages/navigation/navigation.dart';
import 'package:pwa_sales2go_flutter/src/pages/notifications/notifications_page.dart';
import 'package:pwa_sales2go_flutter/src/pages/pan_input/pan_input.dart';
import 'package:pwa_sales2go_flutter/src/pages/pin_input/pin_input.dart';
import 'package:pwa_sales2go_flutter/src/pages/place_order/order_page.dart';
import 'package:pwa_sales2go_flutter/src/pages/place_order/place_oder_page.dart';
import 'package:pwa_sales2go_flutter/src/pages/profile/profile_page.dart';
import 'package:pwa_sales2go_flutter/src/pages/splash_screen/splash_screen.dart';
import 'package:pwa_sales2go_flutter/src/provider/counter_limit_firestore.dart';
import 'package:pwa_sales2go_flutter/src/provider/currency_provider.dart';
import 'package:pwa_sales2go_flutter/src/provider/locale_provider.dart';
import 'package:pwa_sales2go_flutter/src/provider/order_provider.dart';
import 'package:pwa_sales2go_flutter/src/provider/remote_config_provider.dart';
import 'package:pwa_sales2go_flutter/src/services/auth.dart';
import 'package:pwa_sales2go_flutter/src/services/firebase_collections.dart';
import 'package:pwa_sales2go_flutter/src/utils/determinePosition.dart';
import 'package:pwa_sales2go_flutter/src/pages/auth/login/login_page.dart';
import 'package:flutter/material.dart';
import 'package:pwa_sales2go_flutter/src/utils/multitenant-config.dart';
import 'package:pwa_sales2go_flutter/src/utils/notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pwa_sales2go_flutter/src/global/global.dart';
import 'package:pwa_sales2go_flutter/src/theme/theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

late ObjectBox objectBox;

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  objectBox = await ObjectBox.init();

  await dotenv.load();

  sharedPreferences = await SharedPreferences.getInstance();
  determinePosition();
  String? mail = sharedPreferences!.getString("tenantEmail");
  print("tennantMail: $mail ");
  if (mail == null || mail == '') {
    MultiProvider(
        providers: [
          ChangeNotifierProvider<ThemeProvider>(
            create: (context) => ThemeProvider(),
          ),
        ],
        child: const EmailPage(),
      ),
  } else {
    runApp(const SfaAgnostiko());
  }
}

class SfaAgnostiko extends StatelessWidget {
  const SfaAgnostiko({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    return FutureBuilder<bool>(
      future: multitenantConfig.initialize(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            supportedLocales: L10n.all,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            title: 'Field Sales',
            theme: myThemeBase,
            home: const SplashScreenView(redirect: false),
          );
        }
        return StreamProvider<UserModel?>.value(
          value: AuthService().user,
          initialData: null,
          child: MultiProvider(
            providers: [
              ChangeNotifierProvider<LocaleProvider>(
                create: (context) => LocaleProvider(),
              ),
              ChangeNotifierProvider<NotificationService>(
                create: (context) => NotificationService(),
              ),
              ChangeNotifierProvider<CurrencyProvider>(
                create: (context) => CurrencyProvider(),
              ),
              ChangeNotifierProvider<OrderProvider>(
                create: (context) => OrderProvider(),
              ),
              ChangeNotifierProvider<CounterLimitFirestore>(
                create: (context) => CounterLimitFirestore(),
              ),
              ChangeNotifierProvider<ThemeProvider>(
                create: (context) => ThemeProvider(),
              ),
            ],
            builder: (context, child) {
              final productsLimit =
                  Provider.of<CounterLimitFirestore>(context).getProductsLimit;

              return StreamProvider<List<Products>?>.value(
                value: productsLimit == 0
                    ? productsCollection
                        .orderBy('codigo')
                        .snapshots()
                        .map(productsListFromSnapshot)
                    : productsCollection
                        .orderBy('codigo')
                        .limit(productsLimit)
                        .snapshots()
                        .map(productsListFromSnapshot),
                initialData: const [],
                catchError: (context, error) {
                  print(error);
                  print('PROVIDER PRODUCT ERROR');
                  return;
                },
                child: const LifecycleWatcher(),
              );
            },
          ),
        );
      },
    );
  }
}

class LifecycleWatcher extends StatefulWidget {
  const LifecycleWatcher({super.key});

  @override
  State<LifecycleWatcher> createState() => _LifecycleWatcherState();
}

class _LifecycleWatcherState extends State<LifecycleWatcher>
    with WidgetsBindingObserver {
  Timer? _inactivityTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      multitenantConfig.getColorsApp(context);
    });
    WidgetsBinding.instance.addObserver(this);
    Timer(const Duration(minutes: 1), () {
      _startInactivityTimer();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _inactivityTimer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _startInactivityTimer();
    } else if (state == AppLifecycleState.paused) {
      _cancelInactivityTimer();
    }
  }

  void _startInactivityTimer() {
    print("start timer");
    _inactivityTimer?.cancel();
    _inactivityTimer = Timer(const Duration(minutes: 1), () {
      print('timer complete');
      print('show video');
      if (globalRemoteConfig.promoVideoDisponible!) {
        navigatorKey.currentState?.pushNamed('promo');
      }
    });
  }

  void _cancelInactivityTimer() {
    print('cancel timer');
    if (_inactivityTimer?.isActive ?? false) {
      _inactivityTimer!.cancel();
    }
  }

  void _resetInactivityTimer() {
    print('reset timer');
    _startInactivityTimer();
  }

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    final themeProvider =
        Provider.of<ThemeProvider>(context, listen: true); // Get theme colors

    return GestureDetector(
      onTap: () {
        _resetInactivityTimer();
      },
      child: MaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        locale: localeProvider.locale,
        supportedLocales: L10n.all,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        title: 'Field Sales',
        theme: themeProvider.myTheme,
        initialRoute: SplashScreenView.route,
        routes: {
          SplashScreenView.route: (BuildContext context) =>
              const SplashScreenView(),
          PinInputView.route: (context) => PinInputView(),
          PanInputView.route: (context) => const PanInputView(),
          ExpDateInputView.route: (context) => ExpDateInputView(),
          EmvTransactionInfoView.route: (context) =>
              const EmvTransactionInfoView(),
          CvvInputView.route: (context) => const CvvInputView(),
          CardInputView.route: (context) => CardInputView(),
          AmountInputView.route: (context) => AmountInputView(),
          'wrapper': (BuildContext context) => const Wrapper(),
          'login': (BuildContext context) => const LoginPage(),
          'navigation': (BuildContext context) => const NavigationPages(),
          'notifications': (BuildContext context) => const NotificationsPage(),
          'place_order': (BuildContext context) => const PlaceOrderPage(),
          'catalogue': (BuildContext context) => const CataloguePage(),
          'clients': (BuildContext context) => const ClientsPage(),
          'profile': (BuildContext context) => const ProfilePage(),
          DiaryTabs.route: (BuildContext context) => const DiaryTabs(),
          'order': (BuildContext context) => const OrderPage(),
          'promo': (BuildContext context) => const PromoVideoPlayer(),
        },
      ),
    );
  }
}
