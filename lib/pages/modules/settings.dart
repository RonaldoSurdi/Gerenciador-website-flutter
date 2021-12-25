import 'package:flutter/material.dart';
import 'package:hwscontrol/core/components/snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hwscontrol/core/models/settings_model.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:hwscontrol/core/theme/custom_theme.dart';
// import 'dart:convert' as convert;

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  _onVerifyData() {
    //Recupera dados dos campos
    String name = _nameController.text;
    String email = _emailController.text;

    if (name.trim().isNotEmpty &&
        name.trim().length >= 3 &&
        email.trim().isNotEmpty &&
        email.trim().length >= 3) {
      setState(() {
        CustomSnackBar(context, const Text('Verificando'));
      });

      SettingsModel settingsModel = SettingsModel(name: name, email: email);

      _onSaveData(settingsModel);
    } else {
      setState(() {
        CustomSnackBar(context, const Text('Preencha todos os dados!'),
            backgroundColor: Colors.red);
      });
    }
  }

  _onSaveData(SettingsModel settingsModel) {
    FirebaseFirestore db = FirebaseFirestore.instance;
    db.collection("settings").doc("data").set(settingsModel.toMap());

    setState(() {
      CustomSnackBar(context, const Text('Dados gravados com sucesso.'));
    });
  }

  _getData() {
    FirebaseFirestore db = FirebaseFirestore.instance;
    db
        .collection("settings")
        .doc("data")
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        _nameController.text = documentSnapshot['name'].toString();
        _emailController.text = documentSnapshot['email'].toString();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    _getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: const Text('Configurações'),
        backgroundColor: Colors.black38,
      ),
      body: SizedBox(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 15, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Divider(
                indent: 15,
                endIndent: 15,
                height: 50,
                color: Colors.black12,
                thickness: .1,
              ),
              TextField(
                controller: _nameController,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                cursorColor: Colors.white,
                textAlign: TextAlign.left,
                style: const TextStyle(
                  fontFamily: 'WorkSansThin',
                  fontSize: 14,
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.fromLTRB(16, 20, 15, 20),
                  labelText: "Nome",
                  filled: true,
                  labelStyle: const TextStyle(
                    fontFamily: 'WorkSansThin',
                    color: Colors.white38,
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white38,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.white38,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
              const Divider(
                indent: 15,
                endIndent: 15,
                height: 50,
                color: Colors.black26,
                thickness: .1,
              ),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                cursorColor: Colors.white,
                textAlign: TextAlign.left,
                style: const TextStyle(
                  fontFamily: 'WorkSansThin',
                  fontSize: 14,
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.fromLTRB(16, 20, 15, 20),
                  labelText: "Email",
                  filled: true,
                  labelStyle: const TextStyle(
                    fontFamily: 'WorkSansThin',
                    color: Colors.white38,
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white38,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.white38,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _onVerifyData(),
        tooltip: 'Salvar alterações',
        child: const Icon(Icons.save),
        backgroundColor: Colors.green,
      ),
    );
  }
}
