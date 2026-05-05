class FAQSection {
  final String category;
  final String title;
  final String image;
  final List<FAQItem> questions;

  FAQSection({
    required this.category,
    required this.title,
    required this.image,
    required this.questions,
  });
}

class FAQItem {
  final String question;
  final String answer;

  FAQItem({
    required this.question,
    required this.answer,
  });
}
