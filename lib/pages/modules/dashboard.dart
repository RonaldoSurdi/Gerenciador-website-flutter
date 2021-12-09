import 'package:flutter/material.dart';
import 'package:hwscontrol/core/storage.dart';
import 'package:hwscontrol/pages/modules/banners.dart';
import 'package:hwscontrol/pages/modules/biography.dart';
import 'package:hwscontrol/pages/login_page.dart';
import 'package:hwscontrol/core/theme/custom_theme.dart';
import 'package:hwscontrol/core/widgets/snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  // desconectar do app
  _logOut() {
    // Disconnect firebase
    _logoutFirebase();

    // Deletar token de acesso
    DeleteAll().deleteAllTokens();

    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginPage(),
        ),
        (route) => false);
  }

  _logoutFirebase() {
    FirebaseAuth auth = FirebaseAuth.instance;

    auth.signOut().then((value) {
      // print(firebaseUser);
      // String uid = firebaseUser.user!.uid;
      CustomSnackBar(context, const Text('Desconectado'));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (builder) => const LoginPage(),
        ),
      );
    }).catchError((error) {
      setState(() {
        CustomSnackBar(
            context,
            const Text(
                'Erro ao autenticar usuário, verifique e-mail e senha e tente novamente!'),
            backgroundColor: Colors.red);
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFF666666),
      appBar: AppBar(
        title: const Text('Painel de controle'),
        backgroundColor: Colors.black38,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add_alert),
            tooltip: 'Show Snackbar',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('This is a snackbar')));
            },
          ),
          IconButton(
            icon: const Icon(Icons.navigate_next),
            tooltip: 'Go to the next page',
            onPressed: () {
              Navigator.push(context, MaterialPageRoute<void>(
                builder: (BuildContext context) {
                  return Scaffold(
                    appBar: AppBar(
                      title: const Text('Next page'),
                    ),
                    body: const Center(
                      child: Text(
                        'This is the next page',
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                  );
                },
              ));
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: <Color>[
                      CustomTheme.loginGradientStart,
                      CustomTheme.loginGradientEnd
                    ],
                    begin: FractionalOffset(0.0, 0.0),
                    end: FractionalOffset(1.0, 1.0),
                    stops: <double>[0.0, 1.0],
                    tileMode: TileMode.clamp),
              ),
              child: Image(
                height: 150,
                fit: BoxFit.scaleDown,
                image: AssetImage('assets/img/login_logo.png'),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.image),
              title: const Text('Banners'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Banners(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('Biografia'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Biography(),
                  ),
                );
              },
            ),
            const ListTile(
              leading: Icon(Icons.audiotrack_outlined),
              title: Text('Discografia'),
            ),
            const ListTile(
              leading: Icon(Icons.calendar_view_day),
              title: Text('Agenda'),
            ),
            const ListTile(
              leading: Icon(Icons.monochrome_photos),
              title: Text('Fotos'),
            ),
            const ListTile(
              leading: Icon(Icons.movie_creation),
              title: Text('Vídeos'),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Desconectar'),
              onTap: () {
                _logOut();
              },
            ),
          ],
        ),
      ),
    );
    /*Scaffold(
      appBar: AppBar(
        title: const Text('AppBar Demo'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add_alert),
            tooltip: 'Show Snackbar',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('This is a snackbar')));
            },
          ),
          IconButton(
            icon: const Icon(Icons.navigate_next),
            tooltip: 'Go to the next page',
            onPressed: () {
              Navigator.push(context, MaterialPageRoute<void>(
                builder: (BuildContext context) {
                  return Scaffold(
                    appBar: AppBar(
                      title: const Text('Next page'),
                    ),
                    body: const Center(
                      child: Text(
                        'This is the next page',
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                  );
                },
              ));
            },
          ),
        ],
      ),
      body: const Center(
        child: Text(
          'This is the Dashboard page',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );*/
    /*return Container(
      padding: const EdgeInsets.only(top: 23.0),
      child: Column(
        children: <Widget>[
          Stack(
            alignment: Alignment.topCenter,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(top: 180.0),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: CustomTheme.loginGradientStart,
                      offset: Offset(1.0, 6.0),
                      blurRadius: 20.0,
                    ),
                    BoxShadow(
                      color: CustomTheme.loginGradientEnd,
                      offset: Offset(1.0, 6.0),
                      blurRadius: 20.0,
                    ),
                  ],
                  gradient: LinearGradient(
                      colors: <Color>[
                        CustomTheme.loginGradientEnd,
                        CustomTheme.loginGradientStart
                      ],
                      begin: FractionalOffset(0.2, 0.2),
                      end: FractionalOffset(1.0, 1.0),
                      stops: <double>[0.0, 1.0],
                      tileMode: TileMode.clamp),
                ),
                child: MaterialButton(
                  highlightColor: Colors.transparent,
                  splashColor: CustomTheme.loginGradientEnd,
                  child: const Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 42.0),
                    child: Text(
                      'DESCONECTAR',
                      style: TextStyle(
                          color: Colors.yellow,
                          fontSize: 25.0,
                          fontFamily: 'WorkSansBold'),
                    ),
                  ),
                  onPressed: () => _toggleDashboardButton(),
                )
              )
            ],
          ),
          /*Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: TextButton(
                onPressed: () => _toggleForgotPasswordButton(),
                child: const Text(
                  'Esqueceu sua senha?',
                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Colors.white,
                      fontSize: 16.0,
                      fontFamily: 'WorkSansMedium'),
                )),
          ),*/
        ],
      ),
    );*/
  }

  /*
  void _toggleDashboardButton() {
    CustomSnackBar(context, const Text('Aguarde...'));
    _logoutUser();
  }
  */
}
