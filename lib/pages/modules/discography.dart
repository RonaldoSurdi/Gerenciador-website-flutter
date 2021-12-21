import 'package:flutter/material.dart';
import 'package:hwscontrol/pages/modules/disco_detail.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:hwscontrol/core/components/snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hwscontrol/core/models/discography_model.dart';

class Discography extends StatefulWidget {
  const Discography({Key? key}) : super(key: key);

  @override
  _DiscographyState createState() => _DiscographyState();
}

class _DiscographyState extends State<Discography> {
  final TextEditingController _watchController = TextEditingController();
  late String _watchValue;

  final List<DiscographyModel> _widgetList = [];

  Future<void> _addNewDiscography(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (builder, setState) => AlertDialog(
            title: const Text('Adicionar novo disco'),
            content: TextField(
              onChanged: (value) {
                setState(() {
                  _watchValue = value;
                });
              },
              controller: _watchController,
              decoration: const InputDecoration(hintText: "Título do disco"),
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
    if (_watchText.trim().isNotEmpty && _watchText.trim().length >= 3) {
      _onSaveData(_watchText);
    } else {
      CustomSnackBar(
          context, const Text('Preencha todos dados e tente novamente!'),
          backgroundColor: Colors.red);
    }
    return Future.value(true);
  }

  Future _onSaveData(_titleText) async {
    DateTime now = DateTime.now();
    String dateNow = DateFormat('yyyyMMddkkmmss').format(now);

    DiscographyModel discographyModel = DiscographyModel(
        id: dateNow,
        number: 0,
        title: _titleText,
        date: now,
        description: _titleText);

    FirebaseFirestore db = FirebaseFirestore.instance;
    db.collection("discography").doc(dateNow).set(discographyModel.toMap());

    setState(() {
      CustomSnackBar(context, const Text("Disco adicionado com sucesso."));
      Timer(const Duration(milliseconds: 1500), () {
        _onGetData();
      });
    });

    return Future.value(true);
  }

  Future _removeDiscography(idDiscography) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    db.collection("discography").doc(idDiscography).delete();
    setState(() {
      CustomSnackBar(context, const Text("Disco excluido com sucesso."));
      Timer(const Duration(milliseconds: 500), () {
        _onGetData();
      });
    });
  }

  Future _redirectDisco(idDisco) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (builder) => DiscoDetail(
          idDisco: idDisco,
        ),
      ),
    );
  }

  Future _onGetData() async {
    _widgetList.clear();
    FirebaseFirestore db = FirebaseFirestore.instance;
    var data = await db
        .collection("discography")
        .orderBy('id', descending: true)
        .get();
    var response = data.docs;
    for (int i = 0; i < response.length; i++) {
      setState(() {
        DiscographyModel discographyModel = DiscographyModel(
            id: response[i]["id"],
            number: response[i]["number"],
            title: response[i]["title"],
            date: response[i]["date"],
            description: response[i]["description"]);
        _widgetList.add(discographyModel);
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
        title: const Text('Discografia'),
        backgroundColor: Colors.black38,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add_a_photo),
            iconSize: 40,
            color: Colors.amber,
            splashColor: Colors.yellow,
            tooltip: 'Adicionar disco',
            onPressed: () {
              _addNewDiscography(context);
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
        children: _widgetList.map((DiscographyModel value) {
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
                      image: NetworkImage('${value.id}'),
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
                  child: SizedBox(
                    height: 40.0,
                    width: 40.0,
                    child: FloatingActionButton(
                      mini: false,
                      tooltip: 'Adicionar músicas',
                      child: const Icon(Icons.add_a_photo),
                      backgroundColor: Colors.green,
                      onPressed: () => _redirectDisco(value.id),
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
                      tooltip: 'Remover disco',
                      child: const Icon(Icons.close),
                      backgroundColor: Colors.red,
                      onPressed: () => showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text('Remover disco'),
                          content: Text(
                              'Tem certeza que deseja remover o disco\n${value.description}?'),
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
                                _removeDiscography(value.id);
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
                Padding(
                  padding: const EdgeInsets.fromLTRB(5, 5, 15, 5),
                  child: FloatingActionButton(
                    mini: true,
                    tooltip: 'Remover disco',
                    child: const Icon(Icons.close),
                    backgroundColor: Colors.red,
                    onPressed: () => showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: const Text('Remover disco'),
                        content: Text(
                            'Tem certeza que deseja remover o disco\n${value.title}?'),
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
                              _removeDiscography(value.id);
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

  now() {}
}
