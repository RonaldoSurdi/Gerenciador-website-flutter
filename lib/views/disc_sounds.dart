import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:typed_data';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hwscontrol/core/components/snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:file_picker/file_picker.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:hwscontrol/core/models/sound_model.dart';
import 'package:audioplayers/audioplayers.dart';

class DiscSounds extends StatefulWidget {
  final String itemId;
  final String itemTitle;
  const DiscSounds({
    Key? key,
    required this.itemId,
    required this.itemTitle,
  }) : super(key: key);

  @override
  _DiscSoundsState createState() => _DiscSoundsState();
}

class _DiscSoundsState extends State<DiscSounds> {
  final TextEditingController _trackController = MaskedTextController(
    mask: '00',
    text: '',
  );
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _infoController = TextEditingController();
  final TextEditingController _movieController = TextEditingController();
  final TextEditingController _lyricController = TextEditingController();
  final TextEditingController _audioController = TextEditingController();
  final TextEditingController _cipherController = TextEditingController();

  final List<SoundModel> _widgetList = [];

  AudioPlayer advancedPlayer = AudioPlayer();

  bool _soundActive = false;
  String _soundPlaing = '';
  String _nextTrack = '';

  Future _playSound(int curIndex) async {
    int currentIndex = curIndex - 1;
    if (_soundPlaing.isNotEmpty) {
      await advancedPlayer.stop();
    }

    int result = await advancedPlayer.play(_widgetList[currentIndex].audio!);
    _soundActive = (result == 1);
    _soundPlaing = _widgetList[currentIndex].audio!;

    /*await advancedPlayer.play(
      uriSound,
      isLocal: false,
    );*/
  }

  void nextTrack(int currentIndex) {
    _playSound(currentIndex);
  }

  Future _stopSound() async {
    if (_soundActive) {
      _soundActive = false;
      await advancedPlayer.stop();
      _soundPlaing = '';
    }
  }

