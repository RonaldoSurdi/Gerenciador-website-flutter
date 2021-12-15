import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hwscontrol/core/theme/custom_theme.dart';
import 'package:hwscontrol/core/widgets/snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hwscontrol/pages/modules/dashboard.dart';
import 'package:loading_overlay_pro/animations/bouncing_line.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController _loginEmailController = TextEditingController();
  final TextEditingController _loginPasswordController =
      TextEditingController();

  final FocusNode _focusNodeEmail = FocusNode();
  final FocusNode _focusNodePassword = FocusNode();

  bool _obscureTextPassword = true;

  _validateFields() {
    //Recupera dados dos campos
    String email = _loginEmailController.text;
    String senha = _loginPasswordController.text;

    if (email.trim().isNotEmpty && email.trim().contains("@")) {
      if (senha.isNotEmpty) {
        setState(() {
          const LoadingBouncingLine.circle(
            borderColor: Colors.cyan,
            borderSize: 3.0,
            size: 120.0,
            backgroundColor: Colors.cyanAccent,
            duration: Duration(milliseconds: 500),
          );
        });

        _logarUsuario();
      } else {
        //setState(() {
        CustomSnackBar(
          context,
          const Text('Preencha a senha!'),
          backgroundColor: Colors.red,
        );
        //});
      }
    } else {
      // setState(() {
      CustomSnackBar(
        context,
        const Text('Preencha o E-mail utilizando @'),
        backgroundColor: Colors.red,
      );
      // });
    }
  }

  _logarUsuario() {
    FirebaseAuth auth = FirebaseAuth.instance;

    auth
        .signInWithEmailAndPassword(
      email: _loginEmailController.text,
      password: _loginPasswordController.text,
    )
        .then((firebaseUser) {
      _saveMail(_loginEmailController.text);
      _savePassword(_loginPasswordController.text);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (builder) => const Dashboard(),
        ),
      );
    }).catchError((error) {
      // setState(() {
      CustomSnackBar(
        context,
        const Text(
            'Erro ao autenticar usuário, verifique e-mail e senha e tente novamente!'),
        backgroundColor: Colors.red,
      );
      // });
    });
  }

  // salvar token do login
  void _saveMail(String email) async {
    const String keyMail = "keyMail";
    final String mail = email;
    await _storage.write(key: keyMail, value: mail);
  }

  void _savePassword(String password) async {
    const String keyPasswd = "keyPasswd";
    final String passwd = password;
    await _storage.write(key: keyPasswd, value: passwd);
  }

  // salvamento seguro de informações
  final _storage = const FlutterSecureStorage();

  _verifyConnect() async {
    _loginEmailController.text = (await _storage.read(key: "keyMail")) ?? "";
    _loginPasswordController.text =
        (await _storage.read(key: "keyPasswd")) ?? "";

    if (_loginEmailController.text.trim().isNotEmpty ||
        _loginPasswordController.text.trim().isNotEmpty) {
      _logarUsuario();
    }
  }

  @override
  void initState() {
    super.initState();
    _verifyConnect();
  }

  @override
  void dispose() {
    _focusNodeEmail.dispose();
    _focusNodePassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 23),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.topCenter,
            children: [
              Card(
                elevation: 2.0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SizedBox(
                  width: 300.0,
                  height: 200.0,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 20.0,
                          bottom: 20.0,
                          left: 25.0,
                          right: 25.0,
                        ),
                        child: TextField(
                          focusNode: _focusNodeEmail,
                          controller: _loginEmailController,
                          keyboardType: TextInputType.emailAddress,
                          style: const TextStyle(
                            fontFamily: 'WorkSansThin',
                            fontSize: 16.0,
                            color: Colors.black,
                          ),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(
                              FontAwesomeIcons.envelope,
                              color: Colors.black,
                              size: 22.0,
                            ),
                            hintText: 'E-mail',
                            hintStyle: TextStyle(
                              fontFamily: 'WorkSansThin',
                              fontSize: 17.0,
                            ),
                          ),
                          onSubmitted: (_) {
                            _focusNodePassword.requestFocus();
                          },
                        ),
                      ),
                      Container(
                        width: 250.0,
                        height: 1.0,
                        color: Colors.grey[400],
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 25, 25),
                        child: TextField(
                          focusNode: _focusNodePassword,
                          controller: _loginPasswordController,
                          obscureText: _obscureTextPassword,
                          style: const TextStyle(
                            fontFamily: 'WorkSansThin',
                            fontSize: 16.0,
                            color: Colors.black,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: const Icon(
                              FontAwesomeIcons.lock,
                              size: 22.0,
                              color: Colors.black,
                            ),
                            hintText: 'Senha',
                            hintStyle: const TextStyle(
                                fontFamily: 'WorkSansThin', fontSize: 17.0),
                            suffixIcon: GestureDetector(
                              onTap: _toggleLogin,
                              child: Icon(
                                _obscureTextPassword
                                    ? FontAwesomeIcons.eye
                                    : FontAwesomeIcons.eyeSlash,
                                size: 15.0,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          onSubmitted: (_) {
                            _toggleSignInButton();
                          },
                          textInputAction: TextInputAction.go,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 180),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
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
                    tileMode: TileMode.clamp,
                  ),
                ),
                child: MaterialButton(
                  highlightColor: Colors.transparent,
                  splashColor: CustomTheme.loginGradientEnd,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 42.0,
                    ),
                    child: Text(
                      'CONECTAR',
                      style: TextStyle(
                        color: Colors.yellow,
                        fontSize: 25.0,
                        fontFamily: 'WorkSansBold',
                      ),
                    ),
                  ),
                  onPressed: () => _toggleSignInButton(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _toggleSignInButton() {
    _validateFields();
  }

  void _toggleLogin() {
    setState(() {
      _obscureTextPassword = !_obscureTextPassword;
    });
  }
}
