import 'dart:async';
import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PdfReaderScreen extends StatefulWidget {
  final String title;
  final File file;

  const PdfReaderScreen({
    super.key,
    required this.title,
    required this.file,
  });

  @override
  State<PdfReaderScreen> createState() => _PdfReaderScreenState();
}

class _PdfReaderScreenState extends State<PdfReaderScreen> {
  late final PdfViewerController _controller;

  int _currentPage = 1;
  int _pageCount = 0;

  bool _isRead = false;
  bool _loadingProgress = true;
  bool _viewerReady = false;

  String get _pageKey {
    return 'pdf_last_page_${widget.file.path}';
  }

  String get _readKey {
    return 'pdf_read_${widget.file.path}';
  }

  @override
  void initState() {
    super.initState();

    _controller = PdfViewerController();

    _loadSavedProgress();
  }

  Future<void> _loadSavedProgress() async {
    final prefs = await SharedPreferences.getInstance();

    final savedPage = prefs.getInt(_pageKey) ?? 1;
    final savedRead = prefs.getBool(_readKey) ?? false;

    if (!mounted) return;

    setState(() {
      _currentPage = math.max(1, savedPage);
      _isRead = savedRead;
      _loadingProgress = false;
    });
  }

  Future<void> _saveCurrentPage(int page) async {
    if (page < 1) return;

    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt(
      _pageKey,
      page,
    );
  }

