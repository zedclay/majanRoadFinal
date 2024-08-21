import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:majan_road/localization/app_localization.dart';
import 'package:majan_road/localization/local_notifier.dart';
import 'package:majan_road/widgets/themeNotiffier.dart';
import 'package:provider/provider.dart';

import 'splash_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeNotifier()),
        ChangeNotifierProvider(create: (_) => LocaleNotifier()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeNotifier, LocaleNotifier>(
      builder: (context, theme, localeNotifier, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          locale: localeNotifier.locale,
          supportedLocales: [
            Locale('en', ''),
            Locale('ar', ''),
          ],
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          theme: theme.isDarkMode ? ThemeData.dark() : ThemeData.light(),
          home: SplashScreen(
            toggleDarkMode: theme.toggleTheme,
            changeLanguage: localeNotifier.changeLanguage,
            showOnboarding: false,
          ),
        );
      },
    );
  }
}
