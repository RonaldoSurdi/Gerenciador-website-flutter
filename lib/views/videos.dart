import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hwscontrol/core/components/snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:fwfh_webview/fwfh_webview.dart';
import 'package:decorated_icon/decorated_icon.dart';
import 'package:hwscontrol/core/models/video_model.dart';
import 'package:hwscontrol/core/models/youtube_model.dart';
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

  _dialogUrl(idVideo, titleVideo) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (builder, setState) => AlertDialog(
            insetPadding: const EdgeInsets.all(0),
            elevation: 10,
            titlePadding: const EdgeInsets.fromLTRB(10, 14, 10, 0),
            contentPadding: const EdgeInsets.fromLTRB(10, 0, 10, 5),
            backgroundColor: Colors.black87,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0))),
            title: Stack(
              children: [
                Text(
                  titleVideo,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 15.0,
                    fontFamily: 'WorkSansLigth',
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(0),
                    child: SizedBox(
                      height: 20.0,
                      width: 25.0,
                      child: FloatingActionButton(
                        heroTag: 'view_video',
                        mini: true,
                        tooltip: 'Fechar janela',
                        child: const DecoratedIcon(
                          Icons.close,
                          color: Colors.grey,
                          size: 20.0,
                          shadows: [
                            BoxShadow(
                              color: Colors.black54,
                              offset: Offset(2.0, 2.0),
                            ),
                          ],
                        ),
                        elevation: 0,
                        disabledElevation: 0,
                        highlightElevation: 0,
                        focusElevation: 0,
                        hoverElevation: 0,
                        backgroundColor: Colors.transparent,
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            content: Builder(
              builder: (context) {
                //var height = MediaQuery.of(context).size.height;
                var width = MediaQuery.of(context).size.width;
                return SizedBox(
                  width: width - 100,
                  child: HtmlWidget(
                    '<iframe src="https://www.youtube.com/embed/$idVideo?autoplay=1" frameborder="0" allowfullscreen></iframe>',
                    factoryBuilder: () => VideoWidgetFactory(),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Future<void> _dialogData(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (builder, setState) => AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            title: const Text('Adicionar vídeo Youtube'),
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
                  _saveData(_watchValue);
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
                  child: TextField(
                    autofocus: true,
                    onChanged: (value) {
                      setState(() {
                        _watchValue = value;
                      });
                    },
                    controller: _watchController,
                    maxLength: 200,
                    decoration: const InputDecoration(
                        hintText: "Cole o link do vídeo aqui..."),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

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
    EasyLoading.showInfo(
      'gravando dados...',
      maskType: EasyLoadingMaskType.custom,
      dismissOnTap: false,
      duration: const Duration(seconds: 10),
    );

    DateTime now = DateTime.now();
    String dateNow = DateFormat('yyyyMMddkkmmss').format(now);

    VideoModel videoModel = VideoModel(
        date: dateNow, title: _titleText, image: _imageText, watch: _watchText);

    FirebaseFirestore db = FirebaseFirestore.instance;
    db.collection("videos").doc(dateNow).set(videoModel.toMap());

    setState(() {
      Timer(const Duration(milliseconds: 500), () {
        _getData();
      });
    });

    return Future.value(true);
  }

  _dialogDelete(VideoModel value) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Remover vídeo'),
        content:
            Text('Tem certeza que deseja remover o vídeo\n${value.title}?'),
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
              _removeData(value.date);
              Navigator.pop(context);
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
      'removendo video...',
      maskType: EasyLoadingMaskType.custom,
      dismissOnTap: false,
      duration: const Duration(seconds: 10),
    );

    await FirebaseFirestore.instance.collection("videos").doc(itemId).delete();

    setState(() {
      Timer(const Duration(milliseconds: 500), () {
        _getData();
      });
    });
  }

  Future _openMovie(idVideo) async {
    String url = 'https://www.youtube.com/watch?v=$idVideo';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Vídeo não disponível $url';
    }
  }

  Future _getData() async {
    _widgetList.clear();

    FirebaseFirestore db = FirebaseFirestore.instance;

    var data =
        await db.collection("videos").orderBy('date', descending: true).get();

    setState(() {
      var response = data.docs;
      for (int i = 0; i < response.length; i++) {
        VideoModel videoModel = VideoModel(
          date: response[i]["date"],
          title: response[i]["title"],
          image: response[i]["image"],
          watch: response[i]["watch"],
        );
        _widgetList.add(videoModel);
      }
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
    // if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double itemWidth = size.width;
    const double itemHeight = 100;

    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: const Text('Vídeos Youtube'),
        backgroundColor: Colors.black38,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            iconSize: 40,
            color: Colors.amber,
            splashColor: Colors.yellow,
            tooltip: 'Adicionar vídeo',
            onPressed: () {
              _dialogData(context);
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
                          ),
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            tooltip: 'Abrir vídeo no Youtube',
                            icon: const Icon(Icons.movie_outlined),
                            color: Colors.blue,
                            onPressed: () =>
                                _dialogUrl(value.watch, value.title),
                            //_openMovie(value.watch),
                          ),
                          const Padding(
                            padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                            child: Text(
                              'ABRIR VÍDEO',
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
                            tooltip: 'Remover vídeo',
                            icon: const Icon(Icons.delete_forever),
                            color: Colors.grey.shade300,
                            onPressed: () => _dialogDelete(value),
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

class VideoWidgetFactory extends WidgetFactory with WebViewFactory {}
