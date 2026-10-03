import 'package:flutter/material.dart';

import 'books.dart';
import 'pdf_download_screen.dart';

class BookListScreen extends StatelessWidget {
  final String category;

  const BookListScreen({
    super.key,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    final categoryBooks =
        books.where((book) => book.category == category).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(category),
      ),
      body: categoryBooks.isEmpty
          ? const Center(
              child: Text(
                'এই বিভাগে এখনো কোনো বই যোগ করা হয়নি।',
                textAlign: TextAlign.center,
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: categoryBooks.length,
              itemBuilder: (context, index) {
                final book = categoryBooks[index];

                return Card(
                  child: ListTile(
                    leading: const CircleAvatar(
                      child: Icon(Icons.picture_as_pdf),
                    ),
                    title: Text(
                      book.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: const Text('PDF বই'),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      size: 18,
                    ),
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
                  ),
                );
              },
            ),
    );
  }
}
