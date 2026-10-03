class Book {
  final String title;
  final String category;
  final String driveUrl;

  const Book({
    required this.title,
    required this.category,
    required this.driveUrl,
  });
}

const List<Book> books = [

  // =========================
  // আবেদনপত্রের আগে
  // =========================

  Book(
    title: 'বই ১',
    category: 'আবেদনপত্রের আগে',
    driveUrl: 'PASTE_GOOGLE_DRIVE_LINK_HERE',
  ),

  Book(
    title: 'বই ২',
    category: 'আবেদনপত্রের আগে',
    driveUrl: 'PASTE_GOOGLE_DRIVE_LINK_HERE',
  ),

  // =========================
  // প্রশ্নপত্রের আগে
  // =========================

  Book(
    title: 'বই ৩',
    category: 'প্রশ্নপত্রের আগে',
    driveUrl: 'PASTE_GOOGLE_DRIVE_LINK_HERE',
  ),

  Book(
    title: 'বই ৪',
    category: 'প্রশ্নপত্রের আগে',
    driveUrl: 'PASTE_GOOGLE_DRIVE_LINK_HERE',
  ),

  // =========================
  // শপথের আগে
  // =========================

  Book(
    title: 'বই ৫',
    category: 'শপথের আগে',
    driveUrl: 'PASTE_GOOGLE_DRIVE_LINK_HERE',
  ),

  Book(
    title: 'বই ৬',
    category: 'শপথের আগে',
    driveUrl: 'PASTE_GOOGLE_DRIVE_LINK_HERE',
  ),
];

const Book renaissanceBook = Book(
  title: 'রেনেসাঁর ডাক',
  category: 'রেনেসাঁর ডাক',
  driveUrl: 'PASTE_RENAISSANCE_GOOGLE_DRIVE_LINK_HERE',
);
