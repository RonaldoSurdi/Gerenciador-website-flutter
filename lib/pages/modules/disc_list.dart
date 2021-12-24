import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:hwscontrol/core/components/snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:file_picker/file_picker.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:hwscontrol/core/models/sound_model.dart';

class DiscList extends StatefulWidget {
  final String idDisc;
  final String titleDisc;
  const DiscList({
    Key? key,
    required this.idDisc,
    required this.titleDisc,
  }) : super(key: key);

  @override
  _DiscListState createState() => _DiscListState();
}

class _DiscListState extends State<DiscList> {
  final TextEditingController _trackController = MaskedTextController(
    mask: '00',
    text: '00',
  );
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _infoController = TextEditingController();
  final TextEditingController _movieController = TextEditingController();
  final TextEditingController _lyricController = TextEditingController();
  final TextEditingController _cipherController = TextEditingController();
  int? _trackValue;
  String? _titleValue;
  String? _infoValue;
  String? _movieValue;
  String? _lyricValue;
  String? _cipherValue;

  final List<SoundModel> _widgetList = [];

  // seleciona a música do computador
  Future _selectSound(idSound) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp3'],
    );

    if (result != null) {
      Uint8List? fileBytes = result.files.first.bytes;
      String? fileName = result.files.first.name;
      String? fileExt = result.files.first.extension;
      String? filePut = '${idSound.toString().padLeft(2, '0')}$fileExt';

      // Upload file
      await firebase_storage.FirebaseStorage.instance
          .ref('discs/${widget.idDisc.toString().padLeft(5, '0')}/$filePut')
          .putData(fileBytes!);

      setState(() {
        CustomSnackBar(
          context,
          Text("Música importada com sucesso.\n$fileName"),
        );
        Timer(const Duration(milliseconds: 1500), () {
          _onGetData();
        });
      });
    }
  }

  Future<void> _addNewSound(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (builder, setState) => AlertDialog(
            title: const Text('Adicionar música'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  onChanged: (value) {
                    setState(() {
                      _trackValue = value as int?;
                    });
                  },
                  controller: _trackController,
                  keyboardType: TextInputType.number,
                  maxLength: 2,
                  decoration: const InputDecoration(
                    hintText: "Track",
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
                      _movieValue = value;
                    });
                  },
                  controller: _movieController,
                  maxLength: 100,
                  decoration: const InputDecoration(
                    hintText: "Url Youtube (opcional)",
                  ),
                ),
                TextField(
                  onChanged: (value) {
                    setState(() {
                      _lyricValue = value;
                    });
                  },
                  controller: _lyricController,
                  maxLength: 100,
                  decoration: const InputDecoration(
                    hintText: "Url Letra (opcional)",
                  ),
                ),
                TextField(
                  onChanged: (value) {
                    setState(() {
                      _cipherValue = value;
                    });
                  },
                  controller: _cipherController,
                  maxLength: 100,
                  decoration: const InputDecoration(
                    hintText: "Url Cifra (opcional)",
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
                  _saveData(
                    _trackValue,
                    _titleValue,
                    _infoValue,
                    _movieValue,
                    _lyricValue,
                    _cipherValue,
                  );
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
  Future _saveData(
    _trackValue,
    _titleValue,
    _infoValue,
    _movieValue,
    _lyricValue,
    _cipherValue,
  ) async {
    if (_trackValue.trim().isNotEmpty &&
        _trackValue.trim().length >= 1 &&
        _titleValue.trim().isNotEmpty &&
        _titleValue.trim().length >= 3) {
      _onSaveData(
        _trackValue,
        _titleValue,
        _infoValue,
        _movieValue,
        _lyricValue,
        _cipherValue,
      );
    } else {
      CustomSnackBar(
          context, const Text('Preencha todos dados e tente novamente!'),
          backgroundColor: Colors.red);
    }
    return Future.value(true);
  }

  Future _onSaveData(
    _trackValue,
    _titleValue,
    _infoValue,
    _movieValue,
    _lyricValue,
    _cipherValue,
  ) async {
    SoundModel soundModel = SoundModel(
      track: _trackValue,
      title: _titleValue,
      info: _infoValue,
      movie: _movieValue,
      lyric: _lyricValue,
      cipher: _cipherValue,
      audio: null,
    );

    FirebaseFirestore db = FirebaseFirestore.instance;
    db
        .collection("discs")
        .doc(widget.idDisc.toString().padLeft(5, '0'))
        .collection("sounds")
        .doc(_trackValue.toString().padLeft(2, '0'))
        .set(soundModel.toMap());

    setState(() {
      CustomSnackBar(context, const Text("Música adicionada com sucesso."));
      Timer(const Duration(milliseconds: 1500), () {
        _onGetData();
      });
    });

    return Future.value(true);
  }

  Future _removeSound(idSound) async {
    await FirebaseFirestore.instance
        .collection("discs")
        .doc(widget.idDisc.toString().padLeft(5, '0'))
        .collection("sounds")
        .doc(idSound.toString().padLeft(2, '0'))
        .delete();

    await firebase_storage.FirebaseStorage.instance
        .ref('discs/${widget.idDisc.toString().padLeft(5, '0')}')
        .child('${idSound.toString().padLeft(2, '0')}.mp3')
        .delete();

    setState(() {
      CustomSnackBar(context, const Text("Música excluida com sucesso."));
      Timer(const Duration(milliseconds: 500), () {
        _onGetData();
      });
    });
  }

  Future _onGetData() async {
    _widgetList.clear();
    FirebaseFirestore db = FirebaseFirestore.instance;
    var data = await db.collection("discs").orderBy('id').get();
    var response = data.docs;
    for (int i = 0; i < response.length; i++) {
      setState(() {
        SoundModel soundModel = SoundModel(
          track: response[i]["track"],
          title: response[i]["title"],
          info: response[i]["info"].toString().replaceAll('null', ''),
          movie: response[i]["movie"].toString().replaceAll('null', ''),
          lyric: response[i]["lyric"].toString().replaceAll('null', ''),
          cipher: response[i]["cipher"].toString().replaceAll('null', ''),
          audio: response[i]["audio"].toString().replaceAll('null', ''),
        );
        _widgetList.add(soundModel);
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
        title: Text(
          '${widget.idDisc.padLeft(5, '0')} - ${widget.titleDisc.toUpperCase()}',
        ),
        backgroundColor: Colors.black38,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            iconSize: 40,
            color: Colors.amber,
            splashColor: Colors.yellow,
            tooltip: 'Adicionar música',
            onPressed: () {
              _addNewSound(context);
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
        children: _widgetList.map((SoundModel value) {
          return Container(
            color: Colors.black26,
            margin: const EdgeInsets.all(1.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(5, 5, 10, 5),
                  child: Text(
                    value.track.toString().padLeft(2, '0'),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14.0,
                      fontFamily: 'WorkSansLigth',
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
                        fontSize: 14.0,
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
                      tooltip: 'Adicionar música',
                      child: const Icon(Icons.add_a_photo),
                      backgroundColor: Colors.green,
                      onPressed: () => _selectSound(value.track),
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
                      tooltip: 'Remover música',
                      child: const Icon(Icons.close),
                      backgroundColor: Colors.red,
                      onPressed: () => showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text('Remover música'),
                          content: Text(
                              'Tem certeza que deseja remover a música\n${value.track.toString().padLeft(2, '0')} - ${value.title}?'),
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
                                _removeSound(value.track);
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
