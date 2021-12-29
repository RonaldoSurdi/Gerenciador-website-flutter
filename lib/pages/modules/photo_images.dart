import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hwscontrol/core/components/snackbar.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';

class PhotoImages extends StatefulWidget {
  final String itemId;
  final String itemTitle;
  const PhotoImages({
    Key? key,
    required this.itemId,
    required this.itemTitle,
  }) : super(key: key);

  @override
  _PhotoImagesState createState() => _PhotoImagesState();
}

class _PhotoImagesState extends State<PhotoImages> {
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
    EasyLoading.showInfo(
      'gravando dados...',
      maskType: EasyLoadingMaskType.custom,
    );

    String fileName = _imageFileList![0].name;
    String filePath = _imageFileList![0].path;

    firebase_storage.UploadTask uploadTask;

    firebase_storage.Reference arquive = firebase_storage
        .FirebaseStorage.instance
        .ref()
        .child("photos")
        .child(widget.itemId)
        .child(fileName);

    final metadata = firebase_storage.SettableMetadata(
      contentType: '${_imageFileList![0].mimeType}',
      customMetadata: {'picked-file-path': filePath},
    );

    uploadTask =
        arquive.putData(await _imageFileList![0].readAsBytes(), metadata);

    setState(() {
      Timer(const Duration(milliseconds: 1500), () {
        _getData();
      });
    });

    return Future.value(uploadTask);
  }

  Future _removeFile(fileName) async {
    EasyLoading.showInfo(
      'removendo imagem...',
      maskType: EasyLoadingMaskType.custom,
    );

    firebase_storage.Reference arquive = firebase_storage
        .FirebaseStorage.instance
        .ref()
        .child("photos")
        .child(widget.itemId)
        .child(fileName);

    await arquive.delete();

    setState(() {
      CustomSnackBar(context, Text("Imagem excluida com sucesso.\n$fileName"));
      Timer(const Duration(milliseconds: 500), () {
        _getData();
      });
    });
  }

  Future _getData() async {
    _widgetList.clear();

    firebase_storage.Reference arquive = firebase_storage
        .FirebaseStorage.instance
        .ref()
        .child("photos")
        .child(widget.itemId);

    setState(() {
      arquive.listAll().then((firebase_storage.ListResult listResult) {
        for (int i = 0; i < listResult.items.length; i++) {
          String imageItem = listResult.items[i].fullPath;
          imageItem = imageItem.replaceAll('/', '%2F');
          _widgetList.add(imageItem);
        }
      }).catchError((error) {});
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
        title: Text('Fotos ${widget.itemTitle}'),
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
        child: _widgetList.isNotEmpty
            ? GridView.count(
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
                                tooltip: 'Remover imagem',
                                child: const Icon(Icons.close),
                                backgroundColor: Colors.red,
                                onPressed: () => showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                    title: const Text('Remover imagem'),
                                    content: Text(
                                        'Tem certeza que deseja remover a imagem\n$value?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        style: TextButton.styleFrom(
                                          padding: const EdgeInsets.fromLTRB(
                                              15, 15, 15, 15),
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
                                          padding: const EdgeInsets.fromLTRB(
                                              20, 15, 20, 15),
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
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList())
            : Stack(
                alignment: Alignment.topCenter,
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(5, 20, 20, 5),
                    alignment: Alignment.center,
                    child: Text(
                      EasyLoading.isShow
                          ? 'sincronizando...'
                          : 'Nenhum registro cadastrado.',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontFamily: 'WorkSansLigth',
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
