import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:hwscontrol/core/components/storage.dart';
import 'package:hwscontrol/pages/modules/artists.dart';
import 'package:hwscontrol/pages/modules/banners.dart';
import 'package:hwscontrol/pages/modules/biography.dart';
import 'package:hwscontrol/pages/modules/disc_albums.dart';
import 'package:hwscontrol/pages/modules/downloads.dart';
import 'package:hwscontrol/pages/modules/login_page.dart';
import 'package:hwscontrol/core/theme/custom_theme.dart';
import 'package:hwscontrol/core/components/snackbar.dart';
import 'package:hwscontrol/pages/modules/message_boards.dart';
import 'package:hwscontrol/pages/modules/photo_albums.dart';
import 'package:hwscontrol/pages/modules/schedule.dart';
import 'package:hwscontrol/pages/modules/settings.dart';
import 'package:hwscontrol/pages/modules/videos.dart';

class Dashboard extends StatefulWidget {
  final String title;
  const Dashboard({Key? key, required this.title}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  // settings do app
  _settingsApp() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const Settings(),
      ),
    );
  }

  _openSite() async {
    String url = 'https://www.joaoluizcorrea.com.br';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Site não disponível $url';
    }
  }

  // desconectar do app
  _logoutApp() async {
    return await showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Desconectar'),
        content: const Text('Desconectar do sistema?'),
        actions: [
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
              _logoutFirebase();
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
    );
  }

  _logoutFirebase() {
    // Deletar token de acesso
    DeleteAll().deleteAllTokens();

    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginPage(title: 'Loading...'),
        ),
        (route) => false);

    // Disconnect firebase
    FirebaseAuth auth = FirebaseAuth.instance;

    auth.signOut().then((value) {
      // print(firebaseUser);
      // String uid = firebaseUser.user!.uid;
      CustomSnackBar(context, const Text('Desconectado'));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (builder) => const LoginPage(title: 'Loading...'),
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
    int gritCol = 4;
    int sizeCol = MediaQuery.of(context).size.width.toInt();
    double widthCol = MediaQuery.of(context).size.width;
    double heightCol = 120;
    if (sizeCol >= 1500) {
      gritCol = 8;
    } else if (sizeCol >= 900) {
      gritCol = 6;
    } else if (sizeCol >= 600) {
      gritCol = 4;
    } else if (sizeCol >= 200) {
      gritCol = 2;
    } else {
      gritCol = 1;
    }
    widthCol = widthCol / gritCol;
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: const Text('Painel de controle'),
        backgroundColor: Colors.black38,
        actions: [
          IconButton(
            padding: const EdgeInsets.only(right: 10),
            icon: const Icon(Icons.add_to_home_screen_outlined),
            tooltip: 'Abrir Site',
            onPressed: _openSite,
          ),
          IconButton(
            padding: const EdgeInsets.only(right: 10),
            icon: const Icon(Icons.settings_suggest),
            tooltip: 'Configurações',
            onPressed: _settingsApp,
          ),
          IconButton(
            padding: const EdgeInsets.only(right: 10),
            icon: const Icon(Icons.logout),
            tooltip: 'Desconectar',
            onPressed: _logoutApp,
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
              leading: const Icon(Icons.audiotrack_outlined),
              title: const Text('Discografia'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DiscAlbums(),
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
                    builder: (context) => const PhotoAlbums(),
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
              leading: const Icon(Icons.cloud_download_rounded),
              title: const Text('Downloads'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Downloads(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.list_alt_outlined),
              title: const Text('Mural de Recados'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MessageBoards(),
                  ),
                );
              },
            ),
            const Divider(
              indent: 15,
              endIndent: 15,
              height: 15,
              color: Colors.black26,
              thickness: .5,
            ),
            ListTile(
              leading: const Icon(Icons.add_to_home_screen_outlined),
              title: const Text('Abrir Site'),
              onTap: _openSite,
            ),
            const Divider(
              indent: 15,
              endIndent: 15,
              height: 15,
              color: Colors.black26,
              thickness: .5,
            ),
            ListTile(
              leading: const Icon(Icons.settings_suggest),
              title: const Text('Configurações'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Settings(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Desconectar'),
              onTap: _logoutApp,
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
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
                  children: [
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
                  children: [
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
                  children: [
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
                  children: [
                    IconButton(
                      icon: const Icon(Icons.audiotrack_outlined),
                      color: Colors.amber,
                      iconSize: 48,
                      //tooltip: '',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const DiscAlbums(),
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
                  children: [
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
                  children: [
                    IconButton(
                      icon: const Icon(Icons.image),
                      color: Colors.amber,
                      iconSize: 48,
                      //tooltip: '',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PhotoAlbums(),
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
                  children: [
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
                Column(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.cloud_download_rounded),
                      color: Colors.amber,
                      iconSize: 48,
                      //tooltip: '',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Downloads(),
                          ),
                        );
                      },
                    ),
                    const Text(
                      'Downloads',
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 16.0,
                        fontFamily: 'WorkSansLigth',
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.list_alt_outlined),
                      color: Colors.amber,
                      iconSize: 48,
                      //tooltip: '',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MessageBoards(),
                          ),
                        );
                      },
                    ),
                    const Text(
                      'Mural de Recados',
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 16.0,
                        fontFamily: 'WorkSansLigth',
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.add_to_home_screen_outlined),
                      color: Colors.amber,
                      iconSize: 48,
                      //tooltip: '',
                      onPressed: _openSite,
                    ),
                    const Text(
                      'Abrir Site',
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 16.0,
                        fontFamily: 'WorkSansLigth',
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.settings_suggest),
                      color: Colors.amber,
                      iconSize: 48,
                      //tooltip: '',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Settings(),
                          ),
                        );
                      },
                    ),
                    const Text(
                      'Configurações',
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 16.0,
                        fontFamily: 'WorkSansLigth',
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.logout),
                      color: Colors.amber,
                      iconSize: 48,
                      //tooltip: '',
                      onPressed: _logoutApp,
                    ),
                    const Text(
                      'Desconectar',
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
          ), /*
          const Padding(
            padding: EdgeInsets.only(top: 50),
            child: Image(
              image: AssetImage('assets/img/dash.png'),
              width: 200,
              height: 200,
            ),
          )*/
        ],
      ),
    );
  }
}