  // seleciona a música do computador
  Future _selectSound(idSound, _audioOriginalValue) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp3'],
    );

    if (result != null) {
      EasyLoading.showInfo(
        'enviando arquivo...',
        maskType: EasyLoadingMaskType.custom,
        dismissOnTap: false,
        duration: const Duration(seconds: 10),
      );

      Uint8List? fileBytes = result.files.first.bytes;
      //String? fileName = result.files.first.name;
      String? fileExt = result.files.first.extension;
      String? filePut = '$idSound$fileExt';

      // Upload file
      await firebase_storage.FirebaseStorage.instance
          .ref('discs/${widget.itemId}/$filePut')
          .putData(fileBytes!);

      FirebaseFirestore db = FirebaseFirestore.instance;

      await db
          .collection("discs")
          .doc(widget.itemId)
          .collection("sounds")
          .doc(idSound.toString().padLeft(5, '0'))
          .update({
        "audio": filePut,
      });

      setState(() {
        Timer(const Duration(milliseconds: 500), () {
          _getData();
        });
      });
    }

    return Future.value(true);
  }

  Future<void> _dialogAudio(
    BuildContext context,
    itemId,
    itemAudio,
  ) async {
    String audioOriginal = '';
    bool newAudio = (itemAudio != '');
    bool externalLink = false;
    int audioType = 0;
    if (newAudio) {
      externalLink =
          (itemAudio.contains("https://") || itemAudio.contains("http://"));
      if (externalLink) {
        audioType = 0;
      } else {
        audioType = 1;
        audioOriginal = itemAudio
            .replaceAll(
                'https://firebasestorage.googleapis.com/v0/b/joao-luiz-correa.appspot.com/o/discs%2F${widget.itemId}%2F',
                '')
            .replaceAll('?alt=media', '');
      }
    }
    _audioController.text = itemAudio;
    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (builder, setState) => AlertDialog(
            title: const Text('Adicionar áudio'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Selecione o método:',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 14.0,
                    fontFamily: 'WorkSansMedium',
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Radio(
                      value: 0,
                      groupValue: audioType,
                      onChanged: (value) {
                        setState(() {
                          audioType = value as int;
                        });
                      },
                    ),
                    const Text(
                      'Link url externo',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14.0,
                        fontFamily: 'WorkSansMedium',
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    Radio(
                      value: 1,
                      groupValue: audioType,
                      onChanged: (value) {
                        setState(() {
                          audioType = value as int;
                        });
                      },
                    ),
                    const Text(
                      'Enviar para storage',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14.0,
                        fontFamily: 'WorkSansMedium',
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text(
                    (newAudio && !externalLink)
                        ? 'Existe um áudio importado em seu storage, exte processo eliminará o arquivo.'
                        : 'Selecione o arquivo de áudio no formato mp3.',
                    style: TextStyle(
                      color: (newAudio && !externalLink)
                          ? Colors.red
                          : Colors.black,
                      fontSize: 14.0,
                      fontFamily: 'WorkSansMedium',
                    ),
                  ),
                ),
                (audioType == 0)
                    ? TextField(
                        autofocus: true,
                        controller: _audioController,
                        maxLength: 255,
                        decoration: const InputDecoration(
                          hintText: "https://domnio.com/sound/1/1.mp3",
                        ),
                      )
                    : Container(
                        height: 1.0,
                        color: Colors.transparent,
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
                  if (audioType == 0) {
                    String linkAudio = _audioController.text;
                    if (linkAudio.isEmpty ||
                        (!linkAudio.contains("https://") &&
                            !linkAudio.contains("http://"))) {
                      CustomSnackBar(
                          context, const Text('Digite a url do áudio mp3.'),
                          backgroundColor: Colors.red);
                    } else {
                      _updateAudioData(
                        itemId,
                        linkAudio,
                        audioOriginal,
                      ).then(
                        (value) => {
                          if (value) {Navigator.pop(context)}
                        },
                      );
                    }
                  } else {
                    _selectSound(itemId, audioOriginal).then(
                      (value) => {
                        if (value) {Navigator.pop(context)}
                      },
                    );
                  }
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                  backgroundColor: Colors.green,
                  alignment: Alignment.center,
                ),
                child: Text(
                  (audioType == 0) ? 'Gravar link' : 'Importar arquivo mp3',
                  style: const TextStyle(
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

  Future<void> _dialogData(
    BuildContext context,
    itemId,
    itemTitle,
    itemMovie,
    itemLyric,
    itemCipher,
    itemInfo,
  ) async {
    if (itemId == 0) {
      _trackController.text = _nextTrack;
    } else {
      _trackController.text = itemId.toString();
    }
    _titleController.text = itemTitle;
    _movieController.text = itemMovie;
    _lyricController.text = itemLyric;
    _cipherController.text = itemCipher;
    _infoController.text = itemInfo;
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
                  autofocus: (itemId == 0),
                  enableInteractiveSelection: (itemId == 0),
                  readOnly: (itemId > 0),
                  onTap: () {
                    if (itemId > 0) {
                      FocusScope.of(context).nextFocus();
                    }
                  },
                  controller: _trackController,
                  keyboardType: TextInputType.number,
                  maxLength: 2,
                  decoration: const InputDecoration(
                    hintText: "Track",
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
                  controller: _movieController,
                  maxLength: 200,
                  decoration: const InputDecoration(
                    hintText: "Url Youtube (opcional)",
                  ),
                ),
                TextField(
                  autofocus: true,
                  controller: _lyricController,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    hintText: "Letra (opcional)",
                  ),
                ),
                TextField(
                  autofocus: true,
                  controller: _cipherController,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    hintText: "Cifra (opcional)",
                  ),
                ),
                TextField(
                  autofocus: true,
                  controller: _infoController,
                  maxLines: 3,
                  decoration:
                      const InputDecoration(hintText: "Composição (opcional)"),
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
                  if (_trackController.text.isEmpty) {
                    CustomSnackBar(
                        context, const Text('Digite o número do álbum.'),
                        backgroundColor: Colors.red);
                  } else if (_titleController.text.isEmpty) {
                    CustomSnackBar(
                        context, const Text('Digite o título do álbum.'),
                        backgroundColor: Colors.red);
                  } else {
                    if (itemId == 0) {
                      _saveData(
                          num.parse(_trackController.text),
                          _titleController.text,
                          _movieController.text,
                          _lyricController.text,
                          _cipherController.text,
                          _infoController.text);
                    } else {
                      _updateData(
                          num.parse(_trackController.text),
                          _titleController.text,
                          _movieController.text,
                          _lyricController.text,
                          _cipherController.text,
                          _infoController.text);
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
    num _trackValue,
    String _titleValue,
    String _movieValue,
    String _lyricValue,
    String _cipherValue,
    String _infoValue,
  ) async {
    EasyLoading.showInfo(
      'gravando dados...',
      maskType: EasyLoadingMaskType.custom,
      dismissOnTap: false,
      duration: const Duration(seconds: 10),
    );

    SoundModel soundModel = SoundModel(
      track: _trackValue,
      title: _titleValue,
      info: _infoValue,
      movie: _movieValue,
      lyric: _lyricValue,
      cipher: _cipherValue,
      audio: '',
    );

    FirebaseFirestore db = FirebaseFirestore.instance;
    db
        .collection("discs")
        .doc(widget.itemId)
        .collection("sounds")
        .doc(_trackValue.toString().padLeft(5, '0'))
        .set(soundModel.toMap());

    setState(() {
      Timer(const Duration(milliseconds: 500), () {
        _getData();
      });
    });

    return Future.value(true);
  }

  Future _updateData(
    num _trackValue,
    String _titleValue,
    String _movieValue,
    String _lyricValue,
    String _cipherValue,
    String _infoValue,
  ) async {
    EasyLoading.showInfo(
      'atualizando dados...',
      maskType: EasyLoadingMaskType.custom,
      dismissOnTap: false,
      duration: const Duration(seconds: 10),
    );

    FirebaseFirestore db = FirebaseFirestore.instance;
    db
        .collection("discs")
        .doc(widget.itemId)
        .collection("sounds")
        .doc(_trackValue.toString().padLeft(5, '0'))
        .update({
      "title": _titleValue,
      "info": _infoValue,
      "movie": _movieValue,
      "lyric": _lyricValue,
      "cipher": _cipherValue,
    });

    setState(() {
      Timer(const Duration(milliseconds: 500), () {
        _getData();
      });
    });

    return Future.value(true);
  }

  Future _updateAudioData(
    num _trackValue,
    String _audioValue,
    String _audioOriginalValue,
  ) async {
    EasyLoading.showInfo(
      'atualizando dados...',
      maskType: EasyLoadingMaskType.custom,
      dismissOnTap: false,
      duration: const Duration(seconds: 10),
    );

    FirebaseFirestore db = FirebaseFirestore.instance;
    db
        .collection("discs")
        .doc(widget.itemId)
        .collection("sounds")
        .doc(_trackValue.toString().padLeft(5, '0'))
        .update({
      "audio": _audioValue,
    });

    if (_audioOriginalValue.isNotEmpty) {
      await firebase_storage.FirebaseStorage.instance
          .ref("discs/${widget.itemId}/$_audioOriginalValue")
          .delete();
    }

    setState(() {
      Timer(const Duration(milliseconds: 500), () {
        _getData();
      });
    });

    return Future.value(true);
  }

  _dialogDelete(SoundModel value) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Remover música'),
        content: Text(
            'Tem certeza que deseja remover a música\n${value.track.toString().padLeft(2, '0')} - ${value.title}?'),
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
              _removeData(value.track, value.audio);
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

  Future _removeData(itemId, itemFile) async {
    EasyLoading.showSuccess(
      'removendo música...',
      maskType: EasyLoadingMaskType.custom,
    );

    if (itemFile.isNotEmpty) {
      await FirebaseFirestore.instance
          .collection("discs")
          .doc(widget.itemId)
          .collection("sounds")
          .doc(itemId.toString().padLeft(5, '0'))
          .delete();

      await firebase_storage.FirebaseStorage.instance
          .ref("discs/${widget.itemId}/$itemFile")
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
    var data = await db
        .collection("discs")
        .doc(widget.itemId)
        .collection("sounds")
        .orderBy('track')
        .get();
    var response = data.docs;
    setState(() {
      if (response.isNotEmpty) {
        _nextTrack = (response.length + 1).toString();
        for (int i = 0; i < response.length; i++) {
          String uri = response[i]["audio"].toString().replaceAll('null', '');
          if (!uri.contains("https://") && !uri.contains("http://")) {
            uri =
                'https://firebasestorage.googleapis.com/v0/b/joao-luiz-correa.appspot.com/o/discs%2F${widget.itemId}%2F$uri?alt=media';
          }
          SoundModel soundModel = SoundModel(
            track: response[i]["track"],
            title: response[i]["title"],
            info: response[i]["info"].toString().replaceAll('null', ''),
            movie: response[i]["movie"].toString().replaceAll('null', ''),
            lyric: response[i]["lyric"].toString().replaceAll('null', ''),
            cipher: response[i]["cipher"].toString().replaceAll('null', ''),
            audio: uri,
          );
          _widgetList.add(soundModel);
        }
      } else {
        _nextTrack = '1';
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
    if (_soundPlaing.isNotEmpty) {
      _stopSound();
    }
  }

  @override
  void initState() {
    super.initState();
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
        title: Text(
          widget.itemTitle,
        ),
        backgroundColor: Colors.black38,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            iconSize: 40,
            color: Colors.amber,
            splashColor: Colors.yellow,
            tooltip: 'Adicionar música',
            onPressed: () {
              _dialogData(
                context,
                0,
                '',
                '',
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
              children: _widgetList.map((SoundModel value) {
                return Container(
                  color: Colors.black26,
                  margin: const EdgeInsets.all(1.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        padding: const EdgeInsets.fromLTRB(25, 5, 5, 5),
                        child: Text(
                          value.track.toString().padLeft(2, '0'),
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
                            heroTag: "remove_${value.track}",
                            mini: false,
                            tooltip: value.audio!.isEmpty
                                ? 'Nenhum áudio importado'
                                : (_soundPlaing != value.audio)
                                    ? 'Reproduzir áudio'
                                    : 'Parar áudio',
                            child: Icon(value.audio!.isEmpty
                                ? Icons.play_disabled_sharp
                                : (_soundPlaing != value.audio)
                                    ? Icons.play_arrow
                                    : Icons.pause),
                            backgroundColor: value.audio!.isEmpty
                                ? (_soundPlaing != value.audio)
                                    ? Colors.grey
                                    : Colors.green
                                : Colors.green,
                            onPressed: () => value.audio!.isEmpty
                                ? setState(() {
                                    _dialogAudio(
                                      context,
                                      value.track,
                                      value.audio,
                                    );
                                  })
                                : (_soundPlaing != value.audio)
                                    ? setState(() {
                                        _playSound(value.track as int);
                                      })
                                    : setState(() {
                                        _stopSound();
                                      }),
                          ),
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            tooltip: value.audio!.isEmpty
                                ? 'Enviar arquivo mp3'
                                : 'Atualizar arquivo mp3',
                            icon: Icon(value.audio!.isEmpty
                                ? Icons.music_off
                                : Icons.music_note),
                            color: Colors.blueAccent,
                            onPressed: () => setState(() {
                              _dialogAudio(
                                context,
                                value.track,
                                value.audio,
                              );
                            }),
                          ),
                          const Padding(
                            padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                            child: Text(
                              'ÁUDIO MP3',
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
                              value.track,
                              value.title,
                              value.movie,
                              value.lyric,
                              value.cipher,
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
                            tooltip: 'Remover música',
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
