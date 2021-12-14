import 'package:flutter/material.dart';
import 'package:hwscontrol/core/storage.dart';
import 'package:hwscontrol/pages/modules/banners.dart';
import 'package:hwscontrol/pages/modules/biography.dart';
import 'package:hwscontrol/pages/modules/login_page.dart';
import 'package:hwscontrol/core/theme/custom_theme.dart';
import 'package:hwscontrol/core/widgets/snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hwscontrol/pages/modules/photos.dart';
import 'package:hwscontrol/pages/modules/videos.dart';

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
            icon: const Icon(Icons.people),
            tooltip: 'Users',
            onPressed: () {
              //
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
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('Fotos'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Photos(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.movie_creation),
              title: const Text('Vídeos'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Videos(),
                  ),
                );
              },
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
  }
}
