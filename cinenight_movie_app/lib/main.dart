import 'package:cinenight_movie_app/core/theme/app_text_size.dart';
import 'package:cinenight_movie_app/provider/text_size_notifier.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ui/screens/splash_screen.dart';
import 'provider/movie_provider.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  //Load file env trước khi chạy app
  await dotenv.load(fileName: ".env");

  final prefs = await SharedPreferences.getInstance();
  final initialSize = TextSizeNotifier.loadFromPrefs(prefs);

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('vi')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      startLocale: const Locale('en'),
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => MovieProvider()),
          ChangeNotifierProvider(
            create: (_) => TextSizeNotifier(initialSize, prefs),
          ),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of my application.
  @override
  Widget build(BuildContext context) {
    return Consumer<TextSizeNotifier>(
      builder: (context, textSizeNotifier, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          builder: (context, child) {
            final scale = textSizeNotifier.size.scaleFactor;
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(scale)),
              child: child!,
            );
          },
          home: const SplashScreen(),
        );
      },
    );
  }
}
