import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:hwscontrol/core/widgets/snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hwscontrol/core/models/schedule_model.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_masked_text2/flutter_masked_text2.dart';

class Schedule extends StatefulWidget {
  const Schedule({Key? key}) : super(key: key);

  @override
  _ScheduleState createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  /* final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final MaskedTextController _dataIniController =
      MaskedTextController(mask: '00/00/0000 00:00');
  final MaskedTextController _dataEndController =
      MaskedTextController(mask: '00/00/0000 00:00');*/
/*  late String _titleValue;
  late String _descriptionValue;
  late String _dataIniValue;
  late String _dataEndValue;*/

  final List<ScheduleModel> _widgetList = [];

  DateTime? _selectedDate;

  Future<void> _addNewSchedule(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (builder, setState) => AlertDialog(
            title: const Text('Adicionar evento'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'Selecione a data do evento',
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        ?.copyWith(color: Colors.tealAccent[100]),
                  ),
                ),
                /*CalendarTimeline(
                  showYears: true,
                  initialDate: _selectedDate!,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                  onDateSelected: (date) {
                    setState(() {
                      _selectedDate = date!;
                    });
                  },
                  leftMargin: 20,
                  monthColor: Colors.white70,
                  dayColor: Colors.teal[200],
                  dayNameColor: const Color(0xFF333A47),
                  activeDayColor: Colors.white,
                  activeBackgroundDayColor: Colors.redAccent[100],
                  dotsColor: const Color(0xFF333A47),
                  selectableDayPredicate: (date) => date.day != 23,
                  locale: 'pt_BR',
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: TextButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.teal[200])),
                    child: const Text('RESET',
                        style: TextStyle(color: Color(0xFF333A47))),
                    onPressed: () => setState(() => _resetSelectedDate()),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                    child: Text('Selected date is $_selectedDate',
                        style: const TextStyle(color: Colors.white)))*/
              ],
            ),
            /* Column(
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
                  maxLength: 10,
                  decoration:
                      const InputDecoration(hintText: "Título (max.100)"),
                ),
                TextField(
                  onChanged: (value) {
                    setState(() {
                      _dataIniValue = value;
                    });
                  },
                  controller: _dataIniController,
                  decoration: const InputDecoration(
                      hintText: "Abertura (DD/MM/YYYY HH:MM)"),
                ),
                TextField(
                  onChanged: (value) {
                    setState(() {
                      _dataEndValue = value;
                    });
                  },
                  controller: _dataEndController,
                  maxLength: 16,
                  decoration: const InputDecoration(
                      hintText: "Fechamento (DD/MM/YYYY HH:MM)"),
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
                  decoration: const InputDecoration(hintText: "Descrição"),
                ),
              ],
            ), */
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
                  // _saveData(_titleValue);
                  Navigator.pop(context);
                },
                child: const Text(
                  'Salvar',
                  style: TextStyle(
                    color: Color.fromARGB(1, 0, 0, 0),
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

    ScheduleModel scheduleModel = ScheduleModel(
        id: dateNow,
        title: _titleText,
        description: _titleText,
        dateini: now,
        dateend: now,
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

  void _resetSelectedDate() {
    _selectedDate = DateTime.now().add(const Duration(days: 5));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _onGetData();
    _resetSelectedDate();
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
            icon: const Icon(Icons.add_a_photo),
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Selecione a data do evento',
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  ?.copyWith(color: Colors.tealAccent[100]),
            ),
          ),
          CalendarTimeline(
            showYears: true,
            initialDate: _selectedDate!,
            firstDate: DateTime.now(),
            lastDate: DateTime.now().add(const Duration(days: 365)),
            onDateSelected: (date) {
              setState(() {
                _selectedDate = date!;
              });
            },
            leftMargin: 20,
            monthColor: Colors.white70,
            dayColor: Colors.teal[200],
            dayNameColor: const Color(0xFF333A47),
            activeDayColor: Colors.white,
            activeBackgroundDayColor: Colors.redAccent[100],
            dotsColor: const Color(0xFF333A47),
            selectableDayPredicate: (date) => date.day != 23,
            locale: 'pt_BR',
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: TextButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.teal[200])),
              child: const Text('RESET',
                  style: TextStyle(color: Color(0xFF333A47))),
              onPressed: () => setState(() => _resetSelectedDate()),
            ),
          ),
          const SizedBox(height: 20),
          Center(
              child: Text('Selected date is $_selectedDate',
                  style: const TextStyle(color: Colors.white)))
        ],
      ),
      /*GridView.count(
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
      ),*/
    );
  }

  now() {}
}
