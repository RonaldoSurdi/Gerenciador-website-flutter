import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hwscontrol/core/components/snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';
import 'package:hwscontrol/core/models/artist_model.dart';

class Artists extends StatefulWidget {
  const Artists({Key? key}) : super(key: key);

  @override
  _ArtistsState createState() => _ArtistsState();
}

class _ArtistsState extends State<Artists> {
  final _picker = ImagePicker();
  List<XFile>? _imageFileList;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _infoController = TextEditingController();

  final List<ArtistModel> _widgetList = [];

  set _imageFile(XFile? value) {
    _imageFileList = value == null ? null : [value];
  }

  Future _selectFile(idDisc) async {
    try {
      final image = await _picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        setState(() {
          _imageFile = image;
        });
        _uploadFile(idDisc);
      }
    } catch (e) {
      //
    }
  }

  Future _uploadFile(itemId) async {
    EasyLoading.showInfo(
      'enviando imagem...',
      maskType: EasyLoadingMaskType.custom,
    );

    String fileName = _imageFileList![0].name;
    String? filePut;
    String filePath = _imageFileList![0].path;

    if (fileName.contains('.jpg') || fileName.contains('.jpeg')) {
      filePut = 'image.jpg';
    } else if (fileName.contains('.png')) {
      filePut = 'image.png';
    } else if (fileName.contains('.gif')) {
      filePut = 'image.gif';
    } else {
      setState(() {
        closeLoading();
        CustomSnackBar(context, const Text('Formato da imagem inválido!'),
            backgroundColor: Colors.red);
      });
      return false;
    }

    firebase_storage.UploadTask uploadTask;

    firebase_storage.Reference arquive = firebase_storage
        .FirebaseStorage.instance
        .ref()
        .child("artists")
        .child(filePut);

    final metadata = firebase_storage.SettableMetadata(
      contentType: '${_imageFileList![0].mimeType}',
      customMetadata: {'picked-file-path': filePath},
    );

    uploadTask =
        arquive.putData(await _imageFileList![0].readAsBytes(), metadata);

    FirebaseFirestore db = FirebaseFirestore.instance;

    await db.collection("artists").doc(itemId).update({
      "image": filePut,
    });

    setState(() {
      Timer(const Duration(milliseconds: 1500), () {
        _getData();
      });
    });

    return Future.value(uploadTask);
  }

  Future<void> _addNew(BuildContext context, itemId, itemName, itemInfo) async {
    if (itemId == 0) {
      _nameController.text = '';
      _infoController.text = '';
    } else {
      _nameController.text = itemName;
      _infoController.text = itemInfo;
    }
    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (builder, setState) => AlertDialog(
            title:
                Text(itemId == 0 ? 'Adicionar artista' : 'Atualizar artista'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _nameController,
                  maxLength: 100,
                  decoration: const InputDecoration(
                    hintText: "Nome",
                  ),
                ),
                TextField(
                  controller: _infoController,
                  maxLines: 5,
                  decoration:
                      const InputDecoration(hintText: "Informações (opcional)"),
                ),
              ],
            ),
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
                  if (_nameController.text.isEmpty) {
                    CustomSnackBar(
                        context, const Text('Digite o nome do artista.'),
                        backgroundColor: Colors.red);
                  } else {
                    if (itemId == 0) {
                      _saveData(_nameController.text, _infoController.text);
                    } else {
                      _updateData(
                          itemId, _nameController.text, _infoController.text);
                    }
                    Navigator.pop(context);
                  }
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                  backgroundColor: Colors.green,
                  alignment: Alignment.center,
                ),
                child: const Text(
                  'Salvar',
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
      },
    );
  }

  Future _saveData(
    String _nameValue,
    String _infoValue,
  ) async {
    EasyLoading.showInfo(
      'gravando dados...',
      maskType: EasyLoadingMaskType.custom,
    );

    DateTime now = DateTime.now();
    String dateNow = DateFormat('yyyyMMddkkmmss').format(now);

    ArtistModel artistModel = ArtistModel(
      id: dateNow,
      name: _nameValue,
      info: _infoValue,
      image: '',
    );

    FirebaseFirestore db = FirebaseFirestore.instance;
    await db.collection("artists").doc(dateNow).set(artistModel.toMap());

    setState(() {
      Timer(const Duration(milliseconds: 1500), () {
        _getData();
      });
    });

    return Future.value(true);
  }

  Future _updateData(
    String _idValue,
    String _nameValue,
    String _infoValue,
  ) async {
    EasyLoading.showInfo(
      'atualizando dados...',
      maskType: EasyLoadingMaskType.custom,
    );

    FirebaseFirestore db = FirebaseFirestore.instance;
    await db.collection("artists").doc(_idValue).update({
      "name": _nameValue,
      "info": _infoValue,
    });

    setState(() {
      Timer(const Duration(milliseconds: 1500), () {
        _getData();
      });
    });

    return Future.value(true);
  }

  Future _removeData([String itemId = '', String itemImage = '']) async {
    EasyLoading.showSuccess(
      'removendo artista...',
      maskType: EasyLoadingMaskType.custom,
    );

    await FirebaseFirestore.instance.collection("artists").doc(itemId).delete();

    if (itemImage.isNotEmpty && itemImage != 'images%2Fdefault.jpg') {
      firebase_storage.Reference arquive = firebase_storage
          .FirebaseStorage.instance
          .ref()
          .child("artists")
          .child(itemImage);

      await arquive
          .listAll()
          .then((firebase_storage.ListResult listResult) async {
        if (listResult.items.isNotEmpty) {
          await arquive.delete();
        }
      });
    }

    setState(() {
      Timer(const Duration(milliseconds: 1500), () {
        _getData();
      });
    });
  }

  Future _getData() async {
    _widgetList.clear();
    FirebaseFirestore db = FirebaseFirestore.instance;
    var data = await db.collection("artists").orderBy('id').get();
    var response = data.docs;
    setState(() {
      if (response.isNotEmpty) {
        for (int i = 0; i < response.length; i++) {
          String? imageGet = response[i]["image"];
          String imageParse = 'images%2Fdefault.jpg';
          if (imageGet != '') {
            imageParse = 'artists%2F$imageGet';
          }

          ArtistModel artistModel = ArtistModel(
            id: response[i]["id"],
            name: response[i]["name"],
            info: response[i]["info"],
            image: imageParse,
          );
          _widgetList.add(artistModel);
        }
      }
      _nameController.text = '';
      _infoController.text = '';
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
    final double itemWidth = size.width;
    const double itemHeight = 100;

    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: const Text('Artistas'),
        backgroundColor: Colors.black38,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            iconSize: 40,
            color: Colors.amber,
            splashColor: Colors.yellow,
            tooltip: 'Adicionar artista',
            onPressed: () {
              _addNew(context, 0, '', '');
            },
          ),
        ],
      ),
      body: _widgetList.isNotEmpty
          ? GridView.count(
              crossAxisCount: 1,
              childAspectRatio: (itemWidth / itemHeight),
              controller: ScrollController(keepScrollOffset: false),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              children: _widgetList.map((ArtistModel value) {
                return Container(
                  color: Colors.black26,
                  margin: const EdgeInsets.all(1.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        height: 70,
                        padding: const EdgeInsets.fromLTRB(15, 5, 5, 5),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Image(
                            image: NetworkImage(
                                'https://firebasestorage.googleapis.com/v0/b/joao-luiz-correa.appspot.com/o/${value.image}?alt=media'),
                            fit: BoxFit.fitWidth,
                            width: 70,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(5, 5, 10, 5),
                          child: Text(
                            '${value.name}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontFamily: 'WorkSansLigth',
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                        child: SizedBox(
                          height: 40.0,
                          width: 40.0,
                          child: FloatingActionButton(
                            mini: false,
                            tooltip: 'Adicionar imagem',
                            child: const Icon(Icons.add_a_photo),
                            backgroundColor: Colors.green,
                            onPressed: () => _selectFile(value.id),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                        child: SizedBox(
                          height: 40.0,
                          width: 40.0,
                          child: FloatingActionButton(
                            mini: false,
                            tooltip: 'Editar dados',
                            child: const Icon(Icons.edit),
                            backgroundColor: Colors.blue,
                            onPressed: () => _addNew(
                              context,
                              value.id,
                              value.name,
                              value.info,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(5, 5, 15, 5),
                        child: SizedBox(
                          height: 25.0,
                          width: 25.0,
                          child: FloatingActionButton(
                            mini: true,
                            tooltip: 'Remover artista',
                            child: const Icon(Icons.close),
                            backgroundColor: Colors.red,
                            onPressed: () => showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: const Text('Remover artista'),
                                content: Text(
                                    'Tem certeza que deseja remover o artista\n${value.name}?'),
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
                                      _removeData(value.id!, value.image!);
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
    );
  }
}
