import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hwscontrol/core/components/snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hwscontrol/core/models/biography_model.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:hwscontrol/core/theme/custom_theme.dart';
// import 'dart:convert' as convert;

class Biography extends StatefulWidget {
  const Biography({Key? key}) : super(key: key);

  @override
  _BiographyState createState() => _BiographyState();
}

class _BiographyState extends State<Biography> {
  final TextEditingController _descriptionController = TextEditingController();

  _onVerifyData() {
    //Recupera dados dos campos
    String description = _descriptionController.text;

    if (description.trim().isNotEmpty && description.trim().length >= 3) {
      BiographyModel biographyModel = BiographyModel(description: description);

      _onSaveData(biographyModel);
    } else {
      setState(() {
        CustomSnackBar(context, const Text('Digite a biografia!'),
            backgroundColor: Colors.red);
      });
    }
  }

  _onSaveData(BiographyModel biographyModel) {
    EasyLoading.showInfo(
      'gravando dados...',
      maskType: EasyLoadingMaskType.custom,
    );
    FirebaseFirestore db = FirebaseFirestore.instance;
    db.collection("biography").doc("data").set(biographyModel.toMap());

    setState(() {
      Timer(const Duration(milliseconds: 1500), () {
        _getData();
      });
    });
  }

  _getData() async {
    FirebaseFirestore db = FirebaseFirestore.instance;

    await db
        .collection("biography")
        .doc("data")
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      setState(() {
        if (documentSnapshot.exists) {
          _descriptionController.text =
              documentSnapshot['description'].toString();
        }
        closeLoading();
      });
    }).catchError((error) {
      closeLoading();
    });
  }

  closeLoading() {
    if (EasyLoading.isShow) {
      Timer(const Duration(milliseconds: 2000), () {
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
        title: const Text('Biografia'),
        backgroundColor: Colors.black38,
      ),
      body: SizedBox(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 15, 20, 20),
          child: TextField(
            controller: _descriptionController,
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.next,
            maxLines: 500,
            cursorColor: Colors.white,
            textAlign: TextAlign.start,
            style: const TextStyle(
              fontFamily: 'WorkSansThin',
              fontSize: 14,
              color: Colors.white,
            ),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.fromLTRB(16, 20, 15, 20),
              labelText: "Digite a biografia",
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
