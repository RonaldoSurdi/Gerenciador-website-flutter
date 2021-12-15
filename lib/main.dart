import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hwscontrol/core/theme/colors_theme.dart';
import 'package:hwscontrol/pages/modules/login_page.dart';

final ThemeData defaultTheme = ThemeData(
  primaryColor: ColorsTheme.greyDefault,
  secondaryHeaderColor: ColorsTheme.greenDefault,
  appBarTheme: const AppBarTheme(
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarBrightness: Brightness.light,
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

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
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
      home: const LoginPage(),
    );
  }
}
