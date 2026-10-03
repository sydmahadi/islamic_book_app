import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('অ্যাপ সম্পর্কে'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 30),
        children: [
          _header(context, dark),
          const SizedBox(height: 20),

          _section(
            context,
            icon: Icons.menu_book_rounded,
            title: 'এই অ্যাপ সম্পর্কে',
            text:
                'ইসলামিক বই অ্যাপটি ইসলামিক ও শিক্ষামূলক বই সহজে পড়ার জন্য তৈরি করা হয়েছে। '
                'প্রয়োজনীয় বইগুলো Download করে ফোনে সংরক্ষণ করা যাবে এবং পরে Internet ছাড়াই পড়া যাবে।',
          ),

          _section(
            context,
            icon: Icons.download_rounded,
            title: 'বই কীভাবে পড়বেন',
            text:
                'প্রথমে প্রয়োজনীয় বিভাগের বই নির্বাচন করুন। এরপর বইয়ের পেজ থেকে '
                'Download করুন। Download সম্পূর্ণ হলে “বই পড়ুন” অপশন থেকে PDF খুলে পড়তে পারবেন।',
          ),

          _section(
            context,
            icon: Icons.offline_bolt_rounded,
            title: 'Offline Reading',
            text:
                'একবার কোনো PDF সম্পূর্ণ Download হয়ে গেলে Internet ছাড়াই সেই বই পড়তে পারবেন। '
                'প্রয়োজনে Download করা বই ফোনের storage থেকে মুছেও দিতে পারবেন।',
          ),

          _section(
            context,
            icon: Icons.calculate_rounded,
            title: 'Calculator',
            text:
                'অ্যাপের Calculator অংশে Normal Calculator এবং Time Calculator রয়েছে। '
                'Time Calculator-এ ১.২০ অর্থ ১ ঘণ্টা ২০ মিনিট। '
                'যেমন: ১.২০ + ১.৫৫ = ৩ ঘণ্টা ১৫ মিনিট।',
          ),

          _section(
            context,
            icon: Icons.category_rounded,
            title: 'বইয়ের বিভাগ',
            text:
                'বইগুলো বিভিন্ন বিভাগে সাজানো হয়েছে, যাতে প্রয়োজনীয় বই দ্রুত খুঁজে পাওয়া যায়। '
                'এছাড়াও “রেনেসাঁর ডাক” নামে একটি বিশেষ বইয়ের আলাদা অপশন রয়েছে।',
          ),

          _section(
            context,
            icon: Icons.palette_rounded,
            title: 'Dark / Light Mode',
            text:
                'উপরের Theme button ব্যবহার করে Dark Mode এবং Light Mode পরিবর্তন করতে পারবেন। '
                'আপনার পছন্দ অনুযায়ী আরামদায়কভাবে অ্যাপ ব্যবহার করুন।',
          ),

          const SizedBox(height: 14),

          _developerCard(context, dark),

          const SizedBox(height: 24),

          _bottomDecoration(context),
        ],
      ),
    );
  }

  Widget _header(BuildContext context, bool dark) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF176B45),
            Color(0xFF0F5132),
            Color(0xFF0B3826),
          ],
        ),
        border: Border.all(
          color: const Color(0x66C9A45C),
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
            width: 82,
            height: 82,
            decoration: BoxDecoration(
              color: const Color(0xFFC9A45C),
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Icon(
              Icons.auto_stories_rounded,
              color: Color(0xFF18352A),
              size: 42,
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            'ইসলামিক বই',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 7),
          const Text(
            'জ্ঞান • পাঠ • আত্মগঠন',
            textAlign: TextAlign.center,
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

  Widget _section(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String text,
  }) {
    final dark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: dark
            ? const Color(0xFF10291F)
            : const Color(0xFFFFFCF5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0x33C9A45C),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: const Color(0x14C9A45C),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              icon,
              color: const Color(0xFFC9A45C),
              size: 23,
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
                const SizedBox(height: 7),
                Text(
                  text,
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.55,
                    color: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.color
                        ?.withValues(alpha: 0.72),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _developerCard(BuildContext context, bool dark) {
    return Container(
      padding: const EdgeInsets.all(20),
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
      child: Column(
        children: [
          const Icon(
            Icons.code_rounded,
            color: Color(0xFFC9A45C),
            size: 30,
          ),
          const SizedBox(height: 10),
          const Text(
            'Developed by',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFFC9A45C),
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'Talpatar Sepai',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'm.talpatarsepai@gmail.com',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
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
          textAlign: TextAlign.center,
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
