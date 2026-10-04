import 'package:flutter/material.dart';

import 'about_screen.dart';
import 'book_list_screen.dart';
import 'books.dart';
import 'calculator_screen.dart';
import 'pdf_download_screen.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback onToggleTheme;
  final bool isDarkMode;

  const HomeScreen({
    super.key,
    required this.onToggleTheme,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 30),
          children: [
            // Dark / Light Theme Button
            Align(
              alignment: Alignment.topRight,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? const Color(0x22176B45)
                      : const Color(0x14C9A45C),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: const Color(0x44C9A45C),
                  ),
                ),
                child: IconButton(
                  tooltip: isDarkMode ? 'Light Mode' : 'Dark Mode',
                  onPressed: onToggleTheme,
                  icon: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: Icon(
                      isDarkMode
                          ? Icons.light_mode_rounded
                          : Icons.dark_mode_rounded,
                      key: ValueKey(isDarkMode),
                      color: const Color(0xFFC9A45C),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 8),

            // বইয়ের সংগ্রহ
            _sectionTitle(
              context,
              icon: Icons.menu_book_rounded,
              title: 'বইয়ের সংগ্রহ',
              subtitle: 'আপনার পছন্দের বিভাগ থেকে বই পড়ুন',
            ),

            const SizedBox(height: 10),

            // Category 01
            _categoryCard(
              context,
              icon: Icons.edit_document,
              title: 'আবেদনপত্রের আগে',
              subtitle: 'এই বিভাগের বইসমূহ',
              category: 'আবেদনপত্রের আগে',
              number: '০১',
            ),

            // Category 02
            _categoryCard(
              context,
              icon: Icons.quiz_rounded,
              title: 'প্রশ্নপত্রের আগে',
              subtitle: 'এই বিভাগের বইসমূহ',
              category: 'প্রশ্নপত্রের আগে',
              number: '০২',
            ),

            // Category 03
            _categoryCard(
              context,
              icon: Icons.workspace_premium_rounded,
              title: 'শপথের আগে',
              subtitle: 'এই বিভাগের বইসমূহ',
              category: 'শপথের আগে',
              number: '০৩',
            ),

            const SizedBox(height: 12),

            // বিশেষ বই
            _specialBookCard(context),

            const SizedBox(height: 28),

            // প্রয়োজনীয় টুল
            _sectionTitle(
              context,
              icon: Icons.calculate_rounded,
              title: 'প্রয়োজনীয় টুল',
              subtitle: 'দৈনন্দিন হিসাব সহজ করুন',
            ),

            const SizedBox(height: 10),

            // Calculator
            _calculatorCard(context),

            const SizedBox(height: 28),

            // About
            _aboutCard(context),

            const SizedBox(height: 24),

            // Footer
            _footer(context),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color(0x22176B45)
                : const Color(0x14175132),
            borderRadius: BorderRadius.circular(13),
            border: Border.all(
              color: const Color(0x44C9A45C),
            ),
          ),
          child: Icon(
            icon,
            color: const Color(0xFFC9A45C),
            size: 21,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.color
                          ?.withValues(alpha: 0.65),
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _categoryCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required String category,
    required String number,
  }) {
    final dark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BookListScreen(
                category: category,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: dark
                        ? const [
                            Color(0xFF1B7650),
                            Color(0xFF0F5132),
                          ]
                        : const [
                            Color(0xFF176B45),
                            Color(0xFF0F5132),
                          ],
                  ),
                  borderRadius: BorderRadius.circular(17),
                ),
                child: Icon(
                  icon,
                  color: const Color(0xFFE3C875),
                  size: 27,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12.5,
                        color: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.color
                            ?.withValues(alpha: 0.65),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: Color(0x14C9A45C),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  number,
                  style: const TextStyle(
                    color: Color(0xFFC9A45C),
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: Color(0xFFC9A45C),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _specialBookCard(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: dark
              ? const [
                  Color(0xFF241F12),
                  Color(0xFF151C17),
                ]
              : const [
                  Color(0xFFFFF5D9),
                  Color(0xFFFFFCF5),
                ],
        ),
        border: Border.all(
          color: const Color(0x66C9A45C),
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PdfDownloadScreen(
                book: renaissanceBook,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: const Color(0xFFC9A45C),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(
                  Icons.auto_stories_rounded,
                  color: Color(0xFF18352A),
                  size: 29,
                ),
              ),
              const SizedBox(width: 15),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'রেনেসাঁর ডাক',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'বিশেষ বই',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFFC9A45C),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 17,
                color: Color(0xFFC9A45C),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _calculatorCard(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        color: dark
            ? const Color(0xFF10291F)
            : const Color(0xFFFFFCF5),
        border: Border.all(
          color: const Color(0x44C9A45C),
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const CalculatorScreen(),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFC9A45C),
                      Color(0xFFE3C875),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(17),
                ),
                child: const Icon(
                  Icons.calculate_rounded,
                  color: Color(0xFF18352A),
                  size: 28,
                ),
              ),
              const SizedBox(width: 15),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ক্যালকুলেটর',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Normal ও Time Calculator',
                      style: TextStyle(
                        fontSize: 12.5,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 17,
                color: Color(0xFFC9A45C),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _aboutCard(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: dark
              ? const [
                  Color(0xFF241F12),
                  Color(0xFF151C17),
                ]
              : const [
                  Color(0xFFFFF5D9),
                  Color(0xFFFFFCF5),
                ],
        ),
        border: Border.all(
          color: const Color(0x55C9A45C),
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AboutScreen(),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: const Color(0xFFC9A45C),
                  borderRadius: BorderRadius.circular(17),
                ),
                child: const Icon(
                  Icons.info_outline_rounded,
                  color: Color(0xFF18352A),
                  size: 29,
                ),
              ),
              const SizedBox(width: 15),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'অ্যাপ সম্পর্কে',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'অ্যাপ ব্যবহার ও অন্যান্য তথ্য',
                      style: TextStyle(
                        fontSize: 12.5,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 17,
                color: Color(0xFFC9A45C),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _footer(BuildContext context) {
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
                    ?.withValues(alpha: 0.55),
                fontWeight: FontWeight.w600,
              ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
