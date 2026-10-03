import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import 'books.dart';
import 'pdf_reader_screen.dart';

class PdfDownloadScreen extends StatefulWidget {
  final Book book;

  const PdfDownloadScreen({
    super.key,
    required this.book,
  });

  @override
  State<PdfDownloadScreen> createState() => _PdfDownloadScreenState();
}

class _PdfDownloadScreenState extends State<PdfDownloadScreen> {
  bool downloading = false;
  double progress = 0;

  String get safeFileName {
    final name = widget.book.title
        .replaceAll(RegExp(r'[\\/:*?"<>|]'), '_');

    return '$name.pdf';
  }

  Future<Directory> get downloadDirectory async {
    return getApplicationDocumentsDirectory();
  }

  Future<File> get localFile async {
    final dir = await downloadDirectory;
    return File('${dir.path}/$safeFileName');
  }

  Future<void> openBook() async {
    final file = await localFile;

    if (!await file.exists()) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('বইটি আগে Download করুন।'),
        ),
      );

      return;
    }

    if (!mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PdfReaderScreen(
          title: widget.book.title,
          file: file,
        ),
      ),
    );
  }

  String convertDriveUrl(String url) {
    final uri = Uri.tryParse(url);

    if (uri == null) {
      return url;
    }

    if (uri.host.contains('drive.google.com')) {
      final segments = uri.pathSegments;

      final index = segments.indexOf('d');

      if (index != -1 && index + 1 < segments.length) {
        final fileId = segments[index + 1];

        return 'https://drive.google.com/uc?export=download&id=$fileId';
      }

      final id = uri.queryParameters['id'];

      if (id != null && id.isNotEmpty) {
        return 'https://drive.google.com/uc?export=download&id=$id';
      }
    }

    return url;
  }

  Future<void> downloadBook() async {
    if (widget.book.driveUrl.contains('PASTE_')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('এই বইয়ের Google Drive link এখনো দেওয়া হয়নি।'),
        ),
      );

      return;
    }

    setState(() {
      downloading = true;
      progress = 0;
    });

    try {
      final url = convertDriveUrl(widget.book.driveUrl);

      final request = http.Request(
        'GET',
        Uri.parse(url),
      );

      final response = await request.send();

      if (response.statusCode != 200) {
        throw Exception(
          'Download failed: ${response.statusCode}',
        );
      }

      final total = response.contentLength ?? 0;

      final file = await localFile;

      final sink = file.openWrite();

      int received = 0;

      await for (final chunk in response.stream) {
        sink.add(chunk);

        received += chunk.length;

        if (total > 0 && mounted) {
          setState(() {
            progress = received / total;
          });
        }
      }

      await sink.close();

      if (!mounted) return;

      setState(() {
        downloading = false;
        progress = 1;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('বইটি Download হয়েছে। এখন Offline-এ পড়তে পারবেন।'),
        ),
      );
    } catch (e) {
      setState(() {
        downloading = false;
        progress = 0;
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Download করতে সমস্যা হয়েছে: $e'),
        ),
      );
    }
  }

  Future<bool> isDownloaded() async {
    final file = await localFile;
    return file.exists();
  }

  Future<void> deleteBook() async {
    final file = await localFile;

    if (await file.exists()) {
      await file.delete();
    }

    if (!mounted) return;

    setState(() {});

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('বইটি ফোন থেকে মুছে দেওয়া হয়েছে।'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.book.title),
      ),
      body: FutureBuilder<bool>(
        future: isDownloaded(),
        builder: (context, snapshot) {
          final downloaded = snapshot.data ?? false;

          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(height: 40),

                const Icon(
                  Icons.picture_as_pdf,
                  size: 90,
                ),

                const SizedBox(height: 25),

                Text(
                  widget.book.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 15),

                Text(
                  downloaded
                      ? 'বইটি ফোনে সংরক্ষিত আছে।'
                      : 'Offline পড়ার জন্য প্রথমে বইটি Download করুন।',
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 30),

                if (downloading) ...[
                  LinearProgressIndicator(
                    value: progress > 0 ? progress : null,
                  ),

                  const SizedBox(height: 12),

                  Text(
                    progress > 0
                        ? '${(progress * 100).toStringAsFixed(0)}%'
                        : 'Download হচ্ছে...',
                  ),

                  const SizedBox(height: 20),
                ],

                if (!downloaded && !downloading)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.download),
                      label: const Text('Download PDF'),
                      onPressed: downloadBook,
                    ),
                  ),

                if (downloaded && !downloading) ...[
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.menu_book),
                      label: const Text('বই পড়ুন'),
                      onPressed: openBook,
                    ),
                  ),

                  const SizedBox(height: 12),

                  OutlinedButton.icon(
                    icon: const Icon(Icons.delete_outline),
                    label: const Text('Download মুছে দিন'),
                    onPressed: deleteBook,
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
