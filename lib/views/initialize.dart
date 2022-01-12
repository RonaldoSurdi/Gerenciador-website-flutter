import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hwscontrol/views/dashboard.dart';
import 'package:hwscontrol/views/login_auth.dart';

class Initialize extends StatefulWidget {
  final String title;
  const Initialize({Key? key, required this.title}) : super(key: key);

  @override
  _InitializeState createState() => _InitializeState();
}

class _InitializeState extends State<Initialize> {
  final _storage = const FlutterSecureStorage();
  final _firebaseAuth = FirebaseAuth.instance;

  bool _processInit = false;
  String _processEmail = '';
  String _processPassword = '';

  _verifyConnect() async {
    try {
      _processEmail = (await _storage.read(key: "keyMail")) ?? "";
      _processPassword = (await _storage.read(key: "keyPasswd")) ?? "";
      _processInit = (_processEmail != '' || _processPassword != '');
      if (_processInit) {
        _firebaseAuth
            .signInWithEmailAndPassword(
          email: _processEmail,
          password: _processPassword,
        )
            .then((firebaseUser) {
          _initializePage();
        }).catchError((error) {
          _processInit = false;
          _initializePage();
        });
      } else {
        _initializePage();
      }
    } catch (e) {
      _processInit = false;
      _initializePage();
    }
  }

  _initializePage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (builder) => _processInit
            ? const Dashboard(title: 'Loading...')
            : const LoginAuth(title: 'Loading...'),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _verifyConnect();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(),
    );
  }
}
