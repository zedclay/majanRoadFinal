class Trip {
  final String name;
  final double rating;
  final String location;
  final double price;
  final String description;
  final String tripImage;
  final String startDate;
  final String endDate;
  final List<String> categories;
  final List<String> whatsIncluded;
  final List<String> whatsNotIncluded;
  final List<String> whatToBring;
  final List<String> cancellationRefundPolicy;

  Trip({
    required this.name,
    required this.rating,
    required this.location,
    required this.price,
    required this.description,
    required this.tripImage,
    required this.startDate,
    required this.endDate,
    required this.categories,
    required this.whatsIncluded,
    required this.whatsNotIncluded,
    required this.whatToBring,
    required this.cancellationRefundPolicy,
  });

  int get duration {
    DateTime start = DateTime.parse(startDate);
    DateTime end = DateTime.parse(endDate);
    return end.difference(start).inDays;
  }
}
