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
        padding: const EdgeInsets.fromLTRB(
          16,
          12,
          16,
          30,
        ),
        children: [
          _header(context, dark),

          const SizedBox(height: 20),

          _section(
            context,
            icon: Icons.menu_book_rounded,
            title: 'এই অ্যাপ সম্পর্কে',
            text:
                'এই অ্যাপটি বাংলাদেশ ইসলামী ছাত্রশিবিরের সদস্য সিলেবাসভিত্তিক বিভিন্ন বই ও পাঠ্যসামগ্রী সহজে পড়ার উদ্দেশ্যে তৈরি করা হয়েছে। '
                'বইগুলো বিষয় ও বিভাগ অনুযায়ী সাজানো রয়েছে। প্রয়োজনীয় বই Download করে Offline-এ পড়া যাবে।',
          ),

          _section(
            context,
            icon: Icons.category_rounded,
            title: 'বইয়ের বিভাগ',
            text:
                'সদস্য সিলেবাসের বইগুলো বিভিন্ন বিষয় ও বিভাগ অনুযায়ী সাজানো হয়েছে। '
                'প্রয়োজনীয় বিভাগ নির্বাচন করে সেই বিভাগের বইগুলো সহজেই খুঁজে পাওয়া যাবে।',
          ),

          _section(
            context,
            icon: Icons.download_rounded,
            title: 'বই Download করুন',
            text:
                'প্রয়োজনীয় বই নির্বাচন করে Download করুন। '
                'Google Drive থেকে PDF Download হয়ে অ্যাপের storage-এ সংরক্ষিত হবে। '
                'Download সম্পূর্ণ হলে বইটি Offline-এ পড়তে পারবেন।',
          ),

          _section(
            context,
            icon: Icons.offline_bolt_rounded,
            title: 'Offline Reading',
            text:
                'একবার কোনো বই সম্পূর্ণ Download হয়ে গেলে Internet ছাড়াই বইটি পড়তে পারবেন। '
                'প্রয়োজনে Download করা বই অ্যাপের storage থেকে মুছে দিতে পারবেন।',
          ),

          _section(
            context,
            icon: Icons.bookmark_added_rounded,
            title: 'যেখানে পড়া শেষ করেছেন',
            text:
                'বই পড়ার সময় আপনি যে page-এ ছিলেন সেটি স্বয়ংক্রিয়ভাবে সংরক্ষণ করা হবে। '
                'পরবর্তীতে একই বই আবার খুললে আগেরবার যেখানে পড়া বন্ধ করেছিলেন, '
                'সেখান থেকেই পড়া শুরু করতে পারবেন।',
          ),

          _section(
            context,
            icon: Icons.check_circle_rounded,
            title: 'পড়া হয়েছে হিসেবে Mark',
            text:
                'বই পড়ার সময় Check button ব্যবহার করে বইটিকে “পড়া হয়েছে” হিসেবে Mark করতে পারবেন। '
                'এই status ফোনে সংরক্ষিত থাকবে, তাই পরে বইটি আবার খুললেও status মনে থাকবে।',
          ),

          _section(
            context,
            icon: Icons.swap_vert_rounded,
            title: 'সহজ Page Navigation',
            text:
                'PDF পড়ার সময় আগের ও পরের page-এ সহজে যাওয়া যাবে। '
                'এছাড়া page navigation ব্যবহার করে দ্রুত বিভিন্ন page-এ যাওয়া এবং '
                'নির্দিষ্ট page number লিখে সরাসরি সেই page-এ যাওয়ার সুবিধা রয়েছে।',
          ),

          _section(
            context,
            icon: Icons.picture_as_pdf_rounded,
            title: 'PDF Reader',
            text:
                'Download করা বই সরাসরি অ্যাপের ভিতরের PDF Reader-এ পড়তে পারবেন। '
                'Reader-এর মাধ্যমে বইয়ের page পরিবর্তন, নির্দিষ্ট page-এ যাওয়া এবং '
                'বর্তমান page ও মোট page দেখা যাবে।',
          ),

          _section(
            context,
            icon: Icons.palette_rounded,
            title: 'Dark / Light Mode',
            text:
                'উপরের Theme button ব্যবহার করে Dark Mode এবং Light Mode পরিবর্তন '
                'করতে পারবেন। আপনার পছন্দ অনুযায়ী আরামদায়কভাবে বই পড়তে পারবেন।',
          ),

          const SizedBox(height: 14),

          _developerCard(
            context,
            dark,
          ),

          const SizedBox(height: 24),

          _bottomDecoration(context),
        ],
      ),
    );
  }

  Widget _header(
    BuildContext context,
    bool dark,
  ) {
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
            offset: const Offset(
              0,
              8,
            ),
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
            'সদস্য সিলেবাসের বই',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.w900,
            ),
          ),

          const SizedBox(height: 7),

          const Text(
            'পড়ো তোমার প্রতিপালকের নামে, যিনি সৃষ্টি করেছেন।”
— সূরা আল-আলাক, ৯৬:১',
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
      margin: const EdgeInsets.only(
        bottom: 12,
      ),
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
                        ?.withValues(
                          alpha: 0.72,
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

  Widget _developerCard(
    BuildContext context,
    bool dark,
  ) {
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

  Widget _bottomDecoration(
    BuildContext context,
  ) {
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
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(
                color: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.color
                    ?.withValues(
                      alpha: 0.5,
                    ),
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }
}
