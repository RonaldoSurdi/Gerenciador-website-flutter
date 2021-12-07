import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hwscontrol/theme.dart';
import 'package:hwscontrol/widgets/snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hwscontrol/core/users.dart';
import 'package:hwscontrol/pages/home.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final FocusNode focusNodeEmail = FocusNode();
  
  final TextEditingController forgotpasswordEmailController = TextEditingController();
  
  _validateFields() {
    //Recupera dados dos campos
    String email = forgotpasswordEmailController.text;

    if (email.trim().isNotEmpty && email.trim().contains("@")) {
        setState(() {
          CustomSnackBar(context, const Text('Verificando'));
        });

        Users users = Users(
          email: email
        );

        _sendpassword(users);
    } else {
      setState(() {
        CustomSnackBar(context, const Text('Preencha o E-mail utilizando @'), backgroundColor: Colors.red);
      });
    }
  }

  _sendpassword(Users users) async {
    
    FirebaseAuth auth = FirebaseAuth.instance;

    await auth.sendPasswordResetEmail(
      email: users.email!,
    ).then((firebaseUser) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (builder) => const Home(),
        ),
      );
    }).catchError((error) {
      print("erro app: " + error.toString());
      setState(() {
        CustomSnackBar(context, const Text('Erro ao enviar e-mail, verifique os campos e tente novamente!'), backgroundColor: Colors.red);
      });
    });
  }

  @override
  void dispose() {
    focusNodeEmail.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 23.0),
      child: Column(
        children: <Widget>[
          Stack(
            alignment: Alignment.topCenter,
            children: <Widget>[
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
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                        child: TextField(
                          focusNode: focusNodeEmail,
                          controller: forgotpasswordEmailController,
                          keyboardType: TextInputType.emailAddress,
                          autocorrect: false,
                          style: const TextStyle(
                              fontFamily: 'WorkSansThin',
                              fontSize: 16.0,
                              color: Colors.black),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(
                              FontAwesomeIcons.envelope,
                              color: Colors.black,
                            ),
                            hintText: 'E-mail cadastrado',
                            hintStyle: TextStyle(
                                fontFamily: 'WorkSansThin', fontSize: 16.0),
                          ),
                          onSubmitted: (_) {
                            _toggleForgotPasswordButton();
                          },
                        ),
                      ),
                      Container(
                        width: 250.0,
                        height: 1.0,
                        color: Colors.grey[400],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0, left: 15.0, right: 15.0),
                        child: TextButton(
                            onPressed: () => _toggleForgotPasswordButton(),
                            child: const Text(
                              'Será enviado o link para redefinir sua senha.',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12.0,
                                  fontFamily: 'WorkSansThin'),
                            )),
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
                      'ENVIAR',
                      style: TextStyle(
                          color: Colors.yellow,
                          fontSize: 25.0,
                          fontFamily: 'WorkSansBold'),
                    ),
                  ),
                  onPressed: () => _toggleForgotPasswordButton(),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  void _toggleForgotPasswordButton() {
    CustomSnackBar(context, const Text('Verificando'));
    _validateFields();
  }
}
