import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hwscontrol/core/components/snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:hwscontrol/pages/modules/disc_sounds.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:hwscontrol/core/models/disc_model.dart';

class DiscAlbums extends StatefulWidget {
  const DiscAlbums({Key? key}) : super(key: key);

  @override
  _DiscAlbumsState createState() => _DiscAlbumsState();
}

class _DiscAlbumsState extends State<DiscAlbums> {
  final _picker = ImagePicker();
  List<XFile>? _imageFileList;
  final TextEditingController _idController = MaskedTextController(
    mask: '000',
    text: '',
  );
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _yearController = MaskedTextController(
    mask: '0000',
    text: '',
  );
  final TextEditingController _infoController = TextEditingController();

  final List<DiscModel> _widgetList = [];

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

  Future _uploadFile(num idDisc) async {
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
        if (EasyLoading.isShow) {
          Timer(const Duration(milliseconds: 2000), () {
            EasyLoading.dismiss(animation: true);
          });
        }
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
      Timer(const Duration(milliseconds: 1500), () {
        _getData();
      });
    });

    return Future.value(uploadTask);
  }

  Future<void> _addNew(BuildContext context) async {
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
                  controller: _idController,
                  keyboardType: TextInputType.number,
                  maxLength: 3,
                  decoration: const InputDecoration(
                    hintText: "Número",
                  ),
                ),
                TextField(
                  controller: _titleController,
                  maxLength: 100,
                  decoration: const InputDecoration(
                    hintText: "Título",
                  ),
                ),
                TextField(
                  controller: _yearController,
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                  decoration: const InputDecoration(
                    hintText: "Lançamento",
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
                  if (_idController.text.isEmpty) {
                    CustomSnackBar(
                        context, const Text('Digite o número do álbum.'),
                        backgroundColor: Colors.red);
                  } else if (_titleController.text.isEmpty) {
                    CustomSnackBar(
                        context, const Text('Digite o título do álbum.'),
                        backgroundColor: Colors.red);
                  } else if (_yearController.text.isEmpty) {
                    CustomSnackBar(context,
                        const Text('Digite o ano de lançamento do álbum.'),
                        backgroundColor: Colors.red);
                  } else if (num.parse(_yearController.text) > 1900 &&
                      num.parse(_yearController.text) >
                          (DateTime.now().year + 1)) {
                    CustomSnackBar(
                        context,
                        Text(
                            'O ano de lançamento deve estar entre 1900 e ${DateTime.now().year + 1}.'),
                        backgroundColor: Colors.red);
                  } else {
                    _saveData(
                        num.parse(_idController.text),
                        _titleController.text,
                        num.parse(_yearController.text),
                        _infoController.text);
                    Navigator.pop(context);
                  }
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

  Future _saveData(
    num _idValue,
    String _titleValue,
    num _yearValue,
    String _infoValue,
  ) async {
    EasyLoading.showInfo(
      'processando...',
      maskType: EasyLoadingMaskType.custom,
    );

    DiscModel discModel = DiscModel(
      id: _idValue,
      title: _titleValue,
      year: _yearValue,
      info: _infoValue,
      image: '',
    );

    FirebaseFirestore db = FirebaseFirestore.instance;
    await db
        .collection("discs")
        .doc(_idValue.toString().padLeft(5, '0'))
        .set(discModel.toMap());

    setState(() {
      Timer(const Duration(milliseconds: 1500), () {
        _getData();
      });
    });

    return Future.value(true);
  }

  Future _removeData([num itemId = 0, String itemImage = '']) async {
    EasyLoading.showSuccess(
      'processando...',
      maskType: EasyLoadingMaskType.custom,
    );

    await FirebaseFirestore.instance
        .collection("discs")
        .doc(itemId.toString().padLeft(5, '0'))
        .delete();

    if (itemImage.isNotEmpty && itemImage != 'images%2Fdefault.jpg') {
      firebase_storage.Reference arquive = firebase_storage
          .FirebaseStorage.instance
          .ref()
          .child("discs")
          .child(itemId.toString().padLeft(5, '0'));

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

  Future _redirectTo([
    num itemId = 0,
    String itemTitle = '',
    String itemImage = '',
  ]) async {
    if (itemImage.isEmpty || itemImage == 'images%2Fdefault.jpg') {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Remover álbum'),
          content: Text(
              'É necessário importar a capa para o álbum \n${itemId.toString().padLeft(2, '0')} - $itemTitle!'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Fechar',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16.0,
                  fontFamily: 'WorkSansMedium',
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (builder) => DiscSounds(
            itemId: itemId.toString().padLeft(5, '0'),
            itemTitle: itemTitle.toUpperCase(),
          ),
        ),
      );
    }
  }

  Future _getData() async {
    _widgetList.clear();
    FirebaseFirestore db = FirebaseFirestore.instance;
    var data = await db.collection("discs").orderBy('year').get();
    var response = data.docs;
    setState(() {
      if (response.isNotEmpty) {
        _idController.text = (response.length + 1).toString();
        _yearController.text =
            (response[response.length - 1]["year"] + 1).toString();
        for (int i = 0; i < response.length; i++) {
          String? idParse = response[i]["id"].toString().padLeft(5, '0');
          String? imageGet = response[i]["image"];
          String imageParse = 'images%2Fdefault.jpg';
          if (imageGet != '') {
            imageParse = 'discs%2F$idParse%2F$imageGet';
          }

          DiscModel discModel = DiscModel(
            id: response[i]["id"],
            title: response[i]["title"],
            year: response[i]["year"],
            info: response[i]["info"],
            image: imageParse,
          );
          _widgetList.add(discModel);
        }
      } else {
        _idController.text = '1';
        _yearController.text = '';
      }
      _titleController.text = '';
      _infoController.text = '';
      if (EasyLoading.isShow) {
        Timer(const Duration(milliseconds: 2000), () {
          EasyLoading.dismiss(animation: true);
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
    final double itemWidth = size.width;
    const double itemHeight = 100;

    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: const Text('Discografia'),
        backgroundColor: Colors.black38,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            iconSize: 40,
            color: Colors.amber,
            splashColor: Colors.yellow,
            tooltip: 'Adicionar álbum',
            onPressed: () {
              _addNew(context);
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
                            tooltip: 'Lista de músicas',
                            child: const Icon(Icons.audiotrack_outlined),
                            backgroundColor: Colors.blue,
                            onPressed: () => _redirectTo(
                                value.id!, value.title!, value.image!),
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
                                      _removeData(value.id!, value.image!);
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
