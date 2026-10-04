import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:path_provider/path_provider.dart';

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
  PdfViewerController? _controller;

  int _currentPage = 1;
  int _pageCount = 1;

  bool _isRead = false;
  bool _isLoadingProgress = true;
  bool _showPageBar = true;

  String get _progressFileName => 'pdf_reader_progress.json';

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  // ═══════════════════════════════════════════════
  // PROGRESS FILE
  // ═══════════════════════════════════════════════

  Future<File> _getProgressFile() async {
    final directory = await getApplicationDocumentsDirectory();

    return File(
      '${directory.path}/$_progressFileName',
    );
  }

  Future<Map<String, dynamic>> _readProgressData() async {
    try {
      final file = await _getProgressFile();

      if (!await file.exists()) {
        return {};
      }

      final text = await file.readAsString();

      if (text.trim().isEmpty) {
        return {};
      }

      final decoded = jsonDecode(text);

      if (decoded is Map<String, dynamic>) {
        return decoded;
      }

      return {};
    } catch (_) {
      return {};
    }
  }

  Future<void> _saveProgressData(
    Map<String, dynamic> data,
  ) async {
    try {
      final file = await _getProgressFile();

      await file.writeAsString(
        jsonEncode(data),
        flush: true,
      );
    } catch (_) {
      // Progress save failure should not stop PDF reading.
    }
  }

  // ═══════════════════════════════════════════════
  // LOAD LAST PAGE + READ STATUS
  // ═══════════════════════════════════════════════

  Future<void> _loadProgress() async {
    final data = await _readProgressData();

    final key = widget.file.path;
    final saved = data[key];

    if (saved is Map) {
      final savedPage = saved['page'];
      final savedRead = saved['read'];

      if (savedPage is int && savedPage > 0) {
        _currentPage = savedPage;
      }

      if (savedRead is bool) {
        _isRead = savedRead;
      }
    }

    if (mounted) {
      setState(() {
        _isLoadingProgress = false;
      });
    }
  }

  Future<void> _saveCurrentProgress() async {
    final data = await _readProgressData();

    data[widget.file.path] = {
      'page': _currentPage,
      'read': _isRead,
    };

    await _saveProgressData(data);
  }

  // ═══════════════════════════════════════════════
  // PAGE CHANGED
  // ═══════════════════════════════════════════════

  void _onPageChanged(int? pageNumber) {
    if (pageNumber == null || pageNumber < 1) {
      return;
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _currentPage = pageNumber;
    });

    // Automatically save last reading position.
    _saveCurrentProgress();
  }

  // ═══════════════════════════════════════════════
  // VIEWER READY
  // ═══════════════════════════════════════════════

  void _onViewerReady(
    PdfDocument document,
    PdfViewerController controller,
  ) {
    _controller = controller;

    final count = controller.pageCount;

    if (mounted) {
      setState(() {
        _pageCount = count > 0 ? count : 1;
      });
    }

    // Restore the previous reading page.
    final savedPage = _currentPage.clamp(
      1,
      count > 0 ? count : 1,
    );

    if (savedPage > 1) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || _controller == null) {
          return;
        }

        _controller!.setCurrentPageNumber(savedPage);
      });
    }
  }

  // ═══════════════════════════════════════════════
  // MARK AS READ
  // ═══════════════════════════════════════════════

  Future<void> _toggleReadStatus() async {
    setState(() {
      _isRead = !_isRead;
    });

    await _saveCurrentProgress();

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isRead
              ? '✓ বইটি পড়া শেষ হিসেবে চিহ্নিত করা হয়েছে'
              : 'বইটি আবার পড়া হয়নি হিসেবে চিহ্নিত করা হয়েছে',
        ),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // ═══════════════════════════════════════════════
  // GO TO PAGE
  // ═══════════════════════════════════════════════

  void _goToPage(int page) {
    final controller = _controller;

    if (controller == null) {
      return;
    }

    final maxPage = controller.pageCount;

    if (maxPage <= 0) {
      return;
    }

    final target = page.clamp(1, maxPage);

    controller.setCurrentPageNumber(target);
  }

  void _previousPage() {
    _goToPage(_currentPage - 1);
  }

  void _nextPage() {
    _goToPage(_currentPage + 1);
  }

  // ═══════════════════════════════════════════════
  // PAGE BAR
  // ═══════════════════════════════════════════════

  Widget _buildPageBar(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;

    if (!_showPageBar) {
      return Positioned(
        right: 8,
        top: 0,
        bottom: 0,
        child: Center(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () {
                setState(() {
                  _showPageBar = true;
                });
              },
              child: Container(
                width: 30,
                height: 78,
                decoration: BoxDecoration(
                  color: dark
                      ? const Color(0xEE10291F)
                      : const Color(0xEEFFFFF8),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0x55C9A45C),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.12),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.chevron_left_rounded,
                  color: Color(0xFFC9A45C),
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Positioned(
      right: 7,
      top: 12,
      bottom: 12,
      child: SizedBox(
        width: 52,
        child: Column(
          children: [
            // Hide button
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () {
                  setState(() {
                    _showPageBar = false;
                  });
                },
                child: Container(
                  width: 38,
                  height: 34,
                  decoration: BoxDecoration(
                    color: dark
                        ? const Color(0xEE10291F)
                        : const Color(0xEEFFFFF8),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0x44C9A45C),
                    ),
                  ),
                  child: const Icon(
                    Icons.chevron_right_rounded,
                    size: 20,
                    color: Color(0xFFC9A45C),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 7),

            // Current page
            Container(
              width: 44,
              padding: const EdgeInsets.symmetric(
                horizontal: 4,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: dark
                    ? const Color(0xEE10291F)
                    : const Color(0xEEFFFFF8),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0x44C9A45C),
                ),
              ),
              child: Column(
                children: [
                  Text(
                    '$_currentPage',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFFC9A45C),
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    '/ $_pageCount',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: dark
                          ? Colors.white70
                          : const Color(0xFF18352A),
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // Previous page
            _pageButton(
              context,
              icon: Icons.keyboard_arrow_up_rounded,
              onTap: _previousPage,
            ),

            const SizedBox(height: 6),

            // Vertical draggable scrollbar
            Expanded(
              child: _VerticalPageBar(
                currentPage: _currentPage,
                pageCount: _pageCount,
                isDark: dark,
                onPageChanged: _goToPage,
              ),
            ),

            const SizedBox(height: 6),

            // Next page
            _pageButton(
              context,
              icon: Icons.keyboard_arrow_down_rounded,
              onTap: _nextPage,
            ),
          ],
        ),
      ),
    );
  }

  Widget _pageButton(
    BuildContext context, {
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final dark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(13),
        onTap: onTap,
        child: Container(
          width: 38,
          height: 34,
          decoration: BoxDecoration(
            color: dark
                ? const Color(0xEE10291F)
                : const Color(0xEEFFFFF8),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0x44C9A45C),
            ),
          ),
          child: Icon(
            icon,
            size: 20,
            color: const Color(0xFFC9A45C),
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════
  // APP BAR
  // ═══════════════════════════════════════════════

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;

    return AppBar(
      titleSpacing: 12,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
          ),
          if (_pageCount > 1)
            Text(
              'পৃষ্ঠা $_currentPage / $_pageCount',
              style: TextStyle(
                fontSize: 10.5,
                color: dark
                    ? Colors.white60
                    : const Color(0xFF18352A).withValues(alpha: 0.60),
                fontWeight: FontWeight.w600,
              ),
            ),
        ],
      ),
      actions: [
        // Read status
        IconButton(
          tooltip: _isRead ? 'পড়া শেষ হয়েছে' : 'পড়া শেষ হিসেবে চিহ্নিত করুন',
          onPressed: _toggleReadStatus,
          icon: Icon(
            _isRead
                ? Icons.check_circle_rounded
                : Icons.check_circle_outline_rounded,
            color: _isRead
                ? const Color(0xFF2E8B63)
                : const Color(0xFFC9A45C),
          ),
        ),

        Container(
          margin: const EdgeInsets.only(right: 10),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0x14C9A45C),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            _isRead
                ? Icons.menu_book_rounded
                : Icons.menu_book_outlined,
            color: const Color(0xFFC9A45C),
            size: 21,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;

    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          _saveCurrentProgress();
        }
      },
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: Stack(
          children: [
            Container(
              color: dark
                  ? const Color(0xFF071C14)
                  : const Color(0xFFF1EDE3),
              child: _isLoadingProgress
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFFC9A45C),
                      ),
                    )
                  : PdfViewer.file(
                      widget.file.path,
                      initialPageNumber: _currentPage,
                      onViewerReady: _onViewerReady,
                      controller: _controller,
                      params: PdfViewerParams(
                        onPageChanged: _onPageChanged,
                      ),
                    ),
            ),

            if (!_isLoadingProgress)
              _buildPageBar(context),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// VERTICAL DRAGGABLE PAGE BAR
// ═══════════════════════════════════════════════════════════════

class _VerticalPageBar extends StatefulWidget {
  final int currentPage;
  final int pageCount;
  final bool isDark;
  final ValueChanged<int> onPageChanged;

  const _VerticalPageBar({
    required this.currentPage,
    required this.pageCount,
    required this.isDark,
    required this.onPageChanged,
  });

  @override
  State<_VerticalPageBar> createState() => _VerticalPageBarState();
}

class _VerticalPageBarState extends State<_VerticalPageBar> {
  double _dragPosition = 0;

  @override
  Widget build(BuildContext context) {
    final maxPage =
        widget.pageCount > 1 ? widget.pageCount : 1;

    return LayoutBuilder(
      builder: (context, constraints) {
        final height = constraints.maxHeight;

        final currentRatio =
            (widget.currentPage - 1) / (maxPage - 1);

        final safeRatio = currentRatio.isNaN
            ? 0.0
            : currentRatio.clamp(0.0, 1.0);

        final handleSize = 30.0;
        final trackHeight =
            math.max(1.0, height - handleSize);

        final handleTop = trackHeight * safeRatio;

        return GestureDetector(
          behavior: HitTestBehavior.opaque,

          onTapDown: (details) {
            _changeFromPosition(
              details.localPosition.dy,
              height,
            );
          },

          onVerticalDragStart: (details) {
            _dragPosition = details.localPosition.dy;
          },

          onVerticalDragUpdate: (details) {
            _dragPosition += details.delta.dy;

            _changeFromPosition(
              _dragPosition,
              height,
            );
          },

          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              // Track
              Positioned(
                top: 4,
                bottom: 4,
                child: Container(
                  width: 5,
                  decoration: BoxDecoration(
                    color: widget.isDark
                        ? const Color(0x553B6D59)
                        : const Color(0x33517B68),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              // Progress
              Positioned(
                top: 4,
                height: math.max(
                  2,
                  (height - 8) * safeRatio,
                ),
                child: Container(
                  width: 5,
                  decoration: BoxDecoration(
                    color: const Color(0xFFC9A45C),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              // Handle
              Positioned(
                top: handleTop,
                child: Container(
                  width: handleSize,
                  height: handleSize,
                  decoration: BoxDecoration(
                    color: const Color(0xFFC9A45C),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: widget.isDark
                          ? const Color(0xFF10291F)
                          : const Color(0xFFFFFCF5),
                      width: 3,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.20),
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.menu_book_rounded,
                    size: 13,
                    color: Color(0xFF18352A),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _changeFromPosition(
    double position,
    double height,
  ) {
    if (widget.pageCount <= 1) {
      return;
    }

    final handleSize = 30.0;
    final availableHeight =
        math.max(1.0, height - handleSize);

    final ratio = (position - handleSize / 2) /
        availableHeight;

    final safeRatio = ratio.clamp(0.0, 1.0);

    final page = 1 +
        ((widget.pageCount - 1) * safeRatio).round();

    widget.onPageChanged(
      page.clamp(1, widget.pageCount),
    );
  }
}
