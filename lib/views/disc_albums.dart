import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hwscontrol/core/components/snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:hwscontrol/core/models/disc_model.dart';
import 'package:hwscontrol/views/disc_sounds.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class DiscAlbums extends StatefulWidget {
  const DiscAlbums({Key? key}) : super(key: key);

  @override
  _DiscAlbumsState createState() => _DiscAlbumsState();
}

class _DiscAlbumsState extends State<DiscAlbums> {
  List<XFile>? _imageFileList;

  set _imageFile(XFile? value) {
    _imageFileList = value == null ? null : [value];
  }

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
  final TextEditingController _confirmDeleteController =
      TextEditingController();

  String nextId = '';
  String nextYear = '';
  String zvalue = '1';

  Future _selectFile(idDisc) async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      /*
      maxHeight: 1600,
      maxWidth: 1080,
      imageQuality: 90,
      */

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
      dismissOnTap: false,
      duration: const Duration(seconds: 10),
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
      closeLoading();
      CustomSnackBar(context, const Text('Formato da imagem inválido!'),
          backgroundColor: Colors.red);
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

    closeLoading();
    return Future.value(uploadTask);
  }

  Future<void> _dialogData(
    BuildContext context,
    itemId,
    itemYear,
    itemTitle,
    itemInfo,
  ) async {
    if (itemId == 0) {
      _idController.text = nextId;
      _yearController.text = nextYear;
    } else {
      _idController.text = itemId.toString();
      _yearController.text = itemYear.toString();
    }
    _titleController.text = itemTitle;
    _infoController.text = itemInfo;
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
                  autofocus: (itemId == 0),
                  enableInteractiveSelection: (itemId == 0),
                  readOnly: (itemId > 0),
                  onTap: () {
                    if (itemId > 0) {
                      FocusScope.of(context).nextFocus();
                    }
                  },
                  controller: _idController,
                  keyboardType: TextInputType.number,
                  maxLength: 3,
                  decoration: const InputDecoration(
                    hintText: "Número",
                  ),
                ),
                TextField(
                  autofocus: true,
                  controller: _titleController,
                  maxLength: 100,
                  decoration: const InputDecoration(
                    hintText: "Título",
                  ),
                ),
                TextField(
                  autofocus: true,
                  controller: _yearController,
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                  decoration: const InputDecoration(
                    hintText: "Lançamento",
                  ),
                ),
                TextField(
                  autofocus: true,
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
                    if (itemId == 0) {
                      _saveData(
                        num.parse(_idController.text),
                        _titleController.text,
                        num.parse(_yearController.text),
                        _infoController.text,
                      );
                    } else {
                      _updateData(
                        num.parse(_idController.text),
                        _titleController.text,
                        num.parse(_yearController.text),
                        _infoController.text,
                      );
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
    num _idValue,
    String _titleValue,
    num _yearValue,
    String _infoValue,
  ) async {
    EasyLoading.showInfo(
      'gravando dados...',
      maskType: EasyLoadingMaskType.custom,
      dismissOnTap: false,
      duration: const Duration(seconds: 10),
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

    closeLoading();
    return Future.value(true);
  }

  Future _updateData(
    num _idValue,
    String _titleValue,
    num _yearValue,
    String _infoValue,
  ) async {
    EasyLoading.showInfo(
      'atualizando dados...',
      maskType: EasyLoadingMaskType.custom,
      dismissOnTap: false,
      duration: const Duration(seconds: 10),
    );

    FirebaseFirestore db = FirebaseFirestore.instance;
    await db
        .collection("discs")
        .doc(_idValue.toString().padLeft(5, '0'))
        .update({
      "id": _idValue,
      "title": _titleValue,
      "year": _yearValue,
      "info": _infoValue,
    });

    closeLoading();
    return Future.value(true);
  }

  _dialogDelete(
    String titleParse,
    DiscModel value,
    bool isMob,
  ) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Remover álbum'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Tem certeza que deseja remover o álbum?',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 14.0,
                fontFamily: 'WorkSansMedium',
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: !isMob
                  ? Row(
                      children: [
                        const Text(
                          'Para confirmar é necessário digitar: ',
                          style: TextStyle(
                            color: Colors.black45,
                            fontSize: 12.0,
                            fontFamily: 'WorkSansMedium',
                          ),
                        ),
                        Text(
                          titleParse,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 12.0,
                            fontFamily: 'WorkSansMedium',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    )
                  : Text.rich(
                      TextSpan(
                        text: 'Para confirmar é necessário digitar: ',
                        style: const TextStyle(
                          color: Colors.black45,
                          fontSize: 12.0,
                          fontFamily: 'WorkSansMedium',
                        ),
                        children: [
                          TextSpan(
                            text: '\n$titleParse',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 14.0,
                              fontFamily: 'WorkSansMedium',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
            TextField(
              controller: _confirmDeleteController,
              decoration: InputDecoration(
                hintText: titleParse,
              ),
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
              if (_confirmDeleteController.text == titleParse) {
                _removeData(value.id!, value.image!);
                Navigator.pop(context);
              }
              _confirmDeleteController.text = '';
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

  Future _removeData([num itemId = 0, String itemImage = '']) async {
    EasyLoading.showSuccess(
      'removendo álbum...',
      maskType: EasyLoadingMaskType.custom,
    );

    await FirebaseFirestore.instance
        .collection("discs")
        .doc(itemId.toString().padLeft(5, '0'))
        .delete();

    if (itemImage.isNotEmpty && itemImage != 'images%2Fdefault.jpg') {
      await firebase_storage.FirebaseStorage.instance
          .ref("discs/${itemId.toString().padLeft(5, '0')}")
          .delete();
    }

    closeLoading();
  }

  Future _redirectTo([
    num itemId = 0,
    String itemTitle = '',
    String itemImage = '',
  ]) async {
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
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    double itemWidth = size.width;
    int itemsPerPage = (size.height / 85.3).round() + 1;
    bool isMob = (itemWidth <= 640);
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
              _dialogData(context, 0, '', '', '');
            },
          ),
        ],
      ),
      body: PaginateFirestore(
        itemsPerPage: itemsPerPage,
        itemBuilderType: PaginateBuilderType.listView,
        itemBuilder: (context, documentSnapshots, index) {
          final data = documentSnapshots[index].data() as Map;
          String? idParse = data["id"].toString().padLeft(5, '0');
          String? imageGet = data["image"];
          String imageParse = 'images%2Fdefault.jpg';
          if (imageGet != '') {
            imageParse = 'discs%2F$idParse%2F$imageGet';
          }
          DiscModel value = DiscModel(
            id: data["id"],
            title: data["title"],
            year: data["year"],
            info: data["info"],
            image: imageParse,
          );
          String titleParse =
              '${value.id.toString().padLeft(2, '0')} - ${value.title}';
          return Card(
            color: Colors.black12,
            margin: const EdgeInsets.fromLTRB(5, 0, 0, 5),
            child: ListTile(
              contentPadding: const EdgeInsets.only(bottom: 5),
              dense: true,
              visualDensity: const VisualDensity(vertical: 4),
              title: Text(
                '${value.title}',
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 16.0,
                  fontFamily: 'WorkSansLigth',
                ),
              ),
              subtitle: Text(
                value.info
                    .toString()
                    .replaceAll('\n', ' - ')
                    .replaceAll(' - Gravadora', '\nGravadora')
                    .replaceAll(' - Ano: ${value.year}', ''),
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 12.0,
                  fontFamily: 'WorkSansLigth',
                ),
              ),
              leading: Container(
                height: 70,
                padding: const EdgeInsets.only(left: 10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4.0),
                  child: Image(
                    image: NetworkImage(
                        'https://firebasestorage.googleapis.com/v0/b/joao-luiz-correa.appspot.com/o/${value.image}?alt=media'),
                    fit: BoxFit.contain,
                    width: 60,
                  ),
                ),
              ),
              trailing: !isMob
                  ? SizedBox(
                      width: 230,
                      child: Row(
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                tooltip: 'Lista de músicas',
                                icon: const Icon(Icons.audiotrack_outlined),
                                color: Colors.amber,
                                onPressed: () => _redirectTo(
                                  value.id!,
                                  value.title!,
                                  value.image!,
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                                child: Text(
                                  'MÚSICAS',
                                  style: TextStyle(
                                    color: Colors.white30,
                                    fontSize: 10.0,
                                    fontFamily: 'WorkSansLigth',
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                tooltip: 'Adicionar capa',
                                icon: const Icon(Icons.add_a_photo),
                                color: Colors.green,
                                onPressed: () => _selectFile(value.id),
                              ),
                              const Padding(
                                padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                                child: Text(
                                  'CAPA',
                                  style: TextStyle(
                                    color: Colors.white30,
                                    fontSize: 10.0,
                                    fontFamily: 'WorkSansLigth',
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                tooltip: 'Editar dados',
                                icon: const Icon(Icons.edit),
                                color: Colors.blue,
                                onPressed: () => _dialogData(
                                  context,
                                  value.id,
                                  value.year,
                                  value.title,
                                  value.info,
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                                child: Text(
                                  'EDITAR',
                                  style: TextStyle(
                                    color: Colors.white30,
                                    fontSize: 10.0,
                                    fontFamily: 'WorkSansLigth',
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                tooltip: 'Remover álbum',
                                icon: const Icon(Icons.delete_forever),
                                color: Colors.grey.shade300,
                                onPressed: () => _dialogDelete(
                                  titleParse,
                                  value,
                                  isMob,
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                                child: Text(
                                  'EXCLUIR',
                                  style: TextStyle(
                                    color: Colors.white30,
                                    fontSize: 10.0,
                                    fontFamily: 'WorkSansLigth',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  : Container(
                      padding: const EdgeInsets.fromLTRB(8, 0, 20, 0),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton2<String>(
                          icon: const Icon(Icons.more_vert),
                          iconSize: 24,
                          style: const TextStyle(color: Colors.black54),
                          underline: Container(
                            height: 0,
                          ),
                          isExpanded: true,
                          iconEnabledColor: Colors.white70,
                          iconDisabledColor: Colors.white30,
                          buttonHeight: 40,
                          buttonWidth: 30,
                          itemHeight: 40,
                          itemWidth: 190,
                          offset: const Offset(-20, 0),
                          items: [
                            DropdownMenuItem(
                              value: "1",
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: const [
                                  Icon(Icons.audiotrack_outlined),
                                  SizedBox(width: 4),
                                  Text(
                                    "Lista de músicas",
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 14.0,
                                      fontFamily: 'WorkSansMedium',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            DropdownMenuItem(
                              value: "2",
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: const [
                                  Icon(Icons.add_a_photo),
                                  SizedBox(width: 4),
                                  Text(
                                    "Adicionar capa",
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 14.0,
                                      fontFamily: 'WorkSansMedium',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            DropdownMenuItem(
                              value: "3",
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: const [
                                  Icon(Icons.edit),
                                  SizedBox(width: 4),
                                  Text(
                                    "Editar dados",
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 14.0,
                                      fontFamily: 'WorkSansMedium',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            DropdownMenuItem(
                              value: "4",
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: const [
                                  Icon(Icons.delete_forever),
                                  SizedBox(width: 4),
                                  Text(
                                    "Excluir álbum",
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 14.0,
                                      fontFamily: 'WorkSansMedium',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                          onChanged: (zyalue) {
                            setState(() {
                              if (zyalue == "1") {
                                _redirectTo(
                                  value.id!,
                                  value.title!,
                                  value.image!,
                                );
                              } else if (zyalue == "2") {
                                _selectFile(value.id);
                              } else if (zyalue == "3") {
                                _dialogData(
                                  context,
                                  value.id,
                                  value.year,
                                  value.title,
                                  value.info,
                                );
                              } else if (zyalue == "4") {
                                _dialogDelete(
                                  titleParse,
                                  value,
                                  isMob,
                                );
                              }
                            });
                          },
                        ),
                      ),
                    ),
            ),
          );
        },
        query: FirebaseFirestore.instance.collection('discs').orderBy('id'),
        isLive: true,
      ),
      /*_widgetList.isNotEmpty
          ? ListView.builder(
              shrinkWrap: true,
              itemCount: _widgetList.length,
              itemBuilder: (context, index) {
                return 
              },
            )
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
            ),*/
    );
  }
}
