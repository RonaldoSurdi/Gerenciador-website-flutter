import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:hwscontrol/core/theme/custom_theme.dart';
import 'package:hwscontrol/core/widgets/snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:hwscontrol/core/models/video_model.dart';
import 'package:hwscontrol/core/components/models/youtube_model.dart';
import 'package:hwscontrol/core/components/youtube.dart';

class Videos extends StatefulWidget {
  const Videos({Key? key}) : super(key: key);

  @override
  _VideosState createState() => _VideosState();
}

class _VideosState extends State<Videos> {
  final TextEditingController _watchController = TextEditingController();
  late String _watchValue;

  final List<VideoModel> _widgetList = [];

  Future<void> _addNewVideos(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (builder, setState) => AlertDialog(
            title: const Text('Adicionar novo vídeo Youtube'),
            content: TextField(
              onChanged: (value) {
                setState(() {
                  _watchValue = value;
                });
              },
              controller: _watchController,
              decoration: const InputDecoration(
                  hintText: "Cole o link do vídeo aqui..."),
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
                  _saveData(_watchValue);
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
  Future _saveData(_watchText) async {
    String _watchRes = _watchText;
    YoutubeModel? youtubeModel;
    try {
      youtubeModel = await YoutubeMetaData.getData(_watchRes);
    } catch (e) {
      youtubeModel = await null;
    }
    setState(() {
      _watchRes = _watchRes
          .replaceAll('https://www.youtube.com/watch?v=', '')
          .replaceAll('https://youtu.be/', '')
          .replaceAll('https', '')
          .replaceAll('http', '')
          .replaceAll('://', '')
          .replaceAll('/', '')
          .replaceAll(' ', '');
      if (youtubeModel != null &&
          _watchRes.trim().isNotEmpty &&
          _watchRes.trim().length >= 3) {
        _onSaveData(youtubeModel.title, youtubeModel.thumbnailUrl, _watchRes);
      } else {
        CustomSnackBar(
            context,
            const Text(
                'Digite ou cole a url de compartilhamento do vídeo Youtube!'),
            backgroundColor: Colors.red);
      }
    });
    return Future.value(true);
  }

  Future _onSaveData(_titleText, _imageText, _watchText) async {
    DateTime now = DateTime.now();
    String dateNow = DateFormat('yyyyMMddkkmmss').format(now);

    VideoModel videoModel = VideoModel(
        date: dateNow, title: _titleText, image: _imageText, watch: _watchText);

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
      CustomSnackBar(context, const Text("Vídeo excluido com sucesso."));
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
        VideoModel videoModel = VideoModel(
            date: response[i]["date"],
            title: response[i]["title"],
            image: response[i]["image"],
            watch: response[i]["watch"]);
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
        title: const Text('Vídeos Youtube'),
        backgroundColor: Colors.black38,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add_a_photo),
            iconSize: 40,
            color: Colors.amber,
            splashColor: Colors.yellow,
            tooltip: 'Adicionar vídeo',
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
                      image: NetworkImage('${value.image}'),
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
                    mini: false,
                    tooltip: 'Abrir vídeo Youtube',
                    child: const Icon(Icons.movie_creation),
                    backgroundColor: Colors.green,
                    onPressed: () => _openVideo(value.watch),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(5, 5, 15, 5),
                  child: FloatingActionButton(
                    mini: true,
                    tooltip: 'Remover vídeo',
                    child: const Icon(Icons.close),
                    backgroundColor: Colors.red,
                    onPressed: () => showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: const Text('Remover vídeo'),
                        content: Text(
                            'Tem certeza que deseja remover o vídeo\n${value.title}?'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Container(
                              padding:
                                  const EdgeInsets.fromLTRB(30, 10, 30, 10),
                              color: Colors.red,
                              child: const Text(
                                'Cancelar',
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 16.0,
                                  fontFamily: 'WorkSansMedium',
                                ),
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              _removeVideo(value.date);
                              Navigator.pop(context);
                            },
                            child: Container(
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15.0)),
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                    color: CustomTheme.loginGradientStart,
                                    offset: Offset(1.0, 6.0),
                                    blurRadius: 20.0,
                                  ),
                                  BoxShadow(
                                    color: CustomTheme.loginGradientEnd,
                                    offset: Offset(1.0, 6.0),
                                    blurRadius: 20.0,
                                  ),
                                ],
                                gradient: LinearGradient(
                                  colors: <Color>[
                                    CustomTheme.loginGradientEnd,
                                    CustomTheme.loginGradientStart
                                  ],
                                  begin: FractionalOffset(0.2, 0.2),
                                  end: FractionalOffset(1.0, 1.0),
                                  stops: <double>[0.0, 1.0],
                                  tileMode: TileMode.clamp,
                                ),
                              ),
                              padding:
                                  const EdgeInsets.fromLTRB(30, 10, 30, 10),
                              color: Colors.amber,
                              child: const Text(
                                'Excluir',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 16.0,
                                  fontFamily: 'WorkSansMedium',
                                ),
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
