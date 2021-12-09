import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import 'package:hwscontrol/core/widgets/snackbar.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hwscontrol/core/models/media_model.dart';
import 'package:image_picker/image_picker.dart';

class Banners extends StatefulWidget {
  const Banners({Key? key}) : super(key: key);

  @override
  _BannersState createState() => _BannersState();
}

class _BannersState extends State<Banners> {
  // variaveis da tela
  final _picker = ImagePicker();
  List<XFile>? _imageFileList;

  final List<String> _widgetList = [];

  set _imageFile(XFile? value) {
    _imageFileList = value == null ? null : [value];
  }

  // seleciona a imagem do computador
  Future _selectPicture() async {
    try {
      final image = await _picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        setState(() {
          _imageFile = image;
        });
        _uploadImage();
      }
    } catch (e) {
      //
    }
  }

  // faz o envio da imagem para o storage
  Future _uploadImage() async {
    String fileName = _imageFileList![0].name;

    firebase_storage.UploadTask uploadTask;

    firebase_storage.Reference arquive = firebase_storage
        .FirebaseStorage.instance
        .ref()
        .child("banners")
        .child(fileName);

    final metadata = firebase_storage.SettableMetadata(
      contentType: '${_imageFileList![0].mimeType}',
      customMetadata: {'picked-file-path': _imageFileList![0].path},
    );

    uploadTask =
        arquive.putData(await _imageFileList![0].readAsBytes(), metadata);

    MediaModel mediaModel = MediaModel(filename: fileName);

    var uuid = const Uuid();

    FirebaseFirestore db = FirebaseFirestore.instance;
    db.collection("media").doc(uuid.v4()).set(mediaModel.toMap());

    CustomSnackBar(context, Text("Imagem importada com sucesso.\n$fileName"));

    // _getImage();

    return Future.value(uploadTask);
  }

  Future _onGetData() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    var data = await db.collection("media").get();
    var response = data.docs;
    for (int i = 0; i < response.length; i++) {
      setState(() {
        _widgetList.add(response[i]["filename"]);
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
    final double itemHeight = itemWidth / 1.78;
    /*24 is for notification bar on Android*/
    // final double itemHeight = (size.height - kToolbarHeight - 24) / 2;

    return Scaffold(
      backgroundColor: const Color(0XFF666666),
      appBar: AppBar(
        title: const Text('Painel de controle'),
        backgroundColor: Colors.black38,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add_a_photo),
            tooltip: 'Adicionar imagem',
            onPressed: () {
              _selectPicture();
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
        children: _widgetList.map((String value) {
          return Container(
            color: Colors.green,
            margin: const EdgeInsets.all(1.0),
            child: Center(
              child: Image(
                image: NetworkImage(
                    'https://firebasestorage.googleapis.com/v0/b/joao-luiz-correa.appspot.com/o/banners%2F$value?alt=media'),
              ),
            ),
          );
        }).toList(),
      ),
      /*SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 5),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                _selectPicture();
              },
              child: const Text("Nova imagem"),
            ),
            const Text(
              "Recomendamos enviar imagens nas seguintes dimensões: Largura:1600 x Altura: 900",
            ),
            (_imageFileList == null)
            ? const Text(
              'You have not yet picked an image.',
              textAlign: TextAlign.center,
            )
            : Semantics(
              label: 'image_picker_example_picked_image',
              child: kIsWeb
              ? Image.network(_imageFileList![0].path)
              : Image.file(File(_imageFileList![0].path)),
            ),
          ],
        ),
      ),
      bottomNavigationBar: (_errorPicture != null)
      ? Text(
        "$_errorPicture"
      )
      : const Padding(padding: EdgeInsets.zero,),*/
    );
  }
}
