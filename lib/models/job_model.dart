class Job {
  final int? id; // id có thể null khi tạo mới
  final String iconUrl;
  final String title;
  final String company;
  final String salary;
  final String location;
  final String postDate;
  final String status;
  final String description;

  Job({
    this.id,
    required this.iconUrl,
    required this.title,
    required this.company,
    required this.salary,
    required this.location,
    required this.postDate,
    required this.status,
    required this.description,
  });

  factory Job.fromMap(Map<String, dynamic> map) {
    return Job(
      id: map['id'] as int?,
      iconUrl: map['iconUrl'],
      title: map['title'],
      company: map['company'],
      salary: map['salary'],
      location: map['location'],
      postDate: map['postDate'],
      status: map['status'],
      description: map['description'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id, // chỉ thêm khi có id
      'iconUrl': iconUrl,
      'title': title,
      'company': company,
      'salary': salary,
      'location': location,
      'postDate': postDate,
      'status': status,
      'description': description,
    };
  }

  Job copyWith({
    int? id,
    String? iconUrl,
    String? title,
    String? company,
    String? salary,
    String? location,
    String? postDate,
    String? status,
    String? description,
  }) {
    return Job(
      id: id ?? this.id,
      iconUrl: iconUrl ?? this.iconUrl,
      title: title ?? this.title,
      company: company ?? this.company,
      salary: salary ?? this.salary,
      location: location ?? this.location,
      postDate: postDate ?? this.postDate,
      status: status ?? this.status,
      description: description ?? this.description,
    );
  }
}
