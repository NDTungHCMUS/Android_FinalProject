import 'dart:io';

import 'package:antap/constants.dart';
import 'package:antap/screens/customize_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';


class CustomizeVideoScreen extends StatefulWidget{
  const CustomizeVideoScreen({Key? key}) : super(key: key);
  static String id = 'customize_video_screen';
  @override
  State<CustomizeVideoScreen> createState() => _CustomizeVideoScreenState();
}

class _CustomizeVideoScreenState extends State<CustomizeVideoScreen> {

  final _captionController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  Color? buttonColor;
  File? _video;
  VideoPlayerController? _videoPlayerController;

  @override
  void initState(){
    super.initState();
    _captionController.addListener(updateButtonColor);
  }

  chooseVideo() async {
    final video = await _picker.pickVideo(source: ImageSource.gallery);
    _video = File(video!.path);
    _videoPlayerController = VideoPlayerController.file(_video!)..initialize().then((_) {
      setState(() {
        
      });
      _videoPlayerController!.play();
    });
  }

  void updateButtonColor(){
    setState(() {
      if (_captionController.text.isNotEmpty &&  _video != null){
        buttonColor = kTextColor;
      } else {
        buttonColor = Colors.grey;
      }
    });
  }

  @override
  Widget build(context){
    updateButtonColor();
    return WillPopScope(
      onWillPop: () async {
        Navigator.popAndPushNamed(context, CustomizeScreen.id);
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 30),
              const Text("Create Video", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  autofocus: false,
                  controller: _captionController,
                  decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                        width: 2.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                        width: 2.0,
                      ),
                    ),
                    hintText: 'Enter caption',
                    fillColor: Colors.white,
                    filled: true,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              InkWell(
                onTap: chooseVideo,
                child: (_video == null) ? Container(
                  width: 80.0, // Điều chỉnh kích thước bên trong container theo ý muốn
                  height: 80.0, // Điều chỉnh kích thước bên trong container theo ý muốn
                  decoration: BoxDecoration(
                    shape: BoxShape.circle, // Tạo hình tròn cho container
                    border: Border.all(color: Colors.black, width: 2.0), // Viền đen
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/icons/image_upload.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ) : _videoPlayerController!.value.isInitialized ? AspectRatio(
                      aspectRatio: _videoPlayerController!.value.aspectRatio,
                      child: VideoPlayer(_videoPlayerController!),
                    ) : Container(),
              ),
              const SizedBox(height: 20),
              InkWell(
                onTap: () {
                  if (_video != null && _captionController.text.isNotEmpty){
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const AlertDialog(
                          title: Text("Post Successfully"),
                          content: Text("You can view it now"),
                        );
                      },
                    );
                    _captionController.clear();
                    setState(() {
                      _video = null;
                    });
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20), 
                  decoration: BoxDecoration(
                    color: buttonColor, 
                    borderRadius: BorderRadius.circular(5), 
                    border: Border.all(color: Colors.black), 
                  ),
                  child: const Text(
                    'POST',
                    style: TextStyle(
                      color: Colors.white, // Màu chữ
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      )
    );
  }
}