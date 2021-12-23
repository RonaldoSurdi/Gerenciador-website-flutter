import 'package:flutter/material.dart';
import 'package:hwscontrol/core/components/storage.dart';
import 'package:hwscontrol/pages/modules/artists.dart';
import 'package:hwscontrol/pages/modules/banners.dart';
import 'package:hwscontrol/pages/modules/biography.dart';
import 'package:hwscontrol/pages/modules/discography.dart';
import 'package:hwscontrol/pages/modules/login_page.dart';
import 'package:hwscontrol/core/theme/custom_theme.dart';
import 'package:hwscontrol/core/components/snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hwscontrol/pages/modules/photos.dart';
import 'package:hwscontrol/pages/modules/schedule.dart';
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
    var gritCol = 2;
    int sizeCol = MediaQuery.of(context).size.width.toInt();
    double widthCol = MediaQuery.of(context).size.width;
    double heightCol = 120;
    if (sizeCol >= 700) {
      gritCol = 3;
      widthCol = widthCol / gritCol;
    } else if (sizeCol >= 900) {
      gritCol = 4;
      widthCol = widthCol / gritCol;
    } else {
      widthCol = widthCol / gritCol;
    }
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
          children: [
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
              leading: const Icon(Icons.picture_in_picture),
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
            ListTile(
              leading: const Icon(Icons.adjust_rounded),
              title: const Text('Discografia'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Discography(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.person_outline_outlined),
              title: const Text('Artistas'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Artists(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.schedule),
              title: const Text('Agenda de Shows'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Schedule(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.image),
              title: const Text('Fotos Shows'),
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
              title: const Text('Vídeos Youtube'),
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
              onTap: () => showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text('Desconectar'),
                  content: const Text('Desconectar do sistema?'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Cancelar',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.0,
                          fontFamily: 'WorkSansMedium',
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        _logOut();
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Desconectar',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 16.0,
                          fontFamily: 'WorkSansMedium',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 40),
            child: GridView.count(
              crossAxisCount: gritCol,
              childAspectRatio: (widthCol / heightCol),
              //childAspectRatio: 200,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              controller: ScrollController(keepScrollOffset: false),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    IconButton(
                      icon: const Icon(Icons.picture_in_picture),
                      color: Colors.amber,
                      iconSize: 48,
                      //tooltip: '',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Banners(),
                          ),
                        );
                      },
                    ),
                    const Text(
                      'Banners',
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 16.0,
                        fontFamily: 'WorkSansLigth',
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    IconButton(
                      icon: const Icon(Icons.info),
                      color: Colors.amber,
                      iconSize: 48,
                      //tooltip: '',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Biography(),
                          ),
                        );
                      },
                    ),
                    const Text(
                      'Biografia',
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 16.0,
                        fontFamily: 'WorkSansLigth',
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    IconButton(
                      icon: const Icon(Icons.person_outline_outlined),
                      color: Colors.amber,
                      iconSize: 48,
                      //tooltip: '',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Artists(),
                          ),
                        );
                      },
                    ),
                    const Text(
                      'Artistas',
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 16.0,
                        fontFamily: 'WorkSansLigth',
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    IconButton(
                      icon: const Icon(Icons.adjust_rounded),
                      color: Colors.amber,
                      iconSize: 48,
                      //tooltip: '',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Discography(),
                          ),
                        );
                      },
                    ),
                    const Text(
                      'Discografia',
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 16.0,
                        fontFamily: 'WorkSansLigth',
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    IconButton(
                      icon: const Icon(Icons.schedule),
                      color: Colors.amber,
                      iconSize: 48,
                      //tooltip: '',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Schedule(),
                          ),
                        );
                      },
                    ),
                    const Text(
                      'Agenda de Shows',
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 16.0,
                        fontFamily: 'WorkSansLigth',
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    IconButton(
                      icon: const Icon(Icons.image),
                      color: Colors.amber,
                      iconSize: 48,
                      //tooltip: '',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Photos(),
                          ),
                        );
                      },
                    ),
                    const Text(
                      'Fotos Shows',
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 16.0,
                        fontFamily: 'WorkSansLigth',
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    IconButton(
                      icon: const Icon(Icons.movie),
                      color: Colors.amber,
                      iconSize: 48,
                      //tooltip: '',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Videos(),
                          ),
                        );
                      },
                    ),
                    const Text(
                      'Vídeos Youtube',
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 16.0,
                        fontFamily: 'WorkSansLigth',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 50),
            child: Image(
              image: AssetImage('assets/img/dash.png'),
              width: 200,
              height: 200,
            ),
          )
        ],
      ),
    );
  }
}
