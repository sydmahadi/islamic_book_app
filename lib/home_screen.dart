import 'package:flutter/material.dart';

import 'book_list_screen.dart';
import 'books.dart';
import 'calculator_screen.dart';
import 'pdf_download_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ইসলামিক বই',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [

          _menuCard(
            context,
            icon: Icons.menu_book,
            title: 'আবেদনপত্রের আগে',
            subtitle: 'এই বিভাগের বইসমূহ',
            category: 'আবেদনপত্রের আগে',
          ),

          _menuCard(
            context,
            icon: Icons.library_books,
            title: 'প্রশ্নপত্রের আগে',
            subtitle: 'এই বিভাগের বইসমূহ',
            category: 'প্রশ্নপত্রের আগে',
          ),

          _menuCard(
            context,
            icon: Icons.auto_stories,
            title: 'শপথের আগে',
            subtitle: 'এই বিভাগের বইসমূহ',
            category: 'শপথের আগে',
          ),

          Card(
            child: ListTile(
              leading: const CircleAvatar(
                child: Icon(Icons.book),
              ),
              title: const Text(
                'রেনেসাঁর ডাক',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text('একটি নির্দিষ্ট বই'),
              trailing: const Icon(Icons.arrow_forward_ios),
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
            ),
          ),

          const SizedBox(height: 8),

          Card(
            child: ListTile(
              leading: const CircleAvatar(
                child: Icon(Icons.calculate),
              ),
              title: const Text(
                'ক্যালকুলেটর',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text(
                'Normal Calculator ও Time Calculator',
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const CalculatorScreen(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _menuCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required String category,
  }) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          child: Icon(icon),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios),
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
      ),
    );
  }
}
