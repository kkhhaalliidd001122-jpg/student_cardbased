class Major {
  final String id;
  final String name;

  Major({required this.id, required this.name});

  factory Major.fromJson(Map<String, dynamic> json) {
    return Major(
      id: json['id'].toString(),
      name: json['name'] ?? '',
    );
  }
}
