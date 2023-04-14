class Expansion {
  final int? id;
  final String? name;

  Expansion.fromJson(Map<String, dynamic>? json)
      : id = json?['id'],
        name = json?['name'];
}