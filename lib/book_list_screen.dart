import 'package:flutter/material.dart';

import 'books.dart';
import 'pdf_download_screen.dart';

class BookListScreen extends StatelessWidget {
  final String category;

  const BookListScreen({
    super.key,
    required this.category,
  });

  IconData _categoryIcon() {
    switch (category) {
      case 'আবেদনপত্রের কন্টাক্টের আগে':
        return Icons.edit_document;

      case 'প্রশ্নপত্রের কন্টাক্টের আগে':
        return Icons.quiz_rounded;

      case 'শপথ কন্টাক্টের আগে':
        return Icons.workspace_premium_rounded;

      case 'কোরআন অধ্যয়ন (তাফহীমুল কোরআন)':
        return Icons.menu_book_rounded;

      case 'হাদীস গ্রন্থ':
        return Icons.menu_book_rounded;

      default:
        return Icons.menu_book_rounded;
    }
  }

  String _categoryDescription() {
    switch (category) {
      case 'আবেদনপত্রের কন্টাক্টের আগে':
        return 'এই বিভাগের প্রয়োজনীয় বইগুলো';

      case 'প্রশ্নপত্রের কন্টাক্টের আগে':
        return 'এই বিভাগের প্রয়োজনীয় বইগুলো';

      case 'শপথ কন্টাক্টের আগে':
        return 'এই বিভাগের প্রয়োজনীয় বইগুলো';

      case 'কোরআন অধ্যয়ন (তাফহীমুল কোরআন)':
        return 'এই বিভাগের প্রয়োজনীয় বইগুলো';

      case 'হাদীস গ্রন্থ':
        return 'এই বিভাগের প্রয়োজনীয় বইগুলো';

      default:
        return 'এই বিভাগের বইগুলো';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dark = theme.brightness == Brightness.dark;

    final categoryBooks =
        books.where((book) => book.category == category).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(category),
      ),
      body: categoryBooks.isEmpty
          ? _emptyState(context)
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 30),
              children: [
                _header(
                  context,
                  dark: dark,
                  bookCount: categoryBooks.length,
                ),
                const SizedBox(height: 18),
                ...List.generate(
                  categoryBooks.length,
                  (index) => _bookCard(
                    context,
                    book: categoryBooks[index],
                    index: index,
                    dark: dark,
                  ),
                ),
              ],
            ),
    );
  }

  Widget _header(
    BuildContext context, {
    required bool dark,
    required int bookCount,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: dark
              ? const [
                  Color(0xFF176B45),
                  Color(0xFF0B3826),
                ]
              : const [
                  Color(0xFF176B45),
                  Color(0xFF0F5132),
                ],
        ),
        border: Border.all(
          color: const Color(0x55C9A45C),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: const Color(0xFFC9A45C),
              borderRadius: BorderRadius.circular(17),
            ),
            child: Icon(
              _categoryIcon(),
              color: const Color(0xFF18352A),
              size: 28,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  _categoryDescription(),
                  style: const TextStyle(
                    color: Color(0xD9FFFFFF),
                    fontSize: 12.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '$bookCount টি বই',
                  style: const TextStyle(
                    color: Color(0xFFE3C875),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _bookCard(
    BuildContext context, {
    required Book book,
    required int index,
    required bool dark,
  }) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PdfDownloadScreen(
                book: book,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              // Book number
              Container(
                width: 52,
                height: 64,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: dark
                        ? const [
                            Color(0xFF176B45),
                            Color(0xFF0D432D),
                          ]
                        : const [
                            Color(0xFF176B45),
                            Color(0xFF0F5132),
                          ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.picture_as_pdf_rounded,
                      color: Color(0xFFE3C875),
                      size: 23,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${index + 1}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 14),

              // Book information
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Row(
                      children: [
                        const Icon(
                          Icons.picture_as_pdf_outlined,
                          size: 15,
                          color: Color(0xFFC9A45C),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          'PDF বই',
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.color
                                ?.withValues(alpha: 0.65),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // Arrow
              Container(
                width: 38,
                height: 38,
                decoration: const BoxDecoration(
                  color: Color(0x14C9A45C),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Color(0xFFC9A45C),
                  size: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _emptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: const Color(0x14C9A45C),
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0x44C9A45C),
                ),
              ),
              child: const Icon(
                Icons.menu_book_rounded,
                color: Color(0xFFC9A45C),
                size: 42,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'এই বিভাগে এখনো কোনো বই যোগ করা হয়নি।',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'পরে এখানে বই যোগ করা যাবে।',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.color
                    ?.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
