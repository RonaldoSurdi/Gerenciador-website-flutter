import 'package:flutter/material.dart';
import 'dart:async';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hwscontrol/core/theme/custom_theme.dart';
import 'package:hwscontrol/core/components/snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hwscontrol/views/login_auth.dart';

class LoginPassword extends StatefulWidget {
  const LoginPassword({Key? key}) : super(key: key);

  @override
  _LoginPasswordState createState() => _LoginPasswordState();
}

class _LoginPasswordState extends State<LoginPassword> {
  final FocusNode _focusNodeEmail = FocusNode();

  final TextEditingController forgotpasswordEmailController =
      TextEditingController();

  _validateFields() {
    //Recupera dados dos campos
    String email = forgotpasswordEmailController.text;

    if (email.trim().isNotEmpty && email.trim().contains("@")) {
      setState(() {
        CustomSnackBar(context, const Text('Verificando'));
      });

      _sendpassword(email);
    } else {
      setState(() {
        CustomSnackBar(context, const Text('Preencha o E-mail utilizando @'),
            backgroundColor: Colors.red);
      });
    }
  }

  _sendpassword(String email) async {
    EasyLoading.showInfo(
      'enviando email...',
      maskType: EasyLoadingMaskType.custom,
      dismissOnTap: false,
      duration: const Duration(seconds: 10),
    );

    FirebaseAuth auth = FirebaseAuth.instance;

    await auth
        .sendPasswordResetEmail(
      email: email,
    )
        .then((firebaseUser) {
      closeLoading();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (builder) => const LoginAuth(title: 'Loading...'),
        ),
      );
    }).catchError((error) {
      closeLoading();

      setState(() {
        CustomSnackBar(
            context,
            const Text(
                'Erro ao enviar e-mail, verifique os campos e tente novamente!'),
            backgroundColor: Colors.red);
      });
    });
  }

  closeLoading() {
    if (EasyLoading.isShow) {
      Timer(const Duration(milliseconds: 500), () {
        EasyLoading.dismiss(animation: true);
      });
    }
  }

  @override
  void dispose() {
    _focusNodeEmail.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 23.0),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.topCenter,
            children: [
              Card(
                elevation: 2.0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: SizedBox(
                  width: 300.0,
                  height: 160.0,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                        child: TextField(
                          focusNode: _focusNodeEmail,
                          controller: forgotpasswordEmailController,
                          keyboardType: TextInputType.text,
                          autocorrect: false,
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
                            ),
                            hintText: 'E-mail cadastrado',
                            hintStyle: TextStyle(
                              fontFamily: 'WorkSansThin',
                              fontSize: 16.0,
                            ),
                          ),
                          onSubmitted: (_) {
                            _toggleLoginPasswordButton();
                          },
                        ),
                      ),
                      Container(
                        width: 250.0,
                        height: 1.0,
                        color: Colors.grey[400],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 10.0, left: 15.0, right: 15.0),
                        child: TextButton(
                          onPressed: () => _toggleLoginPasswordButton(),
                          child: const Text(
                            'Será enviado o link para redefinir sua senha.',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12.0,
                              fontFamily: 'WorkSansThin',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 140.0),
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
                      'Enviar email',
                      style: TextStyle(
                        color: Colors.yellow,
                        fontSize: 25.0,
                        fontFamily: 'WorkSansBold',
                      ),
                    ),
                  ),
                  onPressed: () => _toggleLoginPasswordButton(),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  void _toggleLoginPasswordButton() {
    CustomSnackBar(context, const Text('Verificando'));
    _validateFields();
  }
}
