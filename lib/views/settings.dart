import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hwscontrol/core/components/snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hwscontrol/core/models/settings_public_model.dart';
import 'package:hwscontrol/core/models/settings_private_model.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _channelidController = TextEditingController();
  final TextEditingController _smtpHostController = TextEditingController();
  final TextEditingController _smtpPortController = TextEditingController();
  final TextEditingController _smtpUserController = TextEditingController();
  final TextEditingController _smtpPassController = TextEditingController();

  int? _videosValue = 1;
  bool? _smtpSecure = true;
  String? _smtpUser = 'digite seu email';
  String? _smtpPass = 'digite sua chave';

  _onVerifyData() {
    //Recupera dados dos campos
    String name = _nameController.text;
    String email = _emailController.text;
    String channelid = _channelidController.text;
    String smtpHost = _smtpHostController.text;
    int smtpPort = int.parse(_smtpPortController.text);
    int idx = _smtpUser!.indexOf('***@');
    if (_smtpUserController.text != 'digite seu email' && idx > 0) {
      _smtpUser = _smtpUserController.text;
    }
    if (_smtpPassController.text != 'digite sua chave') {
      _smtpPass = _smtpPassController.text;
    }

    if (name.trim().isNotEmpty &&
        name.trim().length >= 3 &&
        email.trim().isNotEmpty &&
        email.trim().length >= 3) {
      SettingspublicModel settingspublicModel = SettingspublicModel(
        name: name,
        email: email,
        videostype: _videosValue,
        channelid: channelid,
      );

      SettingsprivateModel settingsprivateModel = SettingsprivateModel(
        smtphost: smtpHost,
        smtpport: smtpPort,
        smtpsecure: _smtpSecure,
        smtpuser: _smtpUser,
        smtppass: _smtpPass,
      );

      _onSaveData(settingspublicModel, settingsprivateModel);
    } else {
      setState(() {
        CustomSnackBar(context, const Text('Preencha todos os dados!'),
            backgroundColor: Colors.red);
      });
    }
  }

  _onSaveData(SettingspublicModel settingspublicModel,
      SettingsprivateModel settingsprivateModel) {
    EasyLoading.showInfo(
      'gravando dados...',
      maskType: EasyLoadingMaskType.custom,
      dismissOnTap: false,
      duration: const Duration(seconds: 10),
    );

    FirebaseFirestore db = FirebaseFirestore.instance;
    db.collection("settings").doc("data").set(settingspublicModel.toMap());
    db.collection("settings").doc("secure").set(settingsprivateModel.toMap());

    setState(() {
      Timer(const Duration(milliseconds: 500), () {
        _getData();
      });
    });
  }

  _getData() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    var data = await db.collection("settings").get();
    setState(() {
      var response = data.docs;
      if (response.isNotEmpty) {
        _nameController.text = response[0]['name'].toString();
        _emailController.text = response[0]['email'].toString();
        _channelidController.text = response[0]['channelid'].toString();
        _videosValue = response[0]['videostype'];
        _smtpHostController.text = response[1]['smtphost'];
        _smtpPortController.text = response[1]['smtpport'].toString();
        _smtpSecure = response[1]['smtpsecure'];
        _smtpUser = response[1]['smtpuser'].toString();
        int idx = _smtpUser.toString().indexOf('@');
        int cnt = _smtpUser.toString().length;
        String viewUser =
            _smtpUser!.substring(0, 2) + '***' + _smtpUser!.substring(idx, cnt);
        _smtpUserController.text = viewUser;
        _smtpPass = response[1]['smtppass'].toString();
        _smtpPassController.text = 'digite sua chave';
      }
    });
    closeLoading();
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
                height: 10,
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
              const Divider(
                indent: 15,
                endIndent: 15,
                height: 50,
                color: Colors.black26,
                thickness: .1,
              ),
              const Text(
                'Vídeos Youtube',
                style: TextStyle(
                  fontFamily: 'WorkSansThin',
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
              const Divider(
                indent: 15,
                endIndent: 15,
                height: 10,
                color: Colors.black26,
                thickness: .1,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Radio(
                    value: 0,
                    groupValue: _videosValue,
                    onChanged: (value) {
                      setState(() {
                        _videosValue = value as int;
                      });
                    },
                  ),
                  const Text(
                    'Cadastrados',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.0,
                      fontFamily: 'WorkSansMedium',
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  Radio(
                    value: 1,
                    groupValue: _videosValue,
                    onChanged: (value) {
                      setState(() {
                        _videosValue = value as int;
                      });
                    },
                  ),
                  const Text(
                    'Canal oficial',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.0,
                      fontFamily: 'WorkSansMedium',
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
              const Divider(
                indent: 15,
                endIndent: 15,
                height: 10,
                color: Colors.black26,
                thickness: .1,
              ),
              TextField(
                controller: _channelidController,
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
                  labelText: "Canal Youtube Id",
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
              const Text(
                'Servidor SMTP',
                style: TextStyle(
                  fontFamily: 'WorkSansThin',
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
              const Divider(
                indent: 15,
                endIndent: 15,
                height: 10,
                color: Colors.black26,
                thickness: .1,
              ),
              TextField(
                controller: _smtpHostController,
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
                  labelText: "Host",
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
                height: 10,
                color: Colors.black26,
                thickness: .1,
              ),
              TextField(
                controller: _smtpPortController,
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
                  labelText: "Porta",
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
                height: 10,
                color: Colors.black26,
                thickness: .1,
              ),
              TextField(
                controller: _smtpUserController,
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
                  labelText: "Usuário",
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
                height: 10,
                color: Colors.black26,
                thickness: .1,
              ),
              TextField(
                controller: _smtpPassController,
                keyboardType: TextInputType.text,
                obscureText: true,
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
                  labelText: "Senha",
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
                height: 10,
                color: Colors.black26,
                thickness: .1,
              ),
              CheckboxListTile(
                controlAffinity: ListTileControlAffinity.leading,
                title: const Text(
                  'Modo seguro',
                  style: TextStyle(
                    fontFamily: 'WorkSansThin',
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
                value: _smtpSecure,
                onChanged: (value) {
                  setState(() {
                    _smtpSecure = !_smtpSecure!;
                  });
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "save_settings",
        onPressed: () => _onVerifyData(),
        tooltip: 'Salvar alterações',
        child: const Icon(Icons.save),
        backgroundColor: Colors.green,
      ),
    );
  }
}
