import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hwscontrol/views/photo_images.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hwscontrol/core/models/album_model.dart';
import 'package:hwscontrol/core/models/photo_album_model.dart';

class PhotoAlbums extends StatefulWidget {
  const PhotoAlbums({Key? key}) : super(key: key);

  @override
  _PhotoAlbumsState createState() => _PhotoAlbumsState();
}

class _PhotoAlbumsState extends State<PhotoAlbums> {
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _placeController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _confirmDeleteController =
      TextEditingController();

  late String valueText;

  final List<AlbumModel> _widgetList = [];

  Future<void> _dialogData(
    BuildContext context,
    itemId,
    itemDescription,
    itemPlace,
    itemDate,
  ) async {
    _descriptionController.text = itemDescription;
    _placeController.text = itemPlace;
    _dateController.text = itemDate;
    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (builder, setState) => AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            title: const Text('Adicionar álbum de fotos'),
            content: Builder(
              builder: (context) {
                var width = MediaQuery.of(context).size.width;
                if (width > 500) {
                  width = 500;
                } else {
                  width = width - 10;
                }
                return SizedBox(
                  width: width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        autofocus: true,
                        controller: _descriptionController,
                        maxLength: 250,
                        decoration: const InputDecoration(
                          hintText: "Descrição",
                        ),
                      ),
                      TextField(
                        autofocus: true,
                        controller: _placeController,
                        maxLength: 100,
                        decoration: const InputDecoration(
                          hintText: "Cidade / UF",
                        ),
                      ),
                      TextField(
                        autofocus: true,
                        controller: _dateController,
                        maxLength: 10,
                        decoration: const InputDecoration(
                          hintText: "DD/MM/AAAA",
                        ),
                      ),
                    ],
                  ),
                );
              },
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
                  if (itemId == 0) {
                    _saveData(
                      _descriptionController.text,
                      _placeController.text,
                      _dateController.text,
                    );
                  } else {
                    _updateData(
                      itemId,
                      _descriptionController.text,
                      _placeController.text,
                      _dateController.text,
                    );
                  }
                  Navigator.pop(context);
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

  Future _saveData(descriptionText, placeText, dataText) async {
    EasyLoading.showInfo(
      'gravando dados...',
      maskType: EasyLoadingMaskType.custom,
      dismissOnTap: false,
      duration: const Duration(seconds: 10),
    );

    DateTime now = DateTime.now();
    String dateNow = DateFormat('yyyyMMddkkmmss').format(now);

    PhotoAlbumModel photoAlbumModel = PhotoAlbumModel(
      id: dateNow,
      description: descriptionText,
      place: placeText,
      date: dataText,
    );

    FirebaseFirestore db = FirebaseFirestore.instance;
    db.collection("photos").doc(dateNow).set(photoAlbumModel.toMap());

    setState(() {
      Timer(const Duration(milliseconds: 500), () {
        _getData();
      });
    });

    return Future.value(true);
  }

  Future _updateData(itemId, descriptionText, placeText, dataText) async {
    EasyLoading.showInfo(
      'atualizando dados...',
      maskType: EasyLoadingMaskType.custom,
      dismissOnTap: false,
      duration: const Duration(seconds: 10),
    );

    FirebaseFirestore db = FirebaseFirestore.instance;
    db.collection("photos").doc(itemId).update({
      "description": descriptionText,
      "place": placeText,
      "date": dataText,
    });

    setState(() {
      Timer(const Duration(milliseconds: 500), () {
        _getData();
      });
    });

    return Future.value(true);
  }

  _dialogDelete(
    String titleParse,
    AlbumModel value,
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
                _removeData(value.id);
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

  Future _removeData(itemId) async {
    EasyLoading.showInfo(
      'removendo álbum...',
      maskType: EasyLoadingMaskType.custom,
      dismissOnTap: false,
      duration: const Duration(seconds: 10),
    );

    await FirebaseFirestore.instance.collection("photos").doc(itemId).delete();

    await firebase_storage.FirebaseStorage.instance
        .ref("photos/$itemId")
        .delete();

    setState(() {
      Timer(const Duration(milliseconds: 500), () {
        _getData();
      });
    });
  }

  Future _redirectTo(itemId, itemTitle) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (builder) => PhotoImages(
          itemId: itemId,
          itemTitle: itemTitle,
        ),
      ),
    );
  }

  Future _getData() async {
    _widgetList.clear();

    FirebaseFirestore db = FirebaseFirestore.instance;
    var data =
        await db.collection("photos").orderBy('id', descending: true).get();
    setState(() {
      var response = data.docs;
      if (response.isNotEmpty) {
        for (int i = 0; i < response.length; i++) {
          String idAlbum = response[i]["id"];
          String description = response[i]["description"];
          String place = response[i]["place"];
          String date = response[i]["date"];
          firebase_storage.Reference arquive = firebase_storage
              .FirebaseStorage.instance
              .ref()
              .child("photos")
              .child(idAlbum);

          arquive.listAll().then((firebase_storage.ListResult listResult) {
            setState(() {
              String imageParse = 'images%2Fdefault.jpg';
              if (listResult.items.isNotEmpty) {
                String imageItem = listResult.items[0].fullPath;
                imageItem = imageItem.replaceAll('/', '%2F');
                imageParse = imageItem;
              }
              description = description.toUpperCase();

              AlbumModel albumModel = AlbumModel(
                id: idAlbum,
                description: description,
                place: place,
                date: date,
                image: imageParse,
              );
              _widgetList.add(albumModel);
            });
          }).catchError((error) {});
        }
      }
      _descriptionController.text = "";
      _placeController.text = "";
      _dateController.text = "";
      closeLoading();
    });
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
    double itemWidth = size.width;
    double itemHeight = 100;
    int itemsPerPage = (size.height / 85.3).round() + 1;
    bool isMob = (itemWidth <= 640);

    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: const Text('Álbum de fotos'),
        backgroundColor: Colors.black38,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            iconSize: 40,
            color: Colors.amber,
            splashColor: Colors.yellow,
            tooltip: 'Adicionar álbum',
            onPressed: () {
              _dialogData(
                context,
                0,
                '',
                '',
                '',
              );
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
              children: _widgetList.map((AlbumModel value) {
                String titleParse = '${value.id} - ${value.description}';
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
                            fit: BoxFit.cover,
                            width: 90,
                            height: 70,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(5, 5, 10, 5),
                          child: Text(
                            '${value.description}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontFamily: 'WorkSansLigth',
                            ),
                          ),
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            tooltip: 'Fotos do álbum',
                            icon:
                                const Icon(Icons.add_photo_alternate_outlined),
                            color: Colors.amber,
                            onPressed: () => _redirectTo(
                              value.id,
                              value.description,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                            child: Text(
                              'FOTOS',
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
                              value.description,
                              value.place,
                              value.date,
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
