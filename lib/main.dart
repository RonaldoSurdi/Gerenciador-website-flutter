import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hwscontrol/core/theme/colors_theme.dart';
import 'package:hwscontrol/pages/modules/initialize.dart';
import 'package:hwscontrol/core/theme/custom_animation.dart';

final ThemeData defaultTheme = ThemeData(
  primaryColor: ColorsTheme.gainsboro,
  iconTheme: const IconThemeData(
    color: ColorsTheme.gainsboro,
    opacity: 1,
    size: 33,
  ),
  bottomAppBarTheme: const BottomAppBarTheme(
    color: ColorsTheme.gainsboro,
  ),
  secondaryHeaderColor: ColorsTheme.greenDefault,
  appBarTheme: AppBarTheme(
    systemOverlayStyle: const SystemUiOverlayStyle(
      statusBarBrightness: Brightness.light,
    ),
    color: ColorsTheme.gainsboro,
    centerTitle: true,
    titleTextStyle: const TextStyle(
      color: Colors.white70,
      fontSize: 33.0,
      fontFamily: 'WorkSansMedium',
    ),
    backgroundColor: ColorsTheme.greyDefault,
  ),
  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: Colors.white,
    selectionColor: Colors.white,
    selectionHandleColor: Colors.white,
  ),
  scaffoldBackgroundColor: ColorsTheme.greyBackground,
);

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
      title: 'Painel de controle',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      //supportedLocales: const [Locale('pt', 'BR')],
      home: const Initialize(title: 'Loading...'),
      builder: EasyLoading.init(),
    );
  }
}
