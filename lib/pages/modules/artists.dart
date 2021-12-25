import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hwscontrol/core/components/snackbar.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';

class Artists extends StatefulWidget {
  const Artists({Key? key}) : super(key: key);

  @override
  _ArtistsState createState() => _ArtistsState();
}

class _ArtistsState extends State<Artists> {
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

  // faz o envio da imagem para o storage
  Future _uploadFile() async {
    String fileName = _imageFileList![0].name;
    String filePath = _imageFileList![0].path;

    firebase_storage.UploadTask uploadTask;

    firebase_storage.Reference arquive = firebase_storage
        .FirebaseStorage.instance
        .ref()
        .child("artists")
        .child(fileName);

    final metadata = firebase_storage.SettableMetadata(
      contentType: '${_imageFileList![0].mimeType}',
      customMetadata: {'picked-file-path': filePath},
    );

    uploadTask =
        arquive.putData(await _imageFileList![0].readAsBytes(), metadata);

    setState(() {
      CustomSnackBar(context, Text("Foto importada com sucesso.\n$fileName"));
      Timer(const Duration(milliseconds: 1500), () {
        _getData();
      });
    });

    return Future.value(uploadTask);
  }

  Future _removeFile(fileName) async {
    firebase_storage.Reference arquive = firebase_storage
        .FirebaseStorage.instance
        .ref()
        .child("artists")
        .child(fileName);

    await arquive.delete();

    setState(() {
      CustomSnackBar(context, Text("Foto excluida com sucesso.\n$fileName"));
      Timer(const Duration(milliseconds: 500), () {
        _getData();
      });
    });
  }

  Future _getData() async {
    _widgetList.clear();

    firebase_storage.Reference arquive =
        firebase_storage.FirebaseStorage.instance.ref().child("artists");

    arquive.listAll().then((firebase_storage.ListResult listResult) {
      for (int i = 0; i < listResult.items.length; i++) {
        setState(() {
          String imageItem = listResult.items[i].fullPath;
          imageItem = imageItem.replaceAll('/', '%2F');
          _widgetList.add(imageItem);
        });
      }
    });
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
    var size = MediaQuery.of(context).size;
    final double imageSize = size.width / 3;
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: const Text('Artistas'),
        backgroundColor: Colors.black38,
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add_alt),
            iconSize: 40,
            color: Colors.amber,
            splashColor: Colors.yellow,
            tooltip: 'Adicionar foto',
            onPressed: () {
              _selectFile();
            },
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: GridView.count(
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1.8,
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
                          'https://firebasestorage.googleapis.com/v0/b/joao-luiz-correa.appspot.com/o/$value?alt=media'),
                      fit: BoxFit.fitWidth,
                      width: imageSize,
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
                          mini: true,
                          elevation: 2,
                          tooltip: 'Remover artista',
                          child: const Icon(Icons.close),
                          backgroundColor: Colors.red,
                          onPressed: () => showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: const Text('Remover foto'),
                              content: Text(
                                  'Tem certeza que deseja remover a artista\n$value?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
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
