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
        .replaceAll(RegExp(r'[\\/:*?"<>|]'), '_')
        .trim();

    return '$name.pdf';
  }

  Future<Directory> get downloadDirectory async {
    return getApplicationDocumentsDirectory();
  }

  Future<File> get localFile async {
    final dir = await downloadDirectory;
    return File('${dir.path}/$safeFileName');
  }

  Future<bool> isDownloaded() async {
    final file = await localFile;
    return file.exists();
  }

  // Google Drive-এর যেকোনো সাধারণ Share/View link
  // থেকে File ID বের করে Download URL তৈরি করে।
  String convertDriveUrl(String url) {
    final uri = Uri.tryParse(url);

    if (uri == null) {
      return url;
    }

    if (!uri.host.contains('drive.google.com')) {
      return url;
    }

    // Example:
    // https://drive.google.com/file/d/FILE_ID/view
    final segments = uri.pathSegments;

    final dIndex = segments.indexOf('d');

    if (dIndex != -1 && dIndex + 1 < segments.length) {
      final fileId = segments[dIndex + 1];

      return 'https://drive.usercontent.google.com/download'
          '?id=$fileId&export=download&confirm=t';
    }

    // Example:
    // https://drive.google.com/open?id=FILE_ID
    final queryId = uri.queryParameters['id'];

    if (queryId != null && queryId.isNotEmpty) {
      return 'https://drive.usercontent.google.com/download'
          '?id=$queryId&export=download&confirm=t';
    }

    return url;
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

  Future<void> downloadBook() async {
    if (widget.book.driveUrl.trim().isEmpty ||
        widget.book.driveUrl.contains('PASTE_')) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'এই বইয়ের Google Drive link এখনো দেওয়া হয়নি।',
          ),
        ),
      );

      return;
    }

    if (downloading) {
      return;
    }

    setState(() {
      downloading = true;
      progress = 0;
    });

    File? file;

    try {
      final downloadUrl = convertDriveUrl(
        widget.book.driveUrl.trim(),
      );

      final request = http.Request(
        'GET',
        Uri.parse(downloadUrl),
      );

      request.headers.addAll({
        'Accept': 'application/pdf,application/octet-stream,*/*',
        'User-Agent': 'Mozilla/5.0',
      });

      final response = await request.send();

      if (response.statusCode != 200) {
        throw Exception(
          'Server error: ${response.statusCode}',
        );
      }

      final total = response.contentLength ?? 0;

      file = await localFile;

      // আগের অসম্পূর্ণ PDF থাকলে আগে মুছে ফেলি।
      if (await file.exists()) {
        await file.delete();
      }

      final sink = file.openWrite();

      int received = 0;

      try {
        await for (final chunk in response.stream) {
          sink.add(chunk);
          received += chunk.length;

          if (total > 0 && mounted) {
            setState(() {
              progress = received / total;
            });
          }
        }
      } finally {
        await sink.close();
      }

      // File সত্যিই তৈরি হয়েছে কি না যাচাই।
      if (!await file.exists()) {
        throw Exception('PDF file তৈরি করা যায়নি।');
      }

      final fileSize = await file.length();

      if (fileSize == 0) {
        await file.delete();
        throw Exception('Download করা PDF খালি।');
      }

      if (!mounted) return;

      setState(() {
        downloading = false;
        progress = 1;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'বইটি Download হয়েছে। এখন Offline-এ পড়তে পারবেন।',
          ),
        ),
      );
    } catch (e) {
      // Download ব্যর্থ হলে অসম্পূর্ণ file মুছে দিই।
      try {
        if (file != null && await file.exists()) {
          await file.delete();
        }
      } catch (_) {}

      if (!mounted) return;

      setState(() {
        downloading = false;
        progress = 0;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Download করতে সমস্যা হয়েছে।\n$e',
          ),
        ),
        duration: const Duration(seconds: 4),
      );
    }
  }

  Future<void> deleteBook() async {
    final file = await localFile;

    if (await file.exists()) {
      await file.delete();
    }

    if (!mounted) return;

    setState(() {
      progress = 0;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'বইটি ফোন থেকে মুছে দেওয়া হয়েছে।',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('বই'),
      ),
      body: FutureBuilder<bool>(
        future: isDownloaded(),
        builder: (context, snapshot) {
          final downloaded = snapshot.data ?? false;

          return ListView(
            padding: const EdgeInsets.fromLTRB(
              16,
              12,
              16,
              30,
            ),
            children: [
              _bookHeader(
                context,
                dark: dark,
              ),

              const SizedBox(height: 20),

              if (downloading) _downloadProgress(context),

              if (!downloading)
                _actionSection(
                  context,
                  downloaded: downloaded,
                ),

              const SizedBox(height: 22),

              _offlineInfo(context),

              const SizedBox(height: 28),

              _bottomDecoration(context),
            ],
          );
        },
      ),
    );
  }

  Widget _bookHeader(
    BuildContext context, {
    required bool dark,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: dark
              ? const [
                  Color(0xFF176B45),
                  Color(0xFF0A3323),
                  Color(0xFF071C14),
                ]
              : const [
                  Color(0xFF176B45),
                  Color(0xFF0F5132),
                ],
        ),
        border: Border.all(
          color: const Color(0x55C9A45C),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: dark ? 0.25 : 0.10,
            ),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 100,
            height: 120,
            decoration: BoxDecoration(
              color: const Color(0xFFC9A45C),
              borderRadius: BorderRadius.circular(22),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x55000000),
                  blurRadius: 12,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.menu_book_rounded,
                  size: 48,
                  color: Color(0xFF18352A),
                ),
                SizedBox(height: 7),
                Text(
                  'PDF',
                  style: TextStyle(
                    color: Color(0xFF18352A),
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          Text(
            widget.book.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w900,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'ইসলামিক বই',
            style: TextStyle(
              color: Color(0xFFE3C875),
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _downloadProgress(BuildContext context) {
    final percentage = progress * 100;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Icon(
              Icons.downloading_rounded,
              color: Color(0xFFC9A45C),
              size: 42,
            ),
            const SizedBox(height: 12),
            const Text(
              'বই Download হচ্ছে...',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: progress > 0 ? progress : null,
              minHeight: 7,
              borderRadius: BorderRadius.circular(10),
              backgroundColor: const Color(0x220F5132),
              color: const Color(0xFFC9A45C),
            ),
            const SizedBox(height: 10),
            Text(
              progress > 0
                  ? '${percentage.toStringAsFixed(0)}%'
                  : 'Download হচ্ছে...',
              style: const TextStyle(
                color: Color(0xFFC9A45C),
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionSection(
    BuildContext context, {
    required bool downloaded,
  }) {
    if (!downloaded) {
      return Column(
        children: [
          _actionCard(
            context,
            icon: Icons.download_rounded,
            title: 'PDF Download করুন',
            subtitle: 'Download করে Offline-এ পড়ুন',
            primary: true,
            onTap: downloadBook,
          ),
        ],
      );
    }

    return Column(
      children: [
        _actionCard(
          context,
          icon: Icons.menu_book_rounded,
          title: 'বই পড়ুন',
          subtitle: 'Offline-এ বইটি পড়ুন',
          primary: true,
          onTap: openBook,
        ),
        const SizedBox(height: 12),
        _actionCard(
          context,
          icon: Icons.delete_outline_rounded,
          title: 'Download মুছে দিন',
          subtitle: 'ফোনের storage থেকে PDF মুছে ফেলুন',
          primary: false,
          onTap: deleteBook,
        ),
      ],
    );
  }

  Widget _actionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required bool primary,
    required VoidCallback onTap,
  }) {
    final dark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: primary
            ? const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF176B45),
                  Color(0xFF0F5132),
                ],
              )
            : null,
        color: primary
            ? null
            : dark
                ? const Color(0xFF10291F)
                : const Color(0xFFFFFCF5),
        border: Border.all(
          color: primary
              ? const Color(0x55C9A45C)
              : const Color(0x44C9A45C),
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(17),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: primary
                      ? const Color(0xFFC9A45C)
                      : const Color(0x14C9A45C),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  icon,
                  color: primary
                      ? const Color(0xFF18352A)
                      : const Color(0xFFC9A45C),
                  size: 26,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: primary ? Colors.white : null,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: primary
                            ? const Color(0xCCFFFFFF)
                            : Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.color
                                ?.withValues(alpha: 0.65),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: primary
                    ? const Color(0xFFE3C875)
                    : const Color(0xFFC9A45C),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _offlineInfo(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: dark
            ? const Color(0xFF0C241A)
            : const Color(0xFFF2ECDD),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0x33C9A45C),
        ),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.offline_bolt_rounded,
            color: Color(0xFFC9A45C),
            size: 24,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Offline Reading',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'একবার PDF Download হয়ে গেলে Internet ছাড়াই বইটি পড়তে পারবেন।',
                  style: TextStyle(
                    fontSize: 12.5,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _bottomDecoration(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 55,
          height: 2,
          decoration: BoxDecoration(
            color: const Color(0xFFC9A45C),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'পড়ুন • শিখুন • নিজেকে গড়ুন',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.color
                    ?.withValues(alpha: 0.5),
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }
}
