import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hwscontrol/core/components/snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hwscontrol/core/models/schedule_model.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
// import 'package:syncfusion_flutter_calendar/calendar.dart';

class Schedule extends StatefulWidget {
  const Schedule({Key? key}) : super(key: key);

  @override
  _ScheduleState createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _placeController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _datainiDaysController = TextEditingController();
  final TextEditingController _datainiTimeController = TextEditingController();
  final TextEditingController _dataendTimeController = TextEditingController();
  final List<ScheduleModel> _widgetList = [];
  final formatDaysDate = DateFormat("dd/MM/yyyy");
  final formatTimeDate = DateFormat("HH:mm");
  String _titleValue = '';
  String _placeValue = '';
  String _descriptionValue = '';
  DateTime? _dataIniValue = DateTime.now();
  DateTime? _dataEndValue = DateTime.now().add(const Duration(hours: 3));
  bool? _viewValue = true;

  Future<void> _addNew(
    BuildContext context,
    itemId,
    itemTitle,
    itemPlace,
    itemDescription,
    itemView,
    itemDataIni,
    itemDataEnd,
  ) async {
    _titleValue = itemTitle.toString();
    _placeValue = itemPlace.toString();
    _descriptionValue = itemDescription.toString();
    _titleController.text = _titleValue;
    _placeController.text = _placeValue;
    _descriptionController.text = _descriptionValue;
    _dataIniValue = itemDataIni.toDate();
    _dataEndValue = itemDataEnd.toDate();
    int diffDate =
        itemDataIni.toDate().difference(itemDataEnd.toDate()).inMinutes;
    int diffDateHour = (diffDate / 60).floor();
    int diffDateMinutes = diffDate - (diffDateHour * 60);
    _datainiDaysController.text =
        DateFormat('dd/MM/yyyy').format(_dataIniValue!);
    _datainiTimeController.text = DateFormat('HH:mm').format(_dataIniValue!);
    _dataendTimeController.text =
        '${diffDateHour.toString().padLeft(2, '0')}:${diffDateMinutes.toString().padLeft(2, '0')}';
    _viewValue = itemView!;
    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (builder, setState) => AlertDialog(
            title: const Text('Adicionar evento'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  onChanged: (value) {
                    setState(() {
                      _titleValue = value;
                    });
                  },
                  controller: _titleController,
                  maxLength: 100,
                  decoration:
                      const InputDecoration(hintText: "Título do evento"),
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
                      'Reservado',
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
                      'Confirmado',
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
                    'Data do evento',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 14.0,
                      fontFamily: 'WorkSansMedium',
                    ),
                  ),
                ),
                DateTimeField(
                  format: formatDaysDate,
                  controller: _datainiDaysController,
                  decoration: const InputDecoration(
                    hintText: "00/00/0000",
                  ),
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                    fontFamily: 'WorkSansMedium',
                  ),
                  onShowPicker: (context, currentValue) async {
                    final date = await showDatePicker(
                      context: context,
                      firstDate: DateTime(DateTime.now().year),
                      initialDate: currentValue ?? DateTime.now(),
                      lastDate: DateTime(DateTime.now().year + 1),
                      confirmText: 'Confirmar',
                      cancelText: 'Cancelar',
                      helpText: 'Data do evento',
                      fieldLabelText: 'Data do evento',
                      fieldHintText: 'DD/MM/AAAA',
                    );
                    if (date != null) {
                      _dataIniValue = DateTimeField.combine(
                        date,
                        TimeOfDay(
                          hour: _dataIniValue!.hour,
                          minute: _dataIniValue!.minute,
                        ),
                      );
                    }
                    return _dataIniValue;
                  },
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Text(
                    'Hora de inicio do evento',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 14.0,
                      fontFamily: 'WorkSansMedium',
                    ),
                  ),
                ),
                DateTimeField(
                  format: formatTimeDate,
                  controller: _datainiTimeController,
                  decoration: const InputDecoration(
                    hintText: "00:00",
                  ),
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                    fontFamily: 'WorkSansMedium',
                  ),
                  onShowPicker: (context, currentValue) async {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(
                        currentValue ?? DateTime.now(),
                      ),
                      confirmText: 'Confirmar',
                      cancelText: 'Cancelar',
                      helpText: 'Hora de inicio do evento',
                    );
                    if (time != null) {
                      _dataIniValue = DateTimeField.combine(
                        _dataIniValue!,
                        time,
                      );
                    }
                    return _dataIniValue;
                  },
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Text(
                    'Tempo estimado de duração',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 14.0,
                      fontFamily: 'WorkSansMedium',
                    ),
                  ),
                ),
                DateTimeField(
                  format: formatTimeDate,
                  controller: _dataendTimeController,
                  decoration: const InputDecoration(
                    hintText: "00:00",
                  ),
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                    fontFamily: 'WorkSansMedium',
                  ),
                  onShowPicker: (context, currentValue) async {
                    var time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(
                        currentValue ?? DateTime.now(),
                      ),
                      confirmText: 'Confirmar',
                      cancelText: 'Cancelar',
                      helpText: 'Tempo estimado de duração',
                    );
                    if (time != null) {
                      _dataEndValue = _dataIniValue;
                      _dataEndValue = _dataEndValue?.add(Duration(
                        hours: time.hour,
                      ));
                      diffDateHour = time.hour;
                      diffDateMinutes = time.minute;
                      _dataEndValue = _dataEndValue?.add(Duration(
                        hours: diffDateHour,
                        minutes: diffDateMinutes,
                      ));
                    } else {
                      time = TimeOfDay(
                        hour: diffDateHour,
                        minute: diffDateMinutes,
                      );
                    }
                    return DateTimeField.combine(
                      _dataEndValue!,
                      time,
                    );
                  },
                ),
                TextField(
                  onChanged: (value) {
                    setState(() {
                      _descriptionValue = value;
                    });
                  },
                  controller: _descriptionController,
                  maxLines: 5,
                  decoration:
                      const InputDecoration(hintText: "Observações (opcional)"),
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
                      _titleValue,
                      _placeValue,
                      _descriptionValue,
                      _dataIniValue,
                      _dataEndValue,
                    ).then((value) => {
                          if (value) {Navigator.pop(context)}
                        });
                    ;
                  } else {
                    _updateData(
                      itemId,
                      _titleValue,
                      _placeValue,
                      _descriptionValue,
                      _dataIniValue,
                      _dataEndValue,
                    ).then((value) => {
                          if (value) {Navigator.pop(context)}
                        });
                    ;
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
    _titleValue,
    _placeValue,
    _descriptionValue,
    _dataIniValue,
    _dataEndValue,
  ) async {
    bool validate = false;
    if (_titleValue.trim().isNotEmpty &&
        _titleValue.trim().length >= 3 &&
        _placeValue.trim().isNotEmpty &&
        _placeValue.trim().length >= 3 &&
        _dataIniValue != null &&
        _dataEndValue != null) {
      validate = true;
      EasyLoading.showInfo(
        'gravando dados...',
        maskType: EasyLoadingMaskType.custom,
      );

      String dateNow = DateFormat('yyyyMMddkkmmss').format(_dataIniValue);
      Timestamp _dataIniTimestamp = Timestamp.fromDate(_dataIniValue);
      Timestamp _dataEndTimestamp = Timestamp.fromDate(_dataEndValue);

      ScheduleModel scheduleModel = ScheduleModel(
          id: dateNow,
          title: _titleValue,
          place: _placeValue,
          description: _descriptionValue,
          dateini: _dataIniTimestamp,
          dateend: _dataEndTimestamp,
          view: _viewValue);

      FirebaseFirestore db = FirebaseFirestore.instance;
      await db.collection("schedule").doc(dateNow).set(scheduleModel.toMap());

      setState(() {
        Timer(const Duration(milliseconds: 1500), () {
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
    _titleValue,
    _placeValue,
    _descriptionValue,
    _dataIniValue,
    _dataEndValue,
  ) async {
    bool validate = false;
    if (_titleValue.trim().isNotEmpty &&
        _titleValue.trim().length >= 3 &&
        _placeValue.trim().isNotEmpty &&
        _placeValue.trim().length >= 3 &&
        _dataIniValue != null &&
        _dataEndValue != null) {
      validate = true;
      EasyLoading.showInfo(
        'atualizando dados...',
        maskType: EasyLoadingMaskType.custom,
      );

      Timestamp _dataIniTimestamp = Timestamp.fromDate(_dataIniValue);
      Timestamp _dataEndTimestamp = Timestamp.fromDate(_dataEndValue);

      FirebaseFirestore db = FirebaseFirestore.instance;

      await db.collection("schedule").doc(_idValue).update({
        "title": _titleValue,
        "place": _placeValue,
        "description": _descriptionValue,
        "dateini": _dataIniTimestamp,
        "dateend": _dataEndTimestamp,
        "view": _viewValue
      });

      setState(() {
        Timer(const Duration(milliseconds: 1500), () {
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

  Future _removeData(idSchedule) async {
    EasyLoading.showInfo(
      'removendo data...',
      maskType: EasyLoadingMaskType.custom,
    );

    FirebaseFirestore db = FirebaseFirestore.instance;

    db.collection("schedule").doc(idSchedule).delete();

    setState(() {
      CustomSnackBar(context, const Text("Data excluida com sucesso."));
      Timer(const Duration(milliseconds: 500), () {
        _getData();
      });
    });
  }

  Future _getData() async {
    _widgetList.clear();
    FirebaseFirestore db = FirebaseFirestore.instance;
    var data = await db.collection("schedule").orderBy('id').get();
    setState(() {
      var response = data.docs;
      if (response.isNotEmpty) {
        for (int i = 0; i < response.length; i++) {
          ScheduleModel scheduleModel = ScheduleModel(
              id: response[i]["id"],
              title: response[i]["title"] ?? '',
              place: response[i]["place"] ?? '',
              description: response[i]["description"] ?? '',
              dateini: response[i]["dateini"] ?? Timestamp.now(),
              dateend: response[i]["dateend"] ?? Timestamp.now(),
              view: response[i]["view"] ?? true);
          _widgetList.add(scheduleModel);
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
        title: const Text('Agenda de Shows'),
        backgroundColor: Colors.black38,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_alarm_rounded),
            iconSize: 40,
            color: Colors.amber,
            splashColor: Colors.yellow,
            tooltip: 'Adicionar data',
            onPressed: () {
              _addNew(
                context,
                '0',
                '',
                '',
                '',
                true,
                Timestamp.now(),
                Timestamp.now(),
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
              children: _widgetList.map((ScheduleModel value) {
                String dateParse =
                    DateFormat('dd/MM/yy').format(value.dateini!.toDate());
                String timeParse =
                    DateFormat('kk:mm').format(value.dateini!.toDate());
                return Container(
                  color: Colors.black26,
                  margin: const EdgeInsets.all(1.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        padding: const EdgeInsets.fromLTRB(25, 5, 5, 5),
                        child: Text.rich(
                          TextSpan(
                            text: dateParse,
                            style: const TextStyle(
                              color: Colors.white30,
                              fontSize: 14.0,
                              fontFamily: 'WorkSansLigth',
                            ),
                            children: [
                              TextSpan(
                                text: '\n$timeParse',
                                style: const TextStyle(
                                  color: Colors.white54,
                                  fontSize: 22.0,
                                  fontFamily: 'WorkSansLigth',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(10, 5, 5, 5),
                          child: Text.rich(
                            TextSpan(
                              text: value.place,
                              style: const TextStyle(
                                color: Colors.amber,
                                fontSize: 16.0,
                                fontFamily: 'WorkSansLigth',
                              ),
                              children: [
                                TextSpan(
                                  text: '\n${value.title}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15.0,
                                    fontFamily: 'WorkSansLigth',
                                  ),
                                ),
                              ],
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
                            tooltip: 'Editar dados',
                            child: const Icon(Icons.edit),
                            backgroundColor: Colors.blue,
                            onPressed: () => _addNew(
                              context,
                              value.id,
                              value.title,
                              value.place,
                              value.description,
                              value.view,
                              value.dateini,
                              value.dateend,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(5, 15, 15, 5),
                        child: SizedBox(
                          height: 25.0,
                          width: 25.0,
                          child: FloatingActionButton(
                            mini: true,
                            tooltip: 'Remover data',
                            child: const Icon(Icons.close),
                            backgroundColor: Colors.red,
                            onPressed: () => showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: const Text('Remover data'),
                                content: Text(
                                    'Tem certeza que deseja remover a data\n${value.title}?'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    style: TextButton.styleFrom(
                                      padding: const EdgeInsets.fromLTRB(
                                          15, 15, 15, 15),
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
                                      padding: const EdgeInsets.fromLTRB(
                                          20, 15, 20, 15),
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
