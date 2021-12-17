import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:hwscontrol/core/widgets/snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hwscontrol/core/models/schedule_model.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
// import 'package:syncfusion_flutter_calendar/calendar.dart';
// import 'package:hwscontrol/core/components/google_places_flutter.dart';
// import 'package:hwscontrol/core/components/models/prediction.dart';
import 'package:google_place/google_place.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Schedule extends StatefulWidget {
  const Schedule({Key? key}) : super(key: key);

  @override
  _ScheduleState createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _placeController = TextEditingController();
  String? _titleValue;
  String? _descriptionValue;
  DateTime? _dataIniValue;
  DateTime? _dataEndValue;
  bool? _viewValue = true;

  final formatDate = DateFormat("yyyy-MM-dd HH:mm");

  GooglePlace? googlePlace;
  String? _placeId;
  // List<AutocompletePrediction> predictions = [];

  late List<AutocompletePrediction> _predictions = [];

  final List<ScheduleModel> _widgetList = [];

  Future<void> _addNewSchedule(BuildContext context) async {
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
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
                        fontSize: 16.0,
                        fontFamily: 'WorkSansMedium',
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
                        fontSize: 16.0,
                        fontFamily: 'WorkSansMedium',
                      ),
                    ),
                  ],
                ),
                TextField(
                  onChanged: (value) {
                    setState(() {
                      if (value.isNotEmpty) {
                        autoCompleteSearch(value);
                      } else {
                        if (_predictions.isNotEmpty && mounted) {
                          setState(() {
                            _predictions = [];
                          });
                        }
                      }
                    });
                  },
                  controller: _placeController,
                  maxLength: 100,
                  decoration:
                      const InputDecoration(hintText: "Local do evento"),
                  /*decoration: const InputDecoration(
                    labelText: "Search",
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue,
                        width: 2.0,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black54,
                        width: 2.0,
                      ),
                    ),
                  ),*/
                  /*onChanged: (value) {
                    if (value.isNotEmpty) {
                      autoCompleteSearch(value);
                    } else {
                      if (_predictions.isNotEmpty && mounted) {
                        setState(() {
                          _predictions = [];
                        });
                      }
                    }
                  },*/
                ),
                /*Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: ListView.builder(
                    itemCount: _predictions.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: const CircleAvatar(
                          child: Icon(
                            Icons.pin_drop,
                            color: Colors.white,
                          ),
                        ),
                        title: Text('${_predictions[index].description}'),
                        onTap: () {
                          _placeId = _predictions[index].placeId;
                          print(_placeId);
                        },
                      );
                    },
                  ),
                ),*/
                const Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Text(
                    'Horário de abertura',
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
                        _dataIniValue = DateTimeField.combine(date, time);
                        return _dataIniValue;
                      }
                    }
                    return currentValue;
                  },
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Text(
                    'Horário de término',
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
                        _dataEndValue = DateTimeField.combine(date, time);
                        return _dataEndValue;
                      }
                    }
                    return currentValue;
                  },
                ),
                TextField(
                  onChanged: (value) {
                    setState(() {
                      _descriptionValue = value;
                    });
                  },
                  controller: _descriptionController,
                  maxLength: 16,
                  maxLines: 5,
                  decoration: const InputDecoration(hintText: "Observações"),
                ),
              ],
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
                  _saveData(_titleValue, _dataIniValue, _dataEndValue,
                      _descriptionValue);
                  Navigator.pop(context);
                },
                child: const Text(
                  'Salvar',
                  style: TextStyle(
                    color: Color.fromARGB(0, 0, 0, 0),
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

  Future autoCompleteSearch(String value) async {
    var result = await googlePlace?.autocomplete.get(value);
    setState(() {
      print(result);
      if (result != null && result.predictions != null && mounted) {
        _predictions = result.predictions!;
        print(_predictions[0].description);
      }
    });
  }

  // faz o envio da imagem para o storage
  Future _saveData(
      _titleValue, _dataIniValue, _dataEndValue, _descriptionValue) async {
    if (_titleValue.trim().isNotEmpty &&
        _titleValue.trim().length >= 3 &&
        _descriptionValue.trim().isNotEmpty &&
        _descriptionValue.trim().length >= 3 &&
        _dataIniValue != null &&
        _dataEndValue != null) {
      _onSaveData(_titleValue, _dataIniValue, _dataEndValue, _descriptionValue);
    } else {
      CustomSnackBar(
          context, const Text('Preencha todos dados e tente novamente!'),
          backgroundColor: Colors.red);
    }
    return Future.value(true);
  }

  Future _onSaveData(
      _titleValue, _dataIniValue, _dataEndValue, _descriptionValue) async {
    String dateNow = DateFormat('yyyyMMddkkmmss').format(_dataIniValue);

    ScheduleModel scheduleModel = ScheduleModel(
        id: dateNow,
        title: _titleValue,
        description: _descriptionValue,
        dateini: _dataIniValue,
        dateend: _dataEndValue,
        view: true);

    FirebaseFirestore db = FirebaseFirestore.instance;
    db.collection("schedule").doc(dateNow).set(scheduleModel.toMap());

    setState(() {
      CustomSnackBar(context, const Text("Data adicionada com sucesso."));
      Timer(const Duration(milliseconds: 1500), () {
        _onGetData();
      });
    });

    return Future.value(true);
  }

  Future _removeSchedule(idSchedule) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    db.collection("schedule").doc(idSchedule).delete();
    setState(() {
      CustomSnackBar(context, const Text("Data excluida com sucesso."));
      Timer(const Duration(milliseconds: 500), () {
        _onGetData();
      });
    });
  }

  Future _onGetData() async {
    _widgetList.clear();
    FirebaseFirestore db = FirebaseFirestore.instance;
    var data =
        await db.collection("schedule").orderBy('date', descending: true).get();
    var response = data.docs;
    for (int i = 0; i < response.length; i++) {
      setState(() {
        ScheduleModel scheduleModel = ScheduleModel(
            id: response[i]["id"],
            title: response[i]["title"],
            description: response[i]["description"],
            dateini: response[i]["dateini"],
            dateend: response[i]["dateend"],
            view: response[i]["view"]);
        _widgetList.add(scheduleModel);
      });
    }
  }

  Future _getEnv() async {
    // await DotEnv().load(fileName: '.env');
    String? apiKey = 'AIzaSyB3RoRyyHmYtqp2CqhohJN9zIWkhYPJaMM';
    // DotEnv().env['API_KEY'];
    // googlePlace = GooglePlace(apiKey);
    googlePlace = GooglePlace(apiKey, proxyUrl: 'cors-anywhere.herokuapp.com');
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _onGetData();
    _getEnv();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemWidth = size.width;
    const double itemHeight = 100;

    return Scaffold(
      backgroundColor: const Color(0XFF666666),
      appBar: AppBar(
        title: const Text('Agenda de Shows'),
        backgroundColor: Colors.black38,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add_alarm_rounded),
            iconSize: 40,
            color: Colors.amber,
            splashColor: Colors.yellow,
            tooltip: 'Adicionar data',
            onPressed: () {
              _addNewSchedule(context);
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
        children: _widgetList.map((ScheduleModel value) {
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
                  padding: const EdgeInsets.fromLTRB(5, 5, 15, 5),
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
                              _removeSchedule(value.id);
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
