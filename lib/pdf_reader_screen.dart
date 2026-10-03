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
    final dark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0x14C9A45C),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.menu_book_rounded,
              color: Color(0xFFC9A45C),
              size: 21,
            ),
          ),
        ],
      ),
      body: Container(
        color: dark
            ? const Color(0xFF071C14)
            : const Color(0xFFF1EDE3),
        child: PdfViewer.file(
          file.path,
        ),
      ),
    );
  }
}
