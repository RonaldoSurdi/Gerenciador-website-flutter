import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hwscontrol/theme.dart';
import 'package:hwscontrol/widgets/snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hwscontrol/core/biography_data.dart';

class Biography extends StatefulWidget {
  const Biography({ Key? key }) : super(key: key);

  @override
  _BiographyState createState() => _BiographyState();
}

class _BiographyState extends State<Biography> {
  TextEditingController _descriptionController = TextEditingController();

  _onVerifyData() {
    //Recupera dados dos campos
    String description = _descriptionController.text;

    if (description.trim().isNotEmpty && description.trim().length >= 3) {
        setState(() {
          CustomSnackBar(context, const Text('Verificando'));
        });

        BiographyData biographyData = BiographyData(
          description: description
        );

        _onSaveData(biographyData);
    } else {
      setState(() {
        CustomSnackBar(context, const Text('Digite a biografia!'), backgroundColor: Colors.red);
      });
    }
  }

  _onSaveData(BiographyData biographyData) {

      FirebaseFirestore db = FirebaseFirestore.instance;

      db.collection("biography").doc("Data").set(biographyData.toMap());

      setState(() {
        CustomSnackBar(context, const Text('Dados gravados com sucesso.'));
      });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFF666666),
      appBar: AppBar(
        title: const Text('Biografia'),
        backgroundColor: Colors.black38,
      ),
      body: Container(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 15, 20, 20),
          child: TextField(
            controller: _descriptionController,
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.next,
            maxLines: 20,
            cursorColor: Colors.white,
            // selectionColor: Colors.white,
            // selectionHandleColor: Colors.white,
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(10, 16, 10, 16),
              labelText: "Digite a biografia",
              filled: true,
              labelStyle: TextStyle(
                color: Colors.white38,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.white38,
                )
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
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
        tooltip: 'Salvar dados',
        child: const Icon(Icons.save),
        backgroundColor: Colors.green,
      ),
    );
  }
}