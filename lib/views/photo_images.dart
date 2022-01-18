import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hwscontrol/core/components/snackbar.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:decorated_icon/decorated_icon.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hwscontrol/core/models/photo_image_model.dart';

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
  List<XFile>? _imageFileList;

  final List<PhotoImageModel> _widgetList = [];

  set _imageFile(XFile? value) {
    _imageFileList = value == null ? null : [value];
  }

  // seleciona a imagem do computador
  Future _selectFile() async {
    try {
      final image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxHeight: 1600,
        maxWidth: 1080,
        imageQuality: 90,
      );

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
      'gravando dados...',
      maskType: EasyLoadingMaskType.custom,
      dismissOnTap: false,
      duration: const Duration(seconds: 10),
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
      Timer(const Duration(milliseconds: 500), () {
        _getData();
      });
    });

    return Future.value(uploadTask);
  }

  _dialogDelete(PhotoImageModel value) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Remover imagem'),
        content:
            Text('Tem certeza que deseja remover a imagem\n${value.image}?'),
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
              _removeFile('${value.image}');
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

    //print(arquive);
    firebase_storage.ListResult listImages = await arquive.listAll();
    setState(() {
      for (int i = 0; i < listImages.items.length; i++) {
        String imageItem = listImages.items[i].fullPath;
        imageItem = imageItem.replaceAll('/', '%2F');

        PhotoImageModel photoImageModel = PhotoImageModel(
          id: i.toString(),
          image: imageItem,
        );

        _widgetList.add(photoImageModel);
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
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double imageSize = size.width / 1;
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: Text(widget.itemTitle),
        backgroundColor: Colors.black38,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_photo_alternate_outlined),
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
                childAspectRatio: 1,
                controller: ScrollController(keepScrollOffset: false),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                children: _widgetList.map((PhotoImageModel value) {
                  return Container(
                    color: Colors.transparent,
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Image(
                            image: NetworkImage(
                                'https://firebasestorage.googleapis.com/v0/b/joao-luiz-correa.appspot.com/o/${value.image}?alt=media'),
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
                                heroTag: "remove_${value.image}",
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