  Future<void> _toggleReadStatus() async {
    final newValue = !_isRead;

    setState(() {
      _isRead = newValue;
    });

    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(
      _readKey,
      newValue,
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          newValue
              ? 'বইটি পড়া হয়েছে হিসেবে সংরক্ষণ করা হয়েছে।'
              : 'বইটির পড়া হয়েছে চিহ্নটি সরানো হয়েছে।',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _onViewerReady(
    PdfDocument document,
    PdfViewerController controller,
  ) {
    if (!mounted) return;

    final count = controller.pageCount;

    setState(() {
      _viewerReady = true;
      _pageCount = count;

      if (_currentPage > count) {
        _currentPage = count;
      }

      if (_currentPage < 1) {
        _currentPage = 1;
      }
    });

    if (_currentPage > 1 && _currentPage <= count) {
      Future.delayed(
        const Duration(milliseconds: 250),
        () {
          if (!mounted) return;

          controller.goToPage(
            pageNumber: _currentPage,
          );
        },
      );
    }
  }

  void _onPageChanged(int? pageNumber) {
    if (pageNumber == null || pageNumber < 1) {
      return;
    }

    if (!mounted) return;

    setState(() {
      _currentPage = pageNumber;
    });

    unawaited(
      _saveCurrentPage(pageNumber),
    );
  }

  void _goToPage(int page) {
    if (!_viewerReady || _pageCount <= 0) {
      return;
    }

    final target = page.clamp(
      1,
      _pageCount,
    );

    _controller.goToPage(
      pageNumber: target,
    );
  }

  void _previousPage() {
    if (_currentPage > 1) {
      _goToPage(
        _currentPage - 1,
      );
    }
  }

  void _nextPage() {
    if (_currentPage < _pageCount) {
      _goToPage(
        _currentPage + 1,
      );
    }
  }

  void _showPageInput() {
    if (_pageCount <= 0) {
      return;
    }

    final controller = TextEditingController(
      text: _currentPage.toString(),
    );

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'পৃষ্ঠা নির্বাচন করুন',
          ),
          content: TextField(
            controller: controller,
            autofocus: true,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'পৃষ্ঠা নম্বর',
              hintText: '১ - $_pageCount',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onSubmitted: (_) {
              _submitPageInput(
                dialogContext,
                controller,
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('বাতিল'),
            ),
            ElevatedButton(
              onPressed: () {
                _submitPageInput(
                  dialogContext,
                  controller,
                );
              },
              child: const Text('যান'),
            ),
          ],
        );
      },
    ).whenComplete(
      controller.dispose,
    );
  }

  void _submitPageInput(
    BuildContext dialogContext,
    TextEditingController inputController,
  ) {
    final page = int.tryParse(
      inputController.text.trim(),
    );

    if (page == null || page < 1 || page > _pageCount) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '১ থেকে $_pageCount এর মধ্যে একটি page দিন।',
          ),
        ),
      );
      return;
    }

    Navigator.pop(dialogContext);

    _goToPage(page);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dark = theme.brightness == Brightness.dark;

    if (_loadingProgress) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          IconButton(
            tooltip: _isRead
                ? 'পড়া হয়নি হিসেবে চিহ্নিত করুন'
                : 'পড়া হয়েছে হিসেবে চিহ্নিত করুন',
            onPressed: _toggleReadStatus,
            icon: Icon(
              _isRead
                  ? Icons.check_circle_rounded
                  : Icons.check_circle_outline_rounded,
              color: _isRead
                  ? const Color(0xFFC9A45C)
                  : null,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(
              right: 10,
            ),
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
        child: Stack(
          children: [
            Positioned.fill(
              child: PdfViewer.file(
                widget.file.path,
                controller: _controller,
                initialPageNumber: _currentPage,
                params: PdfViewerParams(
                  backgroundColor: dark
                      ? const Color(0xFF071C14)
                      : const Color(0xFFF1EDE3),
                  margin: 8,
                  pageDropShadow: const BoxShadow(
                    color: Colors.black38,
                    blurRadius: 5,
                    spreadRadius: 1,
                    offset: Offset(
                      1,
                      2,
                    ),
                  ),
                  onViewerReady: _onViewerReady,
                  onPageChanged: _onPageChanged,
                ),
              ),
            ),

            // Top page indicator
            Positioned(
              top: 12,
              left: 12,
              right: 12,
              child: IgnorePointer(
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: dark
                          ? const Color(0xDD10291F)
                          : const Color(0xEEFFFFFC),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0x55C9A45C),
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x22000000),
                          blurRadius: 8,
                          offset: Offset(
                            0,
                            3,
                          ),
                        ),
                      ],
                    ),
                    child: Text(
                      _pageCount > 0
                          ? 'পৃষ্ঠা $_currentPage / $_pageCount'
                          : 'পৃষ্ঠা $_currentPage',
                      style: TextStyle(
                        color: dark
                            ? const Color(0xFFF4EFE3)
                            : const Color(0xFF18352A),
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Right side page navigation
            Positioned(
              top: 75,
              right: 7,
              bottom: 82,
              child: _pageNavigationBar(
                dark: dark,
              ),
            ),

            // Bottom controls
            Positioned(
              left: 12,
              right: 12,
              bottom: 12,
              child: _bottomControls(
                dark: dark,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _pageNavigationBar({
    required bool dark,
  }) {
    final backgroundColor = dark
        ? const Color(0xE610291F)
        : const Color(0xEFFFFCF5);

    return Container(
      width: 48,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0x55C9A45C),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 10,
            offset: Offset(
              0,
              3,
            ),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 8,
      ),
      child: Column(
        children: [
          _smallControlButton(
            icon: Icons.keyboard_arrow_up_rounded,
            onPressed: _previousPage,
          ),
          const SizedBox(height: 5),
          Expanded(
            child: _verticalPageSlider(
              dark: dark,
            ),
          ),
          const SizedBox(height: 5),
          _smallControlButton(
            icon: Icons.keyboard_arrow_down_rounded,
            onPressed: _nextPage,
          ),
        ],
      ),
    );
  }

  Widget _verticalPageSlider({
    required bool dark,
  }) {
    if (_pageCount <= 1) {
      return const Center(
        child: Icon(
          Icons.drag_handle_rounded,
          color: Color(0xFFC9A45C),
          size: 20,
        ),
      );
    }

    final max = _pageCount.toDouble();
    final value = _currentPage
        .clamp(1, _pageCount)
        .toDouble();

    return RotatedBox(
      quarterTurns: 3,
      child: SliderTheme(
        data: SliderTheme.of(context).copyWith(
          trackHeight: 4,
          activeTrackColor: const Color(0xFFC9A45C),
          inactiveTrackColor: dark
              ? const Color(0x445A806E)
              : const Color(0x445A806E),
          thumbColor: const Color(0xFFC9A45C),
          overlayColor: const Color(0x22C9A45C),
          thumbShape: const RoundSliderThumbShape(
            enabledThumbRadius: 7,
          ),
          overlayShape: const RoundSliderOverlayShape(
            overlayRadius: 14,
          ),
        ),
        child: Slider(
          min: 1,
          max: max,
          divisions: _pageCount - 1,
          value: value,
          onChanged: (newValue) {
            _goToPage(
              newValue.round(),
            );
          },
        ),
      ),
    );
  }

  Widget _smallControlButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onPressed,
        child: SizedBox(
          width: 36,
          height: 36,
          child: Icon(
            icon,
            color: const Color(0xFFC9A45C),
            size: 24,
          ),
        ),
      ),
    );
  }

  Widget _bottomControls({
    required bool dark,
  }) {
    return Container(
      height: 58,
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
      ),
      decoration: BoxDecoration(
        color: dark
            ? const Color(0xE610291F)
            : const Color(0xF5FFFFFC),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0x55C9A45C),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 12,
            offset: Offset(
              0,
              4,
            ),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            tooltip: 'আগের পৃষ্ঠা',
            onPressed: _currentPage > 1
                ? _previousPage
                : null,
            icon: const Icon(
              Icons.chevron_left_rounded,
            ),
          ),
          Expanded(
            child: Center(
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: _showPageInput,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 7,
                  ),
                  child: Text(
                    _pageCount > 0
                        ? '$_currentPage / $_pageCount'
                        : '$_currentPage',
                    style: TextStyle(
                      color: dark
                          ? const Color(0xFFF4EFE3)
                          : const Color(0xFF18352A),
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
            ),
          ),
          IconButton(
            tooltip: 'পরের পৃষ্ঠা',
            onPressed: _pageCount > 0 &&
                    _currentPage < _pageCount
                ? _nextPage
                : null,
            icon: const Icon(
              Icons.chevron_right_rounded,
            ),
          ),
        ],
      ),
    );
  }
}
