// imports nativos do flutter
import 'package:flutter/material.dart';
import 'dart:io';

// import dos pacotes
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart';
import 'package:image_picker/image_picker.dart';
import 'package:crop_image/crop_image.dart';

class Banners extends StatefulWidget {
  const Banners({Key? key}) : super(key: key);

  @override
  _BannersState createState() => _BannersState();
}

class _BannersState extends State<Banners> {

  // variaveis da tela
  var _image;
  File? _newImage;
  final _picker = ImagePicker();
  String? _urlImage;
  bool _cropImage = false;

  final _controller = CropController(
    aspectRatio: 1.7777777777777777,
    defaultCrop: const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9),
  );

  // seleciona a imagem do computador
  Future _selectPicture() async {

    final image = await _picker.pickImage(source: ImageSource.gallery);

    if( image != null ){
      setState(() {
        _image = image;
      });
      print("image => $image");
      _uploadImage();
    }

  }

  // faz o envio da imagem para o storage
  Future _uploadImage() async {

    print("_image => ${_image.path}");
    firebase_storage.UploadTask uploadTask;

    firebase_storage.Reference arquive = firebase_storage.FirebaseStorage.instance.ref()
      .child("banners")
      .child(_image.name);

    final metadata = firebase_storage.SettableMetadata(
      contentType: '${_image.mimeType}',
      customMetadata: {'picked-file-path': _image.path},
    );

    uploadTask = arquive.putData(await _image.readAsBytes(), metadata);

    _getImage();

    return Future.value(uploadTask);

  }

  // busca o link da imagem
  _getImage() async {
    String image = await firebase_storage.FirebaseStorage.instance.ref()
      .child("banners")
      .child(_image.name)
      .getDownloadURL();

    setState(() {
      _urlImage = image;
    });

  }

  // controi os botoes de corte
  Widget _buildButtons() => Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      IconButton(
        icon: const Icon(Icons.close),
        onPressed: () {
          _controller.aspectRatio = 1.0;
          _controller.crop = const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9);
        },
      ),
      TextButton(
        onPressed: _finished,
        child: const Text('Done'),
      ),
    ],
  );

  // finaliza o corte da imagem
  Future<void> _finished() async {
    final image = await _controller.croppedImage();
    await showDialog<bool>(
      context: context,
      builder: (context) {
        return SimpleDialog(
          contentPadding: const EdgeInsets.all(6.0),
          titlePadding: const EdgeInsets.all(8.0),
          title: const Text('Cropped image'),
          children: [
            Text('relative: ${_controller.crop}'),
            Text('pixels: ${_controller.cropSize}'),
            const Text("Sua imagem ficou assim"),
            const SizedBox(height: 5),
            image,
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
                // _uploadImage();
                setState(() {
                  _cropImage = false;
                  _image = image;
                });
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    Firebase.initializeApp();
  }

  /*
  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
  */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Galeria"),
      ),

      body: ( _cropImage == false )
      ? SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 5),
        child: Column(
          children: [

            GestureDetector(
              onTap: () {
                _selectPicture();
              },
              child: const Text("Nova imagem"),
            ),

            ( _image == null )
            ? CropImage(
              controller: _controller,
              image: Image.asset("assets/img/login_logo.png"),
            )
            : CropImage(
              controller: _controller,
              image: Image.file(_image!),
            ),

          ],
        )
      )
      : CropImage(
        controller: _controller,
        image: Image.file(_image!),
        // image: Image.file(_newImage!),
        // image: Image.asset("assets/img/login_logo.png"),
      ),
      bottomNavigationBar: ( _cropImage == false )
      ? const Padding(padding: EdgeInsets.zero)
      : _buildButtons(),
    );
  }
}
