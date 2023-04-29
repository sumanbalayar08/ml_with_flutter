import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

import 'Result.dart';

class ImagePick extends StatefulWidget {
  const ImagePick({super.key});

  @override
  State<ImagePick> createState() => _ImagePickState();
}

class _ImagePickState extends State<ImagePick> {
  File? _pickedImage;
  ImagePicker picker = ImagePicker();
  String recognizedText = '';


  Future<void> _pickAndRecognise(ImageSource source) async {
    final pickedImageFile = await ImagePicker().pickImage(source: source);

    if (pickedImageFile != null) {
      setState(() {
        _pickedImage = File(pickedImageFile.path);
      });
    }
    final inputImage = InputImage.fromFile(File(pickedImageFile!.path));
    final textRecognizer = GoogleMlKit.vision.textRecognizer();
    final visionText = await textRecognizer.processImage(inputImage);

    String text = visionText.text;

    setState(() {
      recognizedText = text;
    });

  }

 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Image Picker")),
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  color: Colors.orangeAccent.withOpacity(0.3),
                  width: MediaQuery.of(context).size.width,
                  height: 300,
                  child: _pickedImage != null
                      ? Image(
                          image: FileImage(_pickedImage!),
                          fit: BoxFit.cover,
                        )
                      : const Center(
                          child: Text("Please Add Image"),
                        ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton.icon(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (_) {
                      return AlertDialog(
                        title: Text(
                          "Complete your action using..",
                        ),
                        actions: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              "Cancel",
                            ),
                          ),
                        ],
                        content: Container(
                          height: 120,
                          child: Column(
                            children: [
                              ListTile(
                                leading: Icon(Icons.camera),
                                title: Text(
                                  "Camera",
                                ),
                                onTap: () {
                                  _pickAndRecognise(ImageSource.camera);
                                  Navigator.of(context).pop();
                                },
                              ),
                              Divider(
                                height: 1,
                                color: Colors.black,
                              ),
                              ListTile(
                                leading: Icon(Icons.image),
                                title: Text(
                                  "Gallery",
                                ),
                                onTap: () {
                                  _pickAndRecognise(ImageSource.gallery);
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    });
              },
              icon: Icon(Icons.add),
              label: Text(
                'Add Image',
              ),
            ),
            const SizedBox(
              height: 15.0,
            ),
            ElevatedButton.icon(
              onPressed: (_pickedImage == null)
                  ? null
                  : () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => Result(text: recognizedText)));
                    },
              icon: Icon(Icons.text_fields),
              label: Text(
                'Get Text',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
