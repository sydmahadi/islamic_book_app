import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'about_screen.dart';
import 'book_list_screen.dart';

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
      body: Stack(
        children: [
          // Islamic geometric background
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(
                painter: IslamicPatternPainter(
                  isDark: dark,
                ),
              ),
            ),
          ),

          SafeArea(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 30),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        // Theme button
                        Align(
                          alignment: Alignment.topRight,
                          child: Container(
                            decoration: BoxDecoration(
                              color: dark
                                  ? const Color(0x22176B45)
                                  : const Color(0x14C9A45C),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: const Color(0x44C9A45C),
                              ),
                            ),
                            child: IconButton(
                              tooltip:
                                  isDarkMode ? 'Light Mode' : 'Dark Mode',
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

                        const SizedBox(height: 12),

                        // Header
                        _buildHeader(context),

                        const SizedBox(height: 24),

                        // Section title
                        _sectionTitle(
                          context,
                          icon: Icons.menu_book_rounded,
                          title: 'বইয়ের সংগ্রহ',
                          subtitle: 'আপনার পছন্দের বিভাগ থেকে বই পড়ুন',
                        ),

                        const SizedBox(height: 14),

                        // 3-column category grid
                        _categoryGrid(context),

                        const SizedBox(height: 24),

                        // About
                        _aboutCard(context),

                        const SizedBox(height: 28),

                        // Footer
                        _footer(context),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: dark
              ? const [
                  Color(0xFF123D2A),
                  Color(0xFF0B2A1D),
                ]
              : const [
                  Color(0xFFEAF5EE),
                  Color(0xFFFFFBF0),
                ],
        ),
        border: Border.all(
          color: const Color(0x55C9A45C),
        ),
        boxShadow: [
          BoxShadow(
            color: dark
                ? Colors.black.withValues(alpha: 0.20)
                : const Color(0x22175132),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              color: const Color(0xFFC9A45C),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFC9A45C).withValues(alpha: 0.25),
                  blurRadius: 12,
                ),
              ],
            ),
            child: const Icon(
              Icons.auto_stories_rounded,
              color: Color(0xFF18352A),
              size: 31,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ইসলামিক বই',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.2,
                      ),
                ),
                const SizedBox(height: 5),
                Text(
                  'পড়ুন • শিখুন • নিজেকে গড়ুন',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.color
                            ?.withValues(alpha: 0.68),
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    final dark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: dark
                ? const Color(0x22176B45)
                : const Color(0x14175132),
            borderRadius: BorderRadius.circular(13),
            border: Border.all(
              color: const Color(0x44C9A45C),
            ),
          ),
          child: const Icon(
            Icons.menu_book_rounded,
            color: Color(0xFFC9A45C),
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

  Widget _categoryGrid(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 0.82,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _categoryCard(
          context,
          icon: Icons.edit_document,
          title: 'আবেদনপত্রের\nকন্টাক্টের আগে',
          category: 'আবেদনপত্রের কন্টাক্টের আগে',
          number: '০১',
        ),
        _categoryCard(
          context,
          icon: Icons.quiz_rounded,
          title: 'প্রশ্নপত্রের\nকন্টাক্টের আগে',
          category: 'প্রশ্নপত্রের কন্টাক্টের আগে',
          number: '০২',
        ),
        _categoryCard(
          context,
          icon: Icons.workspace_premium_rounded,
          title: 'শপথ\nকন্টাক্টের আগে',
          category: 'শপথ কন্টাক্টের আগে',
          number: '০৩',
        ),
        _categoryCard(
          context,
          icon: Icons.menu_book_rounded,
          title: 'কোরআন অধ্যয়ন\n(তাফহীমুল কোরআন)',
          category: 'কোরআন অধ্যয়ন (তাফহীমুল কোরআন)',
          number: '০৪',
        ),
        _categoryCard(
          context,
          icon: Icons.auto_stories_rounded,
          title: 'হাদীস\nগ্রন্থ',
          category: 'হাদীস গ্রন্থ',
          number: '০৫',
        ),
      ],
    );
  }

  Widget _categoryCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String category,
    required String number,
  }) {
    final dark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
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
        child: Container(
          padding: const EdgeInsets.fromLTRB(9, 12, 9, 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            color: dark
                ? const Color(0xCC10291F)
                : const Color(0xEFFFFCF5),
            border: Border.all(
              color: const Color(0x44C9A45C),
            ),
            boxShadow: [
              BoxShadow(
                color: dark
                    ? Colors.black.withValues(alpha: 0.12)
                    : const Color(0x18175132),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF176B45),
                      Color(0xFF0F5132),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  icon,
                  color: const Color(0xFFE3C875),
                  size: 25,
                ),
              ),
              const SizedBox(height: 9),
              Expanded(
                child: Center(
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12.5,
                      height: 1.25,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: const Color(0x14C9A45C),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  number,
                  style: const TextStyle(
                    color: Color(0xFFC9A45C),
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _aboutCard(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AboutScreen(),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(17),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
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
            boxShadow: [
              BoxShadow(
                color: dark
                    ? Colors.black.withValues(alpha: 0.15)
                    : const Color(0x18175132),
                blurRadius: 14,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 55,
                height: 55,
                decoration: BoxDecoration(
                  color: const Color(0xFFC9A45C),
                  borderRadius: BorderRadius.circular(17),
                ),
                child: const Icon(
                  Icons.info_outline_rounded,
                  color: Color(0xFF18352A),
                  size: 28,
                ),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'অ্যাপ সম্পর্কে',
                      style: TextStyle(
                        fontSize: 16,
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

/// Subtle Islamic geometric pattern for the app background.
class IslamicPatternPainter extends CustomPainter {
  final bool isDark;

  IslamicPatternPainter({
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8
      ..color = isDark
          ? const Color(0x0DFFFFFF)
          : const Color(0x12175132);

    const double spacing = 82;

    for (double y = -spacing; y < size.height + spacing; y += spacing) {
      for (double x = -spacing; x < size.width + spacing; x += spacing) {
        _drawIslamicStar(
          canvas,
          Offset(x, y),
          28,
          paint,
        );
      }
    }
  }

  void _drawIslamicStar(
    Canvas canvas,
    Offset center,
    double radius,
    Paint paint,
  ) {
    final path = Path();

    const int points = 8;

    for (int i = 0; i < points * 2; i++) {
      final angle = (-math.pi / 2) + (math.pi / points * i);
      final currentRadius = i.isEven ? radius : radius * 0.48;

      final point = Offset(
        center.dx + math.cos(angle) * currentRadius,
        center.dy + math.sin(angle) * currentRadius,
      );

      if (i == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }

    path.close();

    canvas.drawPath(path, paint);

    // Inner diamond pattern
    final inner = Path();

    for (int i = 0; i < 4; i++) {
      final angle = (-math.pi / 4) + (math.pi / 2 * i);

      final point = Offset(
        center.dx + math.cos(angle) * radius * 0.48,
        center.dy + math.sin(angle) * radius * 0.48,
      );

      if (i == 0) {
        inner.moveTo(point.dx, point.dy);
      } else {
        inner.lineTo(point.dx, point.dy);
      }
    }

    inner.close();

    canvas.drawPath(inner, paint);
  }

  @override
  bool shouldRepaint(covariant IslamicPatternPainter oldDelegate) {
    return oldDelegate.isDark != isDark;
  }
}
