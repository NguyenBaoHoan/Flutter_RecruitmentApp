class UserProfile {
  final int id;
  final String name;
  final String email;
  final String phone;
  final int age;
  final String? avatar;
  final String? address;
  final String? bio;

  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.age,
    this.avatar,
    this.address,
    this.bio,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      age: json['age'] ?? 0,
      avatar: json['avatar'],
      address: json['address'],
      bio: json['bio'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'age': age,
      'avatar': avatar,
      'address': address,
      'bio': bio,
    };
  }
}
