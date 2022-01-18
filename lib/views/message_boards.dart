import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hwscontrol/core/components/snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hwscontrol/core/models/message_boards_model.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

class MessageBoards extends StatefulWidget {
  const MessageBoards({Key? key}) : super(key: key);

  @override
  _MessageBoardsState createState() => _MessageBoardsState();
}

class _MessageBoardsState extends State<MessageBoards> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _placeController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  final List<MessageBoardsModel> _widgetList = [];
  final formatDate = DateFormat("yyyy-MM-dd HH:mm");
  String? _nameValue;
  String? _placeValue;
  String? _messageValue;
  DateTime? _dataValue;
  bool? _viewValue = true;

  Future<void> _dialogData(
    BuildContext context,
    itemId,
    itemName,
    itemPlace,
    itemData,
    itemMessage,
    itemView,
  ) async {
    _nameValue = itemName;
    _placeValue = itemPlace;
    _dataValue = itemData.toDate();
    _messageValue = itemMessage;
    _viewValue = itemView;
    _nameController.text = _nameValue!;
    _placeController.text = _placeValue!;
    _messageController.text = _messageValue!;
    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (builder, setState) => AlertDialog(
            title: const Text('Adicionar recado'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  autofocus: true,
                  onChanged: (value) {
                    setState(() {
                      _nameValue = value;
                    });
                  },
                  controller: _nameController,
                  maxLength: 100,
                  decoration: const InputDecoration(hintText: "Nome"),
                ),
                const Text(
                  'Status:',
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
                      value: false,
                      groupValue: _viewValue,
                      onChanged: (value) {
                        setState(() {
                          _viewValue = value as bool?;
                        });
                      },
                    ),
                    const Text(
                      'Em análise',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14.0,
                        fontFamily: 'WorkSansMedium',
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    Radio(
                      value: true,
                      groupValue: _viewValue,
                      onChanged: (value) {
                        setState(() {
                          _viewValue = value as bool?;
                        });
                      },
                    ),
                    const Text(
                      'Aprovado',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14.0,
                        fontFamily: 'WorkSansMedium',
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
                TextField(
                  autofocus: true,
                  onChanged: (value) {
                    setState(() {
                      _placeValue = value;
                    });
                  },
                  controller: _placeController,
                  maxLength: 100,
                  decoration: const InputDecoration(hintText: "Cidade / UF"),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Text(
                    'Data',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 14.0,
                      fontFamily: 'WorkSansMedium',
                    ),
                  ),
                ),
                DateTimeField(
                  format: formatDate,
                  decoration:
                      const InputDecoration(hintText: "0000-00-00 00:00"),
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                    fontFamily: 'WorkSansMedium',
                  ),
                  onShowPicker: (context, currentValue) async {
                    if (itemId != 0) {
                      if (currentValue == null) {
                        final date = await showDatePicker(
                          context: context,
                          firstDate: DateTime(DateTime.now().year),
                          initialDate: currentValue ?? DateTime.now(),
                          lastDate: DateTime(DateTime.now().year + 1),
                        );
                        if (date != null) {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(
                              currentValue ?? DateTime.now(),
                            ),
                          );
                          _dataValue = DateTimeField.combine(date, time);
                          return _dataValue;
                        }
                      }
                    }
                    return currentValue;
                  },
                ),
                TextField(
                  onChanged: (value) {
                    setState(() {
                      _messageValue = value;
                    });
                  },
                  controller: _messageController,
                  maxLines: 5,
                  decoration: const InputDecoration(hintText: "Mensagem"),
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
                  if (itemId == 0) {
                    _saveData(
                      _nameValue,
                      _placeValue,
                      _messageValue,
                      _dataValue,
                      _viewValue,
                    ).then(
                      (value) => {
                        if (value) {Navigator.pop(context)}
                      },
                    );
                  } else {
                    _updateData(
                      itemId,
                      _nameValue,
                      _placeValue,
                      _messageValue,
                      _dataValue,
                      _viewValue,
                    ).then(
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

  Future<bool> _saveData(
    _nameValue,
    _placeValue,
    _messageValue,
    _dataValue,
    _viewValue,
  ) async {
    bool validate = false;
    if (_nameValue.trim().isNotEmpty &&
        _nameValue.trim().length >= 3 &&
        _messageValue.trim().isNotEmpty &&
        _messageValue.trim().length >= 3 &&
        _placeValue.trim().isNotEmpty &&
        _placeValue.trim().length >= 3 &&
        _dataValue != null) {
      validate = true;
      EasyLoading.showInfo(
        'gravando dados...',
        maskType: EasyLoadingMaskType.custom,
        dismissOnTap: false,
        duration: const Duration(seconds: 10),
      );

      String dateNow = DateFormat('yyyyMMddkkmmss').format(_dataValue);

      Timestamp _dataTimestamp = Timestamp.fromDate(_dataValue);

      MessageBoardsModel messageBoardsModel = MessageBoardsModel(
          id: dateNow,
          name: _nameValue,
          place: _placeValue,
          message: _messageValue,
          date: _dataTimestamp,
          view: _viewValue);

      FirebaseFirestore db = FirebaseFirestore.instance;
      db
          .collection("messageboards")
          .doc(dateNow)
          .set(messageBoardsModel.toMap());

      setState(() {
        Timer(const Duration(milliseconds: 500), () {
          _getData();
        });
      });
    } else {
      CustomSnackBar(
          context, const Text('Preencha todos dados e tente novamente!'),
          backgroundColor: Colors.red);
    }
    return Future.value(validate);
  }

  Future<bool> _updateData(
    _idValue,
    _nameValue,
    _placeValue,
    _messageValue,
    _dataValue,
    _viewValue,
  ) async {
    bool validate = false;
    if (_nameValue.trim().isNotEmpty &&
        _nameValue.trim().length >= 3 &&
        _messageValue.trim().isNotEmpty &&
        _messageValue.trim().length >= 3 &&
        _placeValue.trim().isNotEmpty &&
        _placeValue.trim().length >= 3 &&
        _dataValue != null) {
      validate = true;
      EasyLoading.showInfo(
        'atualizando dados...',
        maskType: EasyLoadingMaskType.custom,
        dismissOnTap: false,
        duration: const Duration(seconds: 10),
      );

      FirebaseFirestore db = FirebaseFirestore.instance;
      db.collection("messageboards").doc(_idValue).update({
        "name": _nameValue,
        "place": _placeValue,
        "message": _messageValue,
        "view": _viewValue
      });

      setState(() {
        Timer(const Duration(milliseconds: 500), () {
          _getData();
        });
      });
    } else {
      CustomSnackBar(
          context, const Text('Preencha todos dados e tente novamente!'),
          backgroundColor: Colors.red);
    }
    return Future.value(validate);
  }

  _dialogDelete(MessageBoardsModel value) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Remover recado'),
        content:
            Text('Tem certeza que deseja remover o recado\n${value.name}?'),
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
              _removeData(value.id);
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
      'removendo imagem...',
      maskType: EasyLoadingMaskType.custom,
      dismissOnTap: false,
      duration: const Duration(seconds: 10),
    );

    await FirebaseFirestore.instance
        .collection("messageboards")
        .doc(itemId)
        .delete();

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
        .collection("messageboards")
        .orderBy('id', descending: true)
        .get();
    setState(() {
      var response = data.docs;
      if (response.isNotEmpty) {
        for (int i = 0; i < response.length; i++) {
          MessageBoardsModel messageBoardsModel = MessageBoardsModel(
              id: response[i]["id"],
              name: response[i]["name"],
              place: response[i]["place"],
              message: response[i]["message"],
              date: response[i]["date"],
              view: response[i]["view"]);
          _widgetList.add(messageBoardsModel);
        }
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
        title: const Text('Mural de Recados'),
        backgroundColor: Colors.black38,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            iconSize: 40,
            color: Colors.amber,
            splashColor: Colors.yellow,
            tooltip: 'Adicionar recado',
            onPressed: () {
              _dialogData(
                context,
                0,
                '',
                '',
                Timestamp.now(),
                '',
                true,
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
              children: _widgetList.map((MessageBoardsModel value) {
                return Container(
                  color: Colors.black26,
                  margin: const EdgeInsets.all(1.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        padding: const EdgeInsets.fromLTRB(15, 5, 5, 5),
                        child: Text(
                          DateFormat('dd/MM/yy kk:mm')
                              .format(value.date!.toDate()),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14.0,
                            fontFamily: 'WorkSansLigth',
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(15, 5, 5, 5),
                        child: Text(
                          '${value.name}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14.0,
                            fontFamily: 'WorkSansLigth',
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(10, 5, 5, 5),
                          child: Text(
                            '${value.message}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14.0,
                              fontFamily: 'WorkSansLigth',
                            ),
                          ),
                        ),
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
                              value.name,
                              value.place,
                              value.date,
                              value.message,
                              value.view,
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
                            tooltip: 'Remover recado',
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
