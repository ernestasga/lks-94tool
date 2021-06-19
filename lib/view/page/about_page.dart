import 'package:flutter/material.dart';
import 'package:launch_review/launch_review.dart';
import 'package:lks94tool/constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:lks94tool/translations/locale_keys.g.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lks94tool/main_common.dart';
import 'package:package_info/package_info.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String version = context.read(flavorConfigProvider).state.version;
    String packageName = '';
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      packageName = packageInfo.packageName;
    });
    print(packageName);
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(LocaleKeys.about.tr())),
      ),
      body: Container(
          child: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(50),
            child: Center(
                child: Text(
              APP_NAME,
              style: TextStyle(fontSize: 30),
            )),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 80),
            child: Text(LocaleKeys.app_description.tr()),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Divider(thickness: 3),
          ),
          Center(
              child: Text(LocaleKeys.version_x.tr(args: [version]),
                  style: TextStyle(fontSize: 20))),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Divider(thickness: 3),
          ),
          Center(child: Text(APP_AUTHOR, style: TextStyle(fontSize: 20))),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Divider(thickness: 3),
          ),
          Center(child: Text(APP_AUTHOR_EMAIL, style: TextStyle(fontSize: 20))),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Divider(thickness: 3),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: ElevatedButton(
                onPressed: () {
                  LaunchReview.launch(
                      androidAppId: packageName, writeReview: true);
                },
                child: Text(LocaleKeys.write_review.tr())),
          ),
          if (context.read(flavorConfigProvider).state.flavor == 'free')
            Padding(
              padding: const EdgeInsets.all(10),
              child: ElevatedButton(
                onPressed: () {
                  LaunchReview.launch(androidAppId: APP_FULL_VERSION_URL);
                },
                child: Text(LocaleKeys.get_full_version.tr()),
                style: ElevatedButton.styleFrom(primary: Colors.green),
              ),
            ),
        ],
      )),
    );
  }
}
