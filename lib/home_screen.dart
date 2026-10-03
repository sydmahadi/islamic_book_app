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
    final theme = Theme.of(context);
    final dark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: const Color(0xFFC9A45C),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.auto_stories_rounded,
                color: dark ? const Color(0xFF071C14) : Colors.white,
                size: 23,
              ),
            ),
            const SizedBox(width: 10),
            const Text('ইসলামিক বই'),
          ],
        ),
        actions: [
          IconButton(
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
          const SizedBox(width: 6),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 30),
          children: [
            _heroSection(context),

            const SizedBox(height: 24),

            _sectionTitle(
              context,
              icon: Icons.menu_book_rounded,
              title: 'বইয়ের সংগ্রহ',
              subtitle: 'আপনার পছন্দের বিভাগ থেকে বই পড়ুন',
            ),

            const SizedBox(height: 10),

            _categoryCard(
              context,
              icon: Icons.edit_document,
              title: 'আবেদনপত্রের আগে',
              subtitle: 'এই বিভাগের বইসমূহ',
              category: 'আবেদনপত্রের আগে',
              number: '০১',
            ),

            _categoryCard(
              context,
              icon: Icons.quiz_rounded,
              title: 'প্রশ্নপত্রের আগে',
              subtitle: 'এই বিভাগের বইসমূহ',
              category: 'প্রশ্নপত্রের আগে',
              number: '০২',
            ),

            _categoryCard(
              context,
              icon: Icons.workspace_premium_rounded,
              title: 'শপথের আগে',
              subtitle: 'এই বিভাগের বইসমূহ',
              category: 'শপথের আগে',
              number: '০৩',
            ),

            const SizedBox(height: 12),

            _specialBookCard(context),

            const SizedBox(height: 28),

            _sectionTitle(
              context,
              icon: Icons.calculate_rounded,
              title: 'প্রয়োজনীয় টুল',
              subtitle: 'দৈনন্দিন হিসাব সহজ করুন',
            ),

            const SizedBox(height: 10),

            _calculatorCard(context),

            const SizedBox(height: 28),

            _aboutCard(context),

            const SizedBox(height: 24),

            _footer(context),
          ],
        ),
      ),
    );
  }

  Widget _heroSection(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;

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
                  Color(0xFF0B3826),
                  Color(0xFF071C14),
                ]
              : const [
                  Color(0xFF176B45),
                  Color(0xFF0F5132),
                  Color(0xFF0A3C27),
                ],
        ),
        border: Border.all(
          color: const Color(0x66C9A45C),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: dark ? 0.28 : 0.12,
            ),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -25,
            top: -35,
            child: _decorativeCircle(130),
          ),
          Positioned(
            right: 45,
            bottom: -70,
            child: _decorativeCircle(110),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(11),
                    decoration: BoxDecoration(
                      color: const Color(0x22FFFFFF),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0x55C9A45C),
                      ),
                    ),
                    child: const Icon(
                      Icons.nightlight_round,
                      color: Color(0xFFE3C875),
                      size: 25,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'بِسْمِ اللَّهِ',
                    style: TextStyle(
                      color: Color(0xFFE8D49A),
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              const Text(
                'ইসলামিক বই',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.2,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'জ্ঞান, চিন্তা ও আত্মগঠনের\nজন্য একটি সুন্দর পাঠভাণ্ডার',
                style: TextStyle(
                  color: Color(0xD9FFFFFF),
                  fontSize: 15,
                  height: 1.55,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 22),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 9,
                ),
                decoration: BoxDecoration(
                  color: const Color(0x22FFFFFF),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: const Color(0x44C9A45C),
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.offline_bolt_rounded,
                      color: Color(0xFFE3C875),
                      size: 18,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Download করে Offline-এ পড়ুন',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _decorativeCircle(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: const Color(0x18C9A45C),
          width: 18,
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
