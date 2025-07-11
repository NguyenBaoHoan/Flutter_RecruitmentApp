// lib/models/job_model.dart

class Job {
  final String iconUrl; // Trong ví dụ này, chúng ta sẽ dùng icon mặc định
  final String title;
  final String company;
  final String salary;
  final String location;
  final String postDate;

  Job({
    required this.iconUrl,
    required this.title,
    required this.company,
    required this.salary,
    required this.location,
    required this.postDate,
  });
}
