import 'package:flutter/material.dart';
import 'package:hwscontrol/pages/modules/login_password.dart';
import 'package:hwscontrol/pages/modules/login_signin.dart';
import 'package:hwscontrol/pages/modules/login_signup.dart';
import 'package:hwscontrol/core/theme/custom_theme.dart';

class LoginAuth extends StatefulWidget {
  final String title;
  const LoginAuth({Key? key, required this.title}) : super(key: key);

  @override
  _LoginAuthState createState() => _LoginAuthState();
}

class _LoginAuthState extends State<LoginAuth>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;

  Color left = Colors.yellow;
  Color center = Colors.white;
  Color right = Colors.white;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
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
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 75.0),
                  child: Image(
                      height: MediaQuery.of(context).size.height > 800
                          ? 191.0
                          : 150,
                      fit: BoxFit.fill,
                      image: const AssetImage('assets/img/login_logo.png')),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: _buildMenuBar(context),
                ),
                Expanded(
                  flex: 2,
                  child: PageView(
                    controller: _pageController,
                    physics: const ClampingScrollPhysics(),
                    onPageChanged: (int i) {
                      FocusScope.of(context).requestFocus(FocusNode());
                      if (i == 0) {
                        setState(() {
                          left = Colors.yellow;
                          center = Colors.white;
                          right = Colors.white;
                        });
                      } else if (i == 1) {
                        setState(() {
                          left = Colors.white;
                          center = Colors.yellow;
                          right = Colors.white;
                        });
                      } else if (i == 2) {
                        setState(() {
                          left = Colors.white;
                          center = Colors.white;
                          right = Colors.yellow;
                        });
                      }
                    },
                    children: [
                      ConstrainedBox(
                        constraints: const BoxConstraints.expand(),
                        child: const LoginSignin(),
                      ),
                      ConstrainedBox(
                        constraints: const BoxConstraints.expand(),
                        child: const LoginSignup(),
                      ),
                      ConstrainedBox(
                        constraints: const BoxConstraints.expand(),
                        child: const LoginPassword(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuBar(BuildContext context) {
    return Container(
      width: 300.0,
      height: 50.0,
      decoration: const BoxDecoration(
        color: Color(0x552B2B2B),
        borderRadius: BorderRadius.all(Radius.circular(21.0)),
      ),
      child: CustomPaint(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: TextButton(
                style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                ),
                onPressed: _onLoginSigninButtonPress,
                child: Text(
                  'Conectar',
                  style: TextStyle(
                    color: left,
                    fontSize: 14.0,
                    fontFamily: 'WorkSansThin',
                  ),
                ),
              ),
            ),
            Container(height: 33.0, width: 1.0, color: Colors.white),
            Expanded(
              child: TextButton(
                style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                ),
                onPressed: _onLoginSignupButtonPress,
                child: Text(
                  'Cadastrar',
                  style: TextStyle(
                    color: center,
                    fontSize: 14.0,
                    fontFamily: 'WorkSansThin',
                  ),
                ),
              ),
            ),
            Container(
              height: 33.0,
              width: 1.0,
              color: Colors.white,
            ),
            Expanded(
              child: TextButton(
                style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                ),
                onPressed: _onLoginPasswordButtonPress,
                child: Text(
                  'Redefinir',
                  style: TextStyle(
                    color: right,
                    fontSize: 14.0,
                    fontFamily: 'WorkSansThin',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onLoginSigninButtonPress() {
    _pageController.animateToPage(0,
        duration: const Duration(milliseconds: 500), curve: Curves.decelerate);
  }

  void _onLoginSignupButtonPress() {
    _pageController.animateToPage(1,
        duration: const Duration(milliseconds: 500), curve: Curves.decelerate);
  }

  void _onLoginPasswordButtonPress() {
    _pageController.animateToPage(2,
        duration: const Duration(milliseconds: 500), curve: Curves.decelerate);
  }
}
