import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'settings/settings_controller.dart';
import 'settings/app_router.dart';

/// The Widget that configures your application.
class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.settingsController,
  });

  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: settingsController,
      builder: (
        BuildContext context,
        Widget? child,
      ) {
        return MaterialApp.router(
          routerConfig: router,
          restorationScopeId: 'app',
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''),
          ],
          onGenerateTitle: (BuildContext context) =>
              AppLocalizations.of(context)!.appTitle,
          theme: AppTheme().lightTheme,
          darkTheme: AppTheme().darkTheme,
          themeMode: ThemeMode.light,
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}

class AppColors {
  static const MaterialColor lightGreen = MaterialColor(
    0xFF00C853, // Primary color value
    <int, Color>{
      50: Color(0xFFF1F8E9),
      100: Color(0xFFDCEDC8),
      200: Color(0xFFC5E1A5),
      300: Color(0xFFAED581),
      400: Color(0xFF9CCC65),
      500: Color(0xFF8BC34A),
      600: Color(0xFF7CB342),
      700: Color(0xFF689F38),
      800: Color(0xFF558B2F),
      900: Color(0xFF33691E),
    },
  );

  static const MaterialColor darkGreen = MaterialColor(
    0xFF00C853, // Primary color value
    <int, Color>{
      50: Color(0xFF1B5E20),
      100: Color(0xFF22492D),
      200: Color(0xFF1E3A23),
      300: Color(0xFF15291A),
      400: Color(0xFF0E1F15),
      500: Color(0xFF0A140F),
      600: Color(0xFF080E0A),
      700: Color(0xFF050A08),
      800: Color(0xFF020505),
      900: Color(0xFF000000),
    },
  );
}

class AppTheme {
  ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        primarySwatch: AppColors.lightGreen,
      );

  ThemeData get darkTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        primarySwatch: AppColors.darkGreen,
      );
}
