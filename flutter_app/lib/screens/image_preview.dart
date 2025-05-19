import 'dart:io';
import 'package:flutter/material.dart';

class ImagePreviewPage extends StatelessWidget {
  final String imagePath;

  const ImagePreviewPage({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    final isAsset = imagePath.startsWith("assets/");
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Image Preview"),
      ),
      body: Center(
        child: isAsset
            ? Image.asset(imagePath, fit: BoxFit.contain)
            : Image.file(File(imagePath), fit: BoxFit.contain),
      ),
    );
  }
}
