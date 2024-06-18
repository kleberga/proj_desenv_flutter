import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class FotoRegistro extends StatefulWidget {
  const FotoRegistro({super.key});
  @override
  State<FotoRegistro> createState() => _FotoRegistroState();
}

class _FotoRegistroState extends State<FotoRegistro> {

  late CameraController _controller;

  Future<void>? _initializeControllerCamera() async {
    WidgetsFlutterBinding.ensureInitialized();
    try{
      var cameras = await availableCameras();
      var camera = cameras.first;
      print(camera);
      _controller = CameraController(camera, ResolutionPreset.medium);
      return _controller.initialize();
    } catch(e){
      return Future.value();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: _initializeControllerCamera(),
          builder: (context, snapshot){
            var connState = snapshot.connectionState;
            if(connState == ConnectionState.done){
              return CameraPreview(_controller);
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }
      ),
      floatingActionButton:
          IconButton(
            iconSize: 50,
            icon: Icon(Icons.camera),
            onPressed: () async {
              try{
                XFile file = await _controller.takePicture();
                Navigator.of(context).pop(file.path);
              } catch(e){
                print(e);
              }
          },
        ),

    );
  }
}
