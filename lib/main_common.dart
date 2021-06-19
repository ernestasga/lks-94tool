import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lks94tool/constants.dart';
import 'package:lks94tool/flavor_config.dart';
import 'package:lks94tool/route/route_generator.dart';
import 'package:lks94tool/translations/codegen_loader.g.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

var flavorConfigProvider;
BannerAd bannerAd = BannerAd(
    adUnitId: GAD_BANNER_ID,
    size: AdSize.banner,
    request: AdRequest(),
    listener: BannerAdListener(onAdFailedToLoad: (ad, error) => print('Ad error: $error'),),
    
  );
void mainCommon(FlavorConfig flavorConfig) async {
  flavorConfigProvider = StateProvider((ref) => flavorConfig);
  WidgetsFlutterBinding.ensureInitialized();

  await EasyLocalization.ensureInitialized();
  runApp(ProviderScope(

      child: EasyLocalization(
          path: 'assets/translations',
          supportedLocales: [Locale('en'), Locale('lt')],
          fallbackLocale: Locale('en'),
          assetLoader: CodegenLoader(),
          child: MyApp())));

}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState(){
    super.initState();
    if(context.read(flavorConfigProvider).state.isAdsEnabled){
      MobileAds.instance.initialize();
      bannerAd.load();    
    }

  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
            child: MaterialApp(
            title: context.read(flavorConfigProvider).state.name,
            theme: context.read(flavorConfigProvider).state.theme,
            initialRoute: '/',
            onGenerateRoute: RouteGenerator.generateRoute,
            supportedLocales: context.supportedLocales,
            localizationsDelegates: context.localizationDelegates,
            locale: context.locale,
          ),
        ),
        if(context.read(flavorConfigProvider).state.isAdsEnabled)
          Container(height: 50, child: AdWidget(ad: bannerAd))
      ],
    );
  }
}
