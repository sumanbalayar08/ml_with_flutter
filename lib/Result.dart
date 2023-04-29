import 'package:image_picker/image_picker.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:flutter/material.dart';

class Result extends StatelessWidget {
  final String text;
  Result({Key? key, required this.text,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Result Section"),
      ),
      body: SingleChildScrollView(
        child: Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
                child: Text("${text.toString()}",
                    style: TextStyle(color: Colors.black))),
          ),
        ),
      ),
    );
  }
}
