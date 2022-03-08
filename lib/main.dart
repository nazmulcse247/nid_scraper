import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? _imagePath;
  ImageSource _imageSource = ImageSource.camera;
  List<String> _lines = [];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NID Scraper',
      home: Scaffold(
        appBar: AppBar(
          title: Text('NID Scpaer'),
          actions: [
            TextButton(
                onPressed: (){},
                child: Text(
                  'Next',
                  style: TextStyle(color: Colors.white) ,

                )
            )
          ],
        ),
        body: Column(
          children: [

            Padding(
              padding: EdgeInsets.all(8.0),
              child: Container(
                width: double.maxFinite,
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey,width: 2)
                ),

                child: _imagePath == null ? null :Image.file(File(_imagePath!),width: double.maxFinite,height: 200,fit: BoxFit.cover,),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: (){
                      _imageSource = ImageSource.camera;
                      _pickImage();
                    },
                    child: Text('Camera')
                ),
                SizedBox(
                  width: 5,
                ),
                ElevatedButton(
                    onPressed: (){
                      _imageSource = ImageSource.gallery;
                      _pickImage();
                    },
                    child: Text('Gallery')
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _lines.length,
                  itemBuilder: (context, index) => ListTile(
                    title: Text(_lines[index]),
                  )
              ),
            )
          ],
        ),
      ),

    );
  }

  void _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: _imageSource);

    if(pickedFile != null){
      setState(() {
        _imagePath = pickedFile.path;
      });
      final txtDetector = GoogleMlKit.vision.textDetector();
      final inputImgae = InputImage.fromFilePath(_imagePath!);
      final recognizedText = await txtDetector.processImage(inputImgae);
      print(recognizedText.text);
      var lines = <String>[];
      for(var block in recognizedText.blocks){
        for(var line in block.lines){
          lines.add(line.text);
        }
      }
     setState(() {
       _lines = lines;
     });
    }
  }
}


