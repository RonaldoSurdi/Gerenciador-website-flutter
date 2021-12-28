import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hwscontrol/pages/modules/photo_images.dart';
import 'package:hwscontrol/core/components/snackbar.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hwscontrol/core/models/album_model.dart';
import 'package:hwscontrol/core/models/photo_model.dart';

class PhotoAlbums extends StatefulWidget {
  const PhotoAlbums({Key? key}) : super(key: key);

  @override
  _PhotoAlbumsState createState() => _PhotoAlbumsState();
}

class _PhotoAlbumsState extends State<PhotoAlbums> {
  final TextEditingController _textFieldController = TextEditingController();
  late String valueText;

  final List<AlbumModel> _widgetList = [];

  Future<void> _addNew(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Adicionar álbum de fotos'),
          content: TextField(
            onChanged: (value) {
              setState(() {
                valueText = value;
              });
            },
            controller: _textFieldController,
            maxLength: 100,
            decoration: const InputDecoration(hintText: "Digite a descrição"),
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
                _saveData(valueText);
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
        );
      },
    );
  }

  // faz o envio da imagem para o storage
  Future _saveData(descriptionText) async {
    EasyLoading.showInfo(
      'gravando dados...',
      maskType: EasyLoadingMaskType.custom,
    );

    DateTime now = DateTime.now();
    String dateNow = DateFormat('yyyyMMddkkmmss').format(now);

    PhotoModel photoModel =
        PhotoModel(description: descriptionText, date: dateNow, count: 0);

    FirebaseFirestore db = FirebaseFirestore.instance;
    db.collection("photos").doc(dateNow).set(photoModel.toMap());

    setState(() {
      CustomSnackBar(context, const Text("Álbum criado com sucesso."));
      Timer(const Duration(milliseconds: 1500), () {
        _getData();
      });
    });

    return Future.value(true);
  }

  Future _removeData(itemId) async {
    EasyLoading.showInfo(
      'removendo álbum...',
      maskType: EasyLoadingMaskType.custom,
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
        await db.collection("photos").orderBy('date', descending: true).get();

    setState(() {
      var response = data.docs;
      if (response.isNotEmpty) {
        for (int i = 0; i < response.length; i++) {
          String idAlbum = response[i]["date"];
          String description = response[i]["description"];
          firebase_storage.Reference arquive = firebase_storage
              .FirebaseStorage.instance
              .ref()
              .child("photos")
              .child(idAlbum);

          arquive.listAll().then((firebase_storage.ListResult listResult) {
            String imageParse = 'images%2Fdefault.jpg';
            if (listResult.items.isNotEmpty) {
              String imageItem = listResult.items[0].fullPath;
              imageItem = imageItem.replaceAll('/', '%2F');
              imageParse = imageItem;
            }
            description = description.toUpperCase();

            AlbumModel albumModel = AlbumModel(
                id: idAlbum, description: description, image: imageParse);

            _widgetList.add(albumModel);
          }).catchError((error) {});
        }
      }
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
        title: const Text('Galeria de fotos'),
        backgroundColor: Colors.black38,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_photo_alternate),
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
      body: GridView.count(
        crossAxisCount: 1,
        childAspectRatio: (itemWidth / itemHeight),
        controller: ScrollController(keepScrollOffset: false),
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        children: _widgetList.map((AlbumModel value) {
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
                Padding(
                  padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                  child: SizedBox(
                    height: 40.0,
                    width: 40.0,
                    child: FloatingActionButton(
                      mini: false,
                      tooltip: 'Adicionar fotos',
                      child: const Icon(Icons.add_a_photo),
                      backgroundColor: Colors.green,
                      onPressed: () => _redirectTo(value.id, value.description),
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
                              'Tem certeza que deseja remover o álbum\n${value.description}?'),
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
                                _removeData(value.id);
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
