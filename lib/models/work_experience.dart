class WorkExperience {
  final int? id;
  final String companyName;
  final String position;
  final String startDate;
  final String? endDate;
  final bool isCurrentJob;
  final String? description;

  WorkExperience({
    this.id,
    required this.companyName,
    required this.position,
    required this.startDate,
    this.endDate,
    this.isCurrentJob = false,
    this.description,
  });

  factory WorkExperience.fromJson(Map<String, dynamic> json) {
    return WorkExperience(
      id: json['id'],
      companyName: json['companyName'] ?? '',
      position: json['position'] ?? '',
      startDate: json['startDate'] ?? '',
      endDate: json['endDate'],
      isCurrentJob: json['isCurrentJob'] ?? false,
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'companyName': companyName,
      'position': position,
      'startDate': startDate,
      'endDate': endDate,
      'isCurrentJob': isCurrentJob,
      'description': description,
    };
  }
}
