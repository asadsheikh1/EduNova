import 'package:edu_nova/blocs/lang/language_bloc.dart';
import 'package:edu_nova/constants/component.dart';
import 'package:edu_nova/routes/routes.dart';
import 'package:edu_nova/screens/onboard_screen.dart';
import 'package:edu_nova/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:edu_nova/themes/cubit/theme_cubit.dart';
import 'package:edu_nova/themes/theme_style.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  initScreen = prefs.getInt("initScreen");
  await prefs.setInt("initScreen", 1);

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ThemeCubit()),
        BlocProvider(create: (context) => LanguageBloc()),
      ],
      child: const MyApp(),
    ),
  );
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeCubit theme = BlocProvider.of<ThemeCubit>(context, listen: true);

    return BlocProvider(
      create: (context) => LanguageBloc()..add(GetLanguage()),
      child: BlocBuilder<LanguageBloc, LanguageState>(
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'EduNova',
            locale: state.selectedLanguage.value,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            theme: theme.isDark ? ThemeStyle.darkTheme : ThemeStyle.lightTheme,
            initialRoute: initScreen == 0 || initScreen == null ? OnBoardScreen.routeName : SplashScreen.routeName,
            routes: PageRoutes().routes(),
          );
        },
      ),
    );
  }
}
