import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pdfrx/pdfrx.dart';

class PdfReaderScreen extends StatelessWidget {
  final String title;
  final File file;

  const PdfReaderScreen({
    super.key,
    required this.title,
    required this.file,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: PdfViewer.file(
        file.path,
      ),
    );
  }
}
