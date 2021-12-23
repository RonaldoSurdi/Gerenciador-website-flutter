import 'package:flutter/material.dart';
import 'dart:async';
import 'package:hwscontrol/core/components/snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';
import 'package:hwscontrol/core/models/discography_model.dart';

class Discography extends StatefulWidget {
  const Discography({Key? key}) : super(key: key);

  @override
  _DiscographyState createState() => _DiscographyState();
}

class _DiscographyState extends State<Discography> {
  final _picker = ImagePicker();
  List<XFile>? _imageFileList;

  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _musicsController = TextEditingController();
  int? _numberValue;
  String? _titleValue;
  String? _dataValue;
  String? _descriptionValue;
  String? _musicsValue;

  final List<DiscographyModel> _widgetList = [];
  set _imageFile(XFile? value) {
    _imageFileList = value == null ? null : [value];
  }

  // seleciona a música do computador
  Future _selectPicture(idDisco) async {
    try {
      final image = await _picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        setState(() {
          _imageFile = image;
        });
        _uploadImage(idDisco);
      }
    } catch (e) {
      //
    }
  }

  // faz o envio da música para o storage
  Future _uploadImage(idDisco) async {
    String fileName = _imageFileList![0].name;
    String filePath = _imageFileList![0].path;

    firebase_storage.UploadTask uploadTask;

    firebase_storage.Reference arquive = firebase_storage
        .FirebaseStorage.instance
        .ref()
        .child("discos")
        .child(idDisco)
        .child(fileName);

    final metadata = firebase_storage.SettableMetadata(
      contentType: '${_imageFileList![0].mimeType}',
      customMetadata: {'picked-file-path': filePath},
    );

    uploadTask =
        arquive.putData(await _imageFileList![0].readAsBytes(), metadata);

    setState(() {
      CustomSnackBar(context, Text("Capa importada com sucesso.\n$fileName"));
      Timer(const Duration(milliseconds: 1500), () {
        _onGetData();
      });
    });

    return Future.value(uploadTask);
  }

  Future<void> _addNewDiscography(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (builder, setState) => AlertDialog(
            title: const Text('Adicionar novo disco'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  onChanged: (value) {
                    setState(() {
                      _numberValue = value as int?;
                    });
                  },
                  controller: _numberController,
                  maxLength: 4,
                  decoration:
                      const InputDecoration(hintText: "Número do álbum"),
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      _numberValue = value as int?;
                    });
                  },
                  controller: _titleController,
                  maxLength: 100,
                  decoration:
                      const InputDecoration(hintText: "Título do álbum"),
                ),
                TextField(
                  onChanged: (value) {
                    setState(() {
                      _dataValue = value;
                    });
                  },
                  controller: _dateController,
                  maxLength: 100,
                  decoration:
                      const InputDecoration(hintText: "Ano do lançamento"),
                ),
                TextField(
                  onChanged: (value) {
                    setState(() {
                      _descriptionValue = value;
                    });
                  },
                  controller: _descriptionController,
                  maxLength: 16,
                  maxLines: 5,
                  decoration:
                      const InputDecoration(hintText: "Informações (opcional)"),
                ),
                TextField(
                  onChanged: (value) {
                    setState(() {
                      _musicsValue = value;
                    });
                  },
                  controller: _musicsController,
                  maxLength: 16,
                  maxLines: 5,
                  decoration:
                      const InputDecoration(hintText: "Lista de músicas"),
                ),
              ],
            ),
            actions: <Widget>[
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
                  _saveData(_numberValue, _titleValue, _dataValue,
                      _descriptionValue, _musicsValue);
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
          ),
        );
      },
    );
  }

  // faz o envio da imagem para o storage
  Future _saveData(_numberValue, _titleValue, _dataValue, _descriptionValue,
      _musicsValue) async {
    if (_titleValue.trim().isNotEmpty && _titleValue.trim().length >= 3) {
      _onSaveData(_numberValue, _titleValue, _dataValue, _descriptionValue,
          _musicsValue);
    } else {
      CustomSnackBar(
          context, const Text('Preencha todos dados e tente novamente!'),
          backgroundColor: Colors.red);
    }
    return Future.value(true);
  }

  Future _onSaveData(_numberValue, _titleValue, _dataValue, _descriptionValue,
      _musicsValue) async {
    DiscographyModel discographyModel = DiscographyModel(
      number: _numberValue,
      title: _titleValue,
      date: _dataValue,
      description: _descriptionValue,
      filename: null,
      musics: _musicsValue,
    );

    FirebaseFirestore db = FirebaseFirestore.instance;
    db
        .collection("discography")
        .doc(_numberValue)
        .set(discographyModel.toMap());

    setState(() {
      CustomSnackBar(context, const Text("Disco adicionado com sucesso."));
      Timer(const Duration(milliseconds: 1500), () {
        _onGetData();
      });
    });

    return Future.value(true);
  }

  Future _removeDiscography(idDisco, _filenameValue) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    db.collection("discography").doc(idDisco).delete();

    firebase_storage.Reference arquive = firebase_storage
        .FirebaseStorage.instance
        .ref()
        .child("discos")
        .child(idDisco)
        .child(_filenameValue);

    arquive.delete();

    setState(() {
      CustomSnackBar(context, const Text("Disco excluido com sucesso."));
      Timer(const Duration(milliseconds: 500), () {
        _onGetData();
      });
    });
  }

  Future _onGetData() async {
    _widgetList.clear();
    FirebaseFirestore db = FirebaseFirestore.instance;
    var data = await db
        .collection("discography")
        .orderBy('id', descending: true)
        .get();
    var response = data.docs;
    for (int i = 0; i < response.length; i++) {
      setState(() {
        DiscographyModel discographyModel = DiscographyModel(
          number: response[i]["number"],
          title: response[i]["title"],
          date: response[i]["date"],
          description: response[i]["description"],
          filename: response[i]["filename"],
          musics: response[i]["musics"],
        );
        _widgetList.add(discographyModel);
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
    const double itemHeight = 100;

    return Scaffold(
      backgroundColor: const Color(0XFF666666),
      appBar: AppBar(
        title: const Text('Discografia'),
        backgroundColor: Colors.black38,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            iconSize: 40,
            color: Colors.amber,
            splashColor: Colors.yellow,
            tooltip: 'Adicionar disco',
            onPressed: () {
              _addNewDiscography(context);
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
        children: _widgetList.map((DiscographyModel value) {
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
                    borderRadius: BorderRadius.circular(16.0),
                    child: Image(
                      image: NetworkImage('${value.number}'),
                      fit: BoxFit.cover,
                      width: 100,
                      height: 70,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                      padding: const EdgeInsets.fromLTRB(5, 5, 10, 5),
                      child: Text(
                        '${value.title}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontFamily: 'WorkSansLigth',
                        ),
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                  child: SizedBox(
                    height: 40.0,
                    width: 40.0,
                    child: FloatingActionButton(
                      mini: false,
                      tooltip: 'Adicionar capa',
                      child: const Icon(Icons.add_a_photo),
                      backgroundColor: Colors.green,
                      onPressed: () => _selectPicture(value.number),
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
                      tooltip: 'Remover disco',
                      child: const Icon(Icons.close),
                      backgroundColor: Colors.red,
                      onPressed: () => showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text('Remover disco'),
                          content: Text(
                              'Tem certeza que deseja remover o disco\n${value.number} - ${value.title}?'),
                          actions: <Widget>[
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
                                _removeDiscography(
                                  value.number,
                                  value.filename,
                                );
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
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  now() {}
}
