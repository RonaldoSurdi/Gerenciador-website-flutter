import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hwscontrol/core/components/snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:file_picker/file_picker.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:hwscontrol/core/models/download_model.dart';

class Downloads extends StatefulWidget {
  const Downloads({Key? key}) : super(key: key);

  @override
  _DownloadsState createState() => _DownloadsState();
}

class _DownloadsState extends State<Downloads> {
  final TextEditingController _trackController = MaskedTextController(
    mask: '00',
    text: '',
  );
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _fileController = TextEditingController();

  final List<DownloadModel> _widgetList = [];

  // seleciona o arquivo do computador
  Future _selectSound(idFile) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'zip',
        'rar',
        'pdf',
        'doc',
        'docx',
        'jpg',
        'png',
        'psd',
        'cdr',
        'mp3',
      ],
    );

    if (result != null) {
      EasyLoading.showInfo(
        'enviando arquivo...',
        maskType: EasyLoadingMaskType.custom,
      );

      Uint8List? fileBytes = result.files.first.bytes;
      //String? fileName = result.files.first.name;
      String? fileExt = result.files.first.extension;
      String? filePut = '$idFile$fileExt';

      // Upload file
      await firebase_storage.FirebaseStorage.instance
          .ref('downloads/$filePut')
          .putData(fileBytes!);

      FirebaseFirestore db = FirebaseFirestore.instance;

      await db.collection("downloads").doc(idFile).update({
        "file": filePut,
      });

      setState(() {
        Timer(const Duration(milliseconds: 1500), () {
          _getData();
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
            title: const Text('Adicionar arquivo'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _titleController,
                  maxLength: 100,
                  decoration: const InputDecoration(
                    hintText: "Título",
                  ),
                ),
                TextField(
                  controller: _fileController,
                  maxLength: 200,
                  decoration: const InputDecoration(
                    hintText: "Url Arquivo (opcional https://...)",
                  ),
                ),
                TextField(
                  controller: _descriptionController,
                  maxLines: 3,
                  decoration:
                      const InputDecoration(hintText: "Descrição (opcional)"),
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
                  if (_titleController.text.isEmpty) {
                    CustomSnackBar(context, const Text('Digite o título.'),
                        backgroundColor: Colors.red);
                  } else {
                    _saveData(
                      _titleController.text,
                      _fileController.text,
                      _descriptionController.text,
                    );
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

  // faz o envio da imagem para o storage
  Future _saveData(
    String _titleValue,
    String _fileValue,
    String _descriptionValue,
  ) async {
    EasyLoading.showInfo(
      'gravando dados...',
      maskType: EasyLoadingMaskType.custom,
    );

    DateTime now = DateTime.now();
    String dateNow = DateFormat('yyyyMMddkkmmss').format(now);

    DownloadModel downloadModel = DownloadModel(
      id: dateNow,
      title: _titleValue,
      description: _descriptionValue,
      file: _fileValue,
    );

    FirebaseFirestore db = FirebaseFirestore.instance;
    db.collection("downloads").doc(dateNow).set(downloadModel.toMap());

    setState(() {
      Timer(const Duration(milliseconds: 1500), () {
        _getData();
      });
    });

    return Future.value(true);
  }

  Future _removeData(itemId, itemFile) async {
    EasyLoading.showSuccess(
      'removendo arquivo...',
      maskType: EasyLoadingMaskType.custom,
    );

    if (itemFile.isNotEmpty) {
      await FirebaseFirestore.instance
          .collection("downloads")
          .doc(itemId)
          .delete();

      await firebase_storage.FirebaseStorage.instance
          .ref("downloads")
          .child(itemFile)
          .delete();
    }

    setState(() {
      Timer(const Duration(milliseconds: 500), () {
        _getData();
      });
    });
  }

  Future _getData() async {
    _widgetList.clear();
    FirebaseFirestore db = FirebaseFirestore.instance;
    var data = await db.collection("downloads").orderBy('id').get();
    var response = data.docs;
    setState(() {
      if (response.isNotEmpty) {
        _trackController.text = (response.length + 1).toString();
        for (int i = 0; i < response.length; i++) {
          String uri = response[i]["file"].toString().replaceAll('null', '');
          if (!uri.contains("https://") && !uri.contains("http://")) {
            uri =
                'https://firebasestorage.googleapis.com/v0/b/joao-luiz-correa.appspot.com/o/downloads%2F$uri?alt=media';
          }
          DownloadModel downloadModel = DownloadModel(
            id: response[i]["id"],
            title: response[i]["title"],
            description: response[i]["description"],
            file: uri,
          );
          _widgetList.add(downloadModel);
        }
      } else {
        _trackController.text = '1';
      }
      _titleController.text = '';
      _descriptionController.text = '';
      _fileController.text = '';
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
        title: const Text(
          'Downloads',
        ),
        backgroundColor: Colors.black38,
        actions: [
          IconButton(
            icon: const Icon(Icons.cloud_upload_rounded),
            iconSize: 40,
            color: Colors.amber,
            splashColor: Colors.yellow,
            tooltip: 'Adicionar arquivo',
            onPressed: () {
              _addNewSound(context);
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
              children: _widgetList.map((DownloadModel value) {
                return Container(
                  color: Colors.black26,
                  margin: const EdgeInsets.all(1.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        padding: const EdgeInsets.fromLTRB(25, 5, 5, 5),
                        child: Text(
                          '${value.title}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontFamily: 'WorkSansLigth',
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(10, 5, 5, 5),
                          child: Text(
                            '${value.file}',
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
                            tooltip: 'Enviar arquivo',
                            child: const Icon(Icons.upload),
                            backgroundColor: Colors.grey,
                            onPressed: () => setState(() {
                              _selectSound(value.id);
                            }),
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
                            tooltip: 'Remover arquivo',
                            child: const Icon(Icons.close),
                            backgroundColor: Colors.red,
                            onPressed: () => showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: const Text('Remover arquivo'),
                                content: Text(
                                    'Tem certeza que deseja remover o arquivo\n${value.title}\n${value.file}?'),
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
                                      _removeData(value.id, value.file);
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
