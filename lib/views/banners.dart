import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:decorated_icon/decorated_icon.dart';
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
  Future _selectFile() async {
    try {
      final image = await _picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        setState(() {
          _imageFile = image;
        });
        _uploadFile();
      }
    } catch (e) {
      //
    }
  }

  Future _uploadFile() async {
    EasyLoading.showInfo(
      'enviando imagem...',
      maskType: EasyLoadingMaskType.custom,
      dismissOnTap: false,
      duration: const Duration(seconds: 10),
    );
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
      Timer(const Duration(milliseconds: 500), () {
        _getData();
      });
    });

    return Future.value(uploadTask);
  }

  _dialogDelete(String value) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Remover imagem'),
        content: Text('Tem certeza que deseja remover a imagem\n$value?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
              alignment: Alignment.center,
            ),
            child: const Text(
              'Cancelar',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16.0,
                fontFamily: 'WorkSansMedium',
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              _removeFile(value);
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(
              padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
              backgroundColor: Colors.red,
              alignment: Alignment.center,
            ),
            child: const Text(
              'Excluir',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
                fontFamily: 'WorkSansMedium',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future _removeFile(fileName) async {
    EasyLoading.showInfo(
      'removendo imagem...',
      maskType: EasyLoadingMaskType.custom,
      dismissOnTap: false,
      duration: const Duration(seconds: 10),
    );
    firebase_storage.Reference arquive = firebase_storage
        .FirebaseStorage.instance
        .ref()
        .child("banners")
        .child(fileName);

    await arquive.delete();

    var dbDoc = fileName.toString().split('-');

    FirebaseFirestore db = FirebaseFirestore.instance;
    db.collection("banners").doc(dbDoc[0]).delete();
    setState(() {
      Timer(const Duration(milliseconds: 500), () {
        _getData();
      });
    });
  }

  Future _getData() async {
    _widgetList.clear();
    FirebaseFirestore db = FirebaseFirestore.instance;

    var data = await db
        .collection("banners")
        .orderBy('filename', descending: true)
        .get();

    setState(() {
      var response = data.docs;
      for (int i = 0; i < response.length; i++) {
        _widgetList.add(response[i]["filename"]);
      }
      closeLoading();
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
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    int gritCol = 4;
    int sizeCol = MediaQuery.of(context).size.width.toInt();
    double widthCol = MediaQuery.of(context).size.width;
    double heightCol = widthCol / 4;
    if (sizeCol >= 1500) {
      gritCol = 4;
    } else if (sizeCol >= 600) {
      gritCol = 3;
    } else if (sizeCol >= 200) {
      gritCol = 2;
    } else {
      gritCol = 1;
    }
    widthCol = widthCol / gritCol;
    heightCol = widthCol / 2;
    /*24 is for notification bar on Android*/
    // final double itemHeight = (size.height - kToolbarHeight - 24) / 2;

    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: const Text('Banners'),
        backgroundColor: Colors.black38,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_a_photo),
            iconSize: 40,
            color: Colors.amber,
            splashColor: Colors.yellow,
            tooltip: 'Adicionar imagem',
            onPressed: () {
              _selectFile();
            },
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: GridView.count(
          crossAxisCount: gritCol,
          childAspectRatio: (widthCol / heightCol),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          controller: ScrollController(keepScrollOffset: false),
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          children: _widgetList.map((String value) {
            return Container(
              color: Colors.transparent,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image(
                      image: NetworkImage(
                          'https://firebasestorage.googleapis.com/v0/b/joao-luiz-correa.appspot.com/o/banners%2F$value?alt=media'),
                      fit: BoxFit.fitWidth,
                      width: widthCol,
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                      child: SizedBox(
                        height: 25.0,
                        width: 25.0,
                        child: FloatingActionButton(
                          heroTag: 'remove_$value',
                          mini: true,
                          tooltip: 'Remover imagem',
                          child: DecoratedIcon(
                            Icons.delete_forever,
                            color: Colors.grey.shade300,
                            size: 20.0,
                            shadows: const [
                              BoxShadow(
                                color: Colors.black54,
                                offset: Offset(2.0, 2.0),
                              ),
                            ],
                          ),
                          elevation: 0,
                          disabledElevation: 0,
                          highlightElevation: 0,
                          focusElevation: 0,
                          hoverElevation: 0,
                          backgroundColor: Colors.transparent,
                          onPressed: () => _dialogDelete(value),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
