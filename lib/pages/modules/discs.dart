import 'package:flutter/material.dart';
import 'dart:async';
import 'package:hwscontrol/core/components/snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:hwscontrol/pages/modules/disc_list.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:hwscontrol/core/models/disc_model.dart';

class Discs extends StatefulWidget {
  const Discs({Key? key}) : super(key: key);

  @override
  _DiscsState createState() => _DiscsState();
}

class _DiscsState extends State<Discs> {
  final _picker = ImagePicker();
  List<XFile>? _imageFileList;
  final TextEditingController _idController = MaskedTextController(
    mask: '000',
    text: '000',
  );
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _yearController = MaskedTextController(
    mask: '0000',
    text: '2022',
  );
  final TextEditingController _infoController = TextEditingController();
  int? _idValue;
  String? _titleValue;
  int? _yearValue;
  String? _infoValue;

  final List<DiscModel> _widgetList = [];

  set _imageFile(XFile? value) {
    _imageFileList = value == null ? null : [value];
  }

  // seleciona a música do computador
  Future _selectPicture(idDisc) async {
    try {
      final image = await _picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        setState(() {
          _imageFile = image;
        });
        _uploadImage(idDisc);
      }
    } catch (e) {
      //
    }
  }

  // faz o envio da música para o storage
  Future _uploadImage(idDisc) async {
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
        CustomSnackBar(context, const Text('Formato da imagem inválido!'),
            backgroundColor: Colors.red);
      });
      return false;
    }

    firebase_storage.UploadTask uploadTask;

    firebase_storage.Reference arquive = firebase_storage
        .FirebaseStorage.instance
        .ref()
        .child("discs")
        .child(idDisc.toString().padLeft(5, '0'))
        .child(filePut);

    final metadata = firebase_storage.SettableMetadata(
      contentType: '${_imageFileList![0].mimeType}',
      customMetadata: {'picked-file-path': filePath},
    );

    uploadTask =
        arquive.putData(await _imageFileList![0].readAsBytes(), metadata);

    FirebaseFirestore db = FirebaseFirestore.instance;

    await db.collection("discs").doc(idDisc.toString().padLeft(5, '0')).update({
      "image": filePut,
    });

    setState(() {
      CustomSnackBar(context, Text("Capa importada com sucesso.\n$fileName"));
      Timer(const Duration(milliseconds: 1500), () {
        _onGetData();
      });
    });

    return Future.value(uploadTask);
  }

  Future<void> _addNewDisc(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (builder, setState) => AlertDialog(
            title: const Text('Adicionar álbum'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  onChanged: (value) {
                    setState(() {
                      _idValue = value as int?;
                    });
                  },
                  controller: _idController,
                  keyboardType: TextInputType.number,
                  maxLength: 3,
                  decoration: const InputDecoration(
                    hintText: "Número",
                  ),
                ),
                TextField(
                  onChanged: (value) {
                    setState(() {
                      _titleValue = value;
                    });
                  },
                  controller: _titleController,
                  maxLength: 100,
                  decoration: const InputDecoration(
                    hintText: "Título",
                  ),
                ),
                TextField(
                  onChanged: (value) {
                    setState(() {
                      _yearValue = value as int?;
                    });
                  },
                  controller: _yearController,
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                  decoration: const InputDecoration(
                    hintText: "Lançamento",
                  ),
                ),
                TextField(
                  onChanged: (value) {
                    setState(() {
                      _infoValue = value;
                    });
                  },
                  controller: _infoController,
                  maxLength: 16,
                  maxLines: 5,
                  decoration:
                      const InputDecoration(hintText: "Informações (opcional)"),
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
                  _saveData(_idValue, _titleValue, _yearValue, _infoValue);
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
  Future _saveData(_idValue, _titleValue, _yearValue, _infoValue) async {
    if (_idValue.trim().isNotEmpty &&
        _idValue.trim().length >= 1 &&
        _titleValue.trim().isNotEmpty &&
        _titleValue.trim().length >= 3 &&
        _yearValue.trim().isNotEmpty &&
        _yearValue.trim().length == 4) {
      _onSaveData(_idValue, _titleValue, _yearValue, _infoValue);
    } else {
      CustomSnackBar(
          context, const Text('Preencha todos dados e tente novamente!'),
          backgroundColor: Colors.red);
    }
    return Future.value(true);
  }

  Future _onSaveData(_idValue, _titleValue, _yearValue, _infoValue) async {
    DiscModel discModel = DiscModel(
      id: _idValue,
      title: _titleValue,
      year: _yearValue,
      info: _infoValue,
      image: null,
    );

    FirebaseFirestore db = FirebaseFirestore.instance;
    db
        .collection("discs")
        .doc(_idValue.toString().padLeft(5, '0'))
        .set(discModel.toMap());

    setState(() {
      CustomSnackBar(context, const Text("Álbum adicionado com sucesso."));
      Timer(const Duration(milliseconds: 1500), () {
        _onGetData();
      });
    });

    return Future.value(true);
  }

  Future _removeDisc(idDisc) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    db.collection("discs").doc(idDisc.toString().padLeft(5, '0')).delete();

    firebase_storage.Reference arquive = firebase_storage
        .FirebaseStorage.instance
        .ref()
        .child("discs")
        .child(idDisc.toString().padLeft(5, '0'));

    arquive.delete();

    setState(() {
      CustomSnackBar(context, const Text("Álbum excluido com sucesso."));
      Timer(const Duration(milliseconds: 500), () {
        _onGetData();
      });
    });
  }

  Future _redirectDisc(idDisc, titleDisc) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (builder) => DiscList(
          idDisc: idDisc,
          titleDisc: titleDisc,
        ),
      ),
    );
  }

  Future _onGetData() async {
    _widgetList.clear();
    FirebaseFirestore db = FirebaseFirestore.instance;
    var data = await db.collection("discs").orderBy('id').get();
    var response = data.docs;
    for (int i = 0; i < response.length; i++) {
      setState(() {
        String imageGet = response[i]["image"];
        String imageParse = 'images%2Fdefault.jpg';
        if (imageGet.isNotEmpty) {
          imageParse = 'discs%2F${imageGet.toString().padLeft(5, '0')}';
        }
        String infoParse =
            response[i]["info"].toString().replaceAll('null', '');
        DiscModel discModel = DiscModel(
          id: response[i]["id"],
          title: response[i]["title"],
          year: response[i]["year"],
          info: infoParse,
          image: imageParse,
        );
        _widgetList.add(discModel);
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
            tooltip: 'Adicionar álbum',
            onPressed: () {
              _addNewDisc(context);
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
        children: _widgetList.map((DiscModel value) {
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
                      '${value.title}',
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
                      tooltip: 'Adicionar capa',
                      child: const Icon(Icons.add_a_photo),
                      backgroundColor: Colors.green,
                      onPressed: () => _selectPicture(value.id),
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
                      tooltip: 'Adicionar músicas',
                      child: const Icon(Icons.audiotrack_outlined),
                      backgroundColor: Colors.blue,
                      onPressed: () => _redirectDisc(value.id, value.title),
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
                      tooltip: 'Remover álbum',
                      child: const Icon(Icons.close),
                      backgroundColor: Colors.red,
                      onPressed: () => showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text('Remover álbum'),
                          content: Text(
                              'Tem certeza que deseja remover o álbum\n${value.id.toString().padLeft(2, '0')} - ${value.title}?'),
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
                                _removeDisc(value.id);
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
}
