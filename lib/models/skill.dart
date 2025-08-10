class Skill {
  final int? id;
  final String name;
  final String level; // Beginner, Intermediate, Advanced, Expert
  final String type; // Technical, Language, Soft

  Skill({this.id, required this.name, required this.level, required this.type});

  factory Skill.fromJson(Map<String, dynamic> json) {
    return Skill(
      id: json['id'],
      name: json['name'] ?? '',
      level: json['level'] ?? '',
      type: json['type'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'level': level, 'type': type};
  }
}

// Enum cho skill levels
class SkillLevel {
  static const String beginner = 'Beginner';
  static const String intermediate = 'Intermediate';
  static const String advanced = 'Advanced';
  static const String expert = 'Expert';

  static List<String> getAllLevels() {
    return [beginner, intermediate, advanced, expert];
  }
}

// Enum cho skill types
class SkillType {
  static const String technical = 'Technical';
  static const String language = 'Language';
  static const String soft = 'Soft';

  static List<String> getAllTypes() {
    return [technical, language, soft];
  }
}
