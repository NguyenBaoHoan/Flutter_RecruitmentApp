class Company {
  final int id;
  final String name;
  final String? description;
  final String address;
  final String? logo;

  Company({
    required this.id,
    required this.name,
    this.description,
    required this.address,
    required this.logo,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      address: json['address'],
      logo: json['logo'],
    );
  }
}
