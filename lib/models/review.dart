class Review {
  final int rating;
  final String comment;
  final DateTime date;
  final String reviewerName;

  const Review({
    required this.rating,
    required this.comment,
    required this.date,
    required this.reviewerName,
  });

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        rating: (json['rating'] as num).toInt(),
        comment: json['comment'] as String,
        date: DateTime.parse(json['date'] as String),
        reviewerName: json['reviewerName'] as String,
      );
}