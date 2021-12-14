import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hwscontrol/core/widgets/snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:hwscontrol/core/models/video_model.dart';

class Videos extends StatefulWidget {
  const Videos({Key? key}) : super(key: key);

  @override
  _VideosState createState() => _VideosState();
}

class _VideosState extends State<Videos> {
  final TextEditingController _textFieldController = TextEditingController();
  late String valueText;

  final List<VideoModel> _widgetList = [];

  Future<void> _addNewVideos(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Adicionar novo vídeo Youtube'),
          content: TextField(
            onChanged: (value) {
              setState(() {
                valueText = value;
              });
            },
            controller: _textFieldController,
            decoration: const InputDecoration(
                hintText: "Digite o link do vídeo Youtube"),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancelar',
                style: TextStyle(
                  color: Colors.grey,
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
    DateTime now = DateTime.now();
    String dateNow = DateFormat('yyyyMMddkkmmss').format(now);

    VideoModel videoModel = VideoModel(
        date: dateNow, title: descriptionText, watch: descriptionText);

    FirebaseFirestore db = FirebaseFirestore.instance;
    db.collection("videos").doc(dateNow).set(videoModel.toMap());

    setState(() {
      CustomSnackBar(context, const Text("Vídeo criado com sucesso."));
      Timer(const Duration(milliseconds: 1500), () {
        _onGetData();
      });
    });

    return Future.value(true);
  }

  Future _removeVideo(idVideo) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    db.collection("videos").doc(idVideo).delete();
    setState(() {
      CustomSnackBar(context, const Text("Álbum excluido com sucesso."));
      Timer(const Duration(milliseconds: 500), () {
        _onGetData();
      });
    });
  }

  Future _openVideo(idVideo) async {
    String url = 'https://www.youtube.com/watch?v=$idVideo';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Vídeo não disponível $url';
    }
  }

  Future _onGetData() async {
    _widgetList.clear();
    FirebaseFirestore db = FirebaseFirestore.instance;
    var data =
        await db.collection("videos").orderBy('date', descending: true).get();
    var response = data.docs;
    for (int i = 0; i < response.length; i++) {
      setState(() {
        String watch = response[i]["watch"];
        watch = watch.replaceAll('https://www.youtube.com/watch?v=', '');
        watch = watch.replaceAll('https://youtu.be/', '');
        VideoModel videoModel = VideoModel(
            date: response[i]["date"],
            title: response[i]["title"],
            watch: watch);
        _widgetList.add(videoModel);
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
        title: const Text('Galeria de fotos'),
        backgroundColor: Colors.black38,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add_a_photo),
            tooltip: 'Adicionar álbum',
            onPressed: () {
              _addNewVideos(context);
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
        children: _widgetList.map((VideoModel value) {
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
                      image: NetworkImage(
                          'https://i1.ytimg.com/vi/${value.watch}/default.jpg'),
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
                  child: FloatingActionButton(
                    mini: true,
                    tooltip: 'Adicionar fotos',
                    child: const Icon(Icons.close),
                    backgroundColor: Colors.red,
                    onPressed: () => _openVideo(value.watch),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(5, 5, 15, 5),
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
                            'Tem certeza que deseja remover o álbum\n${value.title}?'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text(
                              'Cancelar',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16.0,
                                fontFamily: 'WorkSansMedium',
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              _removeVideo(value.date);
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
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
