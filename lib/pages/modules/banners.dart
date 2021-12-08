// imports nativos do flutter
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';

// import dos pacotes
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart';
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
  String? _errorPicture;

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
      _errorPicture = e.toString();
    }
  }

  // faz o envio da imagem para o storage
  Future _uploadImage() async {
    firebase_storage.UploadTask uploadTask;

    firebase_storage.Reference arquive = firebase_storage
      .FirebaseStorage.instance
      .ref()
      .child("banners")
      .child(_imageFileList![0].name);

    final metadata = firebase_storage.SettableMetadata(
      contentType: '${_imageFileList![0].mimeType}',
      customMetadata: {'picked-file-path': _imageFileList![0].path},
    );

    uploadTask =
        arquive.putData(await _imageFileList![0].readAsBytes(), metadata);

    // _getImage();

    return Future.value(uploadTask);
  }

  /*
  // busca o link da imagem
  _getImage() async {
    String image = await firebase_storage.FirebaseStorage.instance.ref()
      .child("banners")
      .child(_imageFileList![0].name)
      .getDownloadURL();

    setState(() {
      _urlImage = image;
    });

  }
  */

  @override
  void initState() {
    super.initState();
    Firebase.initializeApp();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Galeria"),
      ),
      body: SingleChildScrollView(
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
      : const Padding(padding: EdgeInsets.zero,),
    );
  }
}
