import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'l10n/app_localizations.dart';
import 'routes.dart';
import 'theme/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // await dotenv.load(fileName: ".env");

  // await Supabase.initialize(
  //   url: dotenv.env['SUPABASE_URL']!,
  //   anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  // );
  runApp(LankaConnectApp());
}

class LankaConnectApp extends StatelessWidget {
  const LankaConnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, screenType) => MaterialApp.router(
        title: ' App',
        theme: AppTheme.lightTheme(),
        localizationsDelegates: [
          ...AppLocalizations.localizationsDelegates,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        builder: (context, child) {
          return child!;
        },
        themeMode: ThemeMode.light,
        routerConfig: router,
      ),
    );
  }
}
