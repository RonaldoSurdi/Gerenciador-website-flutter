import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hwscontrol/core/widgets/snackbar.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hwscontrol/core/models/photo_model.dart';

class Photos extends StatefulWidget {
  const Photos({Key? key}) : super(key: key);

  @override
  _PhotosState createState() => _PhotosState();
}

class _PhotosState extends State<Photos> {
  TextEditingController _textFieldController = TextEditingController();
  late String valueText;

  final List<String> _widgetList = [];

  Future<void> _addNewAlbumPhotos(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Adicionar novo álbum de fotos'),
          content: TextField(
            onChanged: (value) {
              setState(() {
                valueText = value;
              });
            },
            controller: _textFieldController,
            decoration: const InputDecoration(hintText: "Digite a descrição"),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancelar',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16.0,
                  fontFamily: 'WorkSansMedium',
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                _saveData(valueText);
                Navigator.pop(context);
              },
              child: const Text(
                'Salvar',
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 16.0,
                  fontFamily: 'WorkSansMedium',
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // faz o envio da imagem para o storage
  Future _saveData(descriptionText) async {
    DateTime now = DateTime.now();
    String dateNow = DateFormat('yyyyMMddkkmmss').format(now);

    PhotoModel photoModel =
        PhotoModel(description: descriptionText, date: dateNow, count: 0);

    FirebaseFirestore db = FirebaseFirestore.instance;
    db.collection("photos").doc(dateNow).set(photoModel.toMap());

    setState(() {
      CustomSnackBar(context, const Text("Álbum criado com sucesso."));
      Timer(const Duration(milliseconds: 1500), () {
        _onGetData();
      });
    });

    return Future.value(true);
  }

  Future _removePicture(fileName) async {
    firebase_storage.Reference arquive = firebase_storage
        .FirebaseStorage.instance
        .ref()
        .child("photos")
        .child(fileName);

    arquive.delete();

    var dbDoc = fileName.toString().split('-');

    FirebaseFirestore db = FirebaseFirestore.instance;
    db.collection("photos").doc(dbDoc[0]).delete();
    setState(() {
      CustomSnackBar(context, Text("Imagem excluida com sucesso.\n$fileName"));
      Timer(const Duration(milliseconds: 500), () {
        _onGetData();
      });
    });
  }

  Future _onGetData() async {
    _widgetList.clear();
    FirebaseFirestore db = FirebaseFirestore.instance;
    var data =
        await db.collection("photos").orderBy('date', descending: true).get();
    var response = data.docs;
    for (int i = 0; i < response.length; i++) {
      setState(() {
        print(response[i]["date"]);
        _widgetList.add(response[i]["date"]);
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _onGetData();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemWidth = size.width;
    final double itemHeight = itemWidth / 1.78;
    /*24 is for notification bar on Android*/
    // final double itemHeight = (size.height - kToolbarHeight - 24) / 2;

    return Scaffold(
      backgroundColor: const Color(0XFF666666),
      appBar: AppBar(
        title: const Text('Álbum de fotos de Shows'),
        backgroundColor: Colors.black38,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add_a_photo),
            tooltip: 'Adicionar álbum',
            onPressed: () {
              _addNewAlbumPhotos(context);
            },
          ),
        ],
      ),
      body: GridView.count(
        crossAxisCount: 1,
        childAspectRatio: (itemWidth / itemHeight),
        controller: ScrollController(keepScrollOffset: false),
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        children: _widgetList.map((String value) {
          return Container(
            color: Colors.black26,
            margin: const EdgeInsets.all(1.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Image(
                    image: NetworkImage(
                        'https://firebasestorage.googleapis.com/v0/b/joao-luiz-correa.appspot.com/o/photos%2F$value?alt=media'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 5, 20, 5),
                  child: FloatingActionButton(
                    mini: true,
                    onPressed: () => showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: const Text('Remover imagem'),
                        content: Text(
                            'Tem certeza que deseja remover a imagem\n$value?'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text(
                              'Cancelar',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16.0,
                                fontFamily: 'WorkSansMedium',
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              _removePicture(value);
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'Excluir',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 16.0,
                                fontFamily: 'WorkSansMedium',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    tooltip: 'Remover imagem',
                    child: const Icon(Icons.close),
                    backgroundColor: Colors.red,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
