import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hwscontrol/core/theme/default_theme.dart';
import 'package:hwscontrol/views/initialize.dart';
import 'package:hwscontrol/core/theme/custom_animation.dart';

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 500)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 60.0
    ..radius = 30
    ..progressColor = Colors.white70
    ..backgroundColor = Colors.white24
    ..indicatorColor = Colors.white70
    ..textColor = Colors.white70
    ..maskColor = Colors.black.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false
    ..customAnimation = CustomAnimation();
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
  configLoading();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      supportedLocales: const [
        Locale('pt', 'BR'),
      ],
      title: 'Painel de controle',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: DefaultClass.lightTheme,
      darkTheme: DefaultClass.darkTheme,
      //theme: defaultTheme,
      //supportedLocales: const [Locale('pt', 'BR')],
      home: const Initialize(title: 'Loading...'),
      builder: EasyLoading.init(),
    );
  }
}
