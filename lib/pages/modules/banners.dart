import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hwscontrol/core/widgets/snackbar.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hwscontrol/core/models/banner_model.dart';
import 'package:image_picker/image_picker.dart';

class Banners extends StatefulWidget {
  const Banners({Key? key}) : super(key: key);

  @override
  _BannersState createState() => _BannersState();
}

class _BannersState extends State<Banners> {
  // variaveis da tela
  final _picker = ImagePicker();
  List<XFile>? _imageFileList;

  final List<String> _widgetList = [];

  set _imageFile(XFile? value) {
    _imageFileList = value == null ? null : [value];
  }

  // seleciona a imagem do computador
  Future _selectPicture() async {
    try {
      final image = await _picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        setState(() {
          _imageFile = image;
        });
        _uploadImage();
      }
    } catch (e) {
      //
    }
  }

  // faz o envio da imagem para o storage
  Future _uploadImage() async {
    DateTime now = DateTime.now();
    String dateNow = DateFormat('yyyyMMddkkmmss').format(now);

    String fileName = _imageFileList![0].name;
    String filePath = _imageFileList![0].path;
    String fileSave = '$dateNow-$fileName';

    firebase_storage.UploadTask uploadTask;

    firebase_storage.Reference arquive = firebase_storage
        .FirebaseStorage.instance
        .ref()
        .child("banners")
        .child(fileSave);

    final metadata = firebase_storage.SettableMetadata(
      contentType: '${_imageFileList![0].mimeType}',
      customMetadata: {'picked-file-path': filePath},
    );

    uploadTask =
        arquive.putData(await _imageFileList![0].readAsBytes(), metadata);

    BannerModel bannerModel = BannerModel(filename: fileSave, date: dateNow);

    FirebaseFirestore db = FirebaseFirestore.instance;
    db.collection("banners").doc(dateNow).set(bannerModel.toMap());

    setState(() {
      CustomSnackBar(context, Text("Imagem importada com sucesso.\n$fileName"));
      Timer(const Duration(milliseconds: 1500), () {
        _onGetData();
      });
    });

    return Future.value(uploadTask);
  }

  Future _removePicture(fileName) async {
    firebase_storage.Reference arquive = firebase_storage
        .FirebaseStorage.instance
        .ref()
        .child("banners")
        .child(fileName);

    arquive.delete();

    var dbDoc = fileName.toString().split('-');

    FirebaseFirestore db = FirebaseFirestore.instance;
    db.collection("banners").doc(dbDoc[0]).delete();
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
    var data = await db
        .collection("banners")
        .orderBy('filename', descending: true)
        .get();
    var response = data.docs;
    for (int i = 0; i < response.length; i++) {
      setState(() {
        print(response[i]["filename"]);
        _widgetList.add(response[i]["filename"]);
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
        title: const Text('Banners'),
        backgroundColor: Colors.black38,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add_a_photo),
            tooltip: 'Adicionar imagem',
            onPressed: () {
              _selectPicture();
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
                        'https://firebasestorage.googleapis.com/v0/b/joao-luiz-correa.appspot.com/o/banners%2F$value?alt=media'),
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
