class CareerExpectation {
  final int id;
  final String jobType;
  final String jobTypeDisplay;
  final String desiredPosition;
  final String desiredIndustry;
  final String desiredCity;
  final double minSalary;
  final double maxSalary;
  final String salaryRange;
  final DateTime createdAt;
  final DateTime updatedAt;

  CareerExpectation({
    required this.id,
    required this.jobType,
    required this.jobTypeDisplay,
    required this.desiredPosition,
    required this.desiredIndustry,
    required this.desiredCity,
    required this.minSalary,
    required this.maxSalary,
    required this.salaryRange,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CareerExpectation.fromJson(Map<String, dynamic> json) {
    return CareerExpectation(
      id: json['id'],
      jobType: json['jobType'],
      jobTypeDisplay: json['jobTypeDisplay'],
      desiredPosition: json['desiredPosition'],
      desiredIndustry: json['desiredIndustry'],
      desiredCity: json['desiredCity'],
      minSalary: (json['minSalary'] ?? 0.0).toDouble(),
      maxSalary: (json['maxSalary'] ?? 0.0).toDouble(),
      salaryRange: json['salaryRange'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'jobType': jobType,
      'desiredPosition': desiredPosition,
      'desiredIndustry': desiredIndustry,
      'desiredCity': desiredCity,
      'minSalary': minSalary,
      'maxSalary': maxSalary,
    };
  }
}

class JobSeekingStatus {
  static const String readyNow = 'READY_NOW';
  static const String withinMonth = 'WITHIN_MONTH';
  static const String consideringOpportunities = 'CONSIDERING_OPPORTUNITIES';
  static const String notSeeking = 'NOT_SEEKING';

  static Map<String, String> getDisplayMap() {
    return {
      readyNow: 'Sẵn sàng nhận việc ngay',
      withinMonth: 'Nhận việc trong tháng',
      consideringOpportunities: 'Xem xét cơ hội mới',
      notSeeking: 'Tạm thời chưa có nhu cầu',
    };
  }
}

class JobTypeOptions {
  static const String fullTime = 'FULL_TIME';
  static const String partTime = 'PART_TIME';
  static const String internship = 'INTERNSHIP';

  static Map<String, String> getDisplayMap() {
    return {
      fullTime: 'Toàn thời gian',
      partTime: 'Bán thời gian',
      internship: 'Thực tập',
    };
  }
}

class SalaryRangeOptions {
  static List<Map<String, dynamic>> getSalaryRanges() {
    return [
      {'key': 'negotiate', 'display': 'Thỏa thuận', 'min': null, 'max': null},
      {'key': '5-10', 'display': '5 - 10 Triệu', 'min': 5.0, 'max': 10.0},
      {'key': '10-15', 'display': '10 - 15 Triệu', 'min': 10.0, 'max': 15.0},
      {'key': '15-20', 'display': '15 - 20 Triệu', 'min': 15.0, 'max': 20.0},
      {'key': '20-25', 'display': '20 - 25 Triệu', 'min': 20.0, 'max': 25.0},
      {'key': '25-30', 'display': '25 - 30 Triệu', 'min': 25.0, 'max': 30.0},
      {'key': '30-35', 'display': '30 - 35 Triệu', 'min': 30.0, 'max': 35.0},
      {'key': '35-40', 'display': '35 - 40 Triệu', 'min': 35.0, 'max': 40.0},
      {'key': '40-45', 'display': '40 - 45 Triệu', 'min': 40.0, 'max': 45.0},
      {'key': '45-50', 'display': '45 - 50 Triệu', 'min': 45.0, 'max': 50.0},
      {'key': '50+', 'display': 'Trên 50 triệu', 'min': 50.0, 'max': null},
    ];
  }
}

class PositionOptions {
  static List<String> getPositions() {
    return [
      'Giáo viên giáo dục sớm',
      'Kế toán/Kiểm toán',
      'Nhân viên bán hàng',
      'Lập trình viên',
      'Thiết kế đồ họa',
      'Marketing/Quảng cáo',
      'Nhân sự/Tuyển dụng',
      'Phiên dịch/Biên dịch',
      'Bác sĩ/Y tá',
      'Kỹ sư xây dựng',
      'Tester/QA',
      'Business Analyst',
      'Product Manager',
      'Data Analyst',
      'DevOps Engineer',
      'UI/UX Designer',
      'Content Writer',
      'SEO Specialist',
      'Social Media Manager',
      'Customer Service',
      'Sales Manager',
      'Project Manager',
      'Khác',
    ];
  }
}

class IndustryOptions {
  static List<String> getIndustries() {
    return [
      'Internet/Thương mại điện tử',
      'Công nghệ thông tin',
      'Giáo dục/Đào tạo',
      'Tài chính/Ngân hàng',
      'Y tế/Dược phẩm',
      'Xây dựng/Kiến trúc',
      'Sản xuất/Chế tạo',
      'Du lịch/Khách sạn',
      'Bán lẻ/Tiêu dùng',
      'Logistics/Vận tải',
      'Bất động sản',
      'Truyền thông/Quảng cáo',
      'Tư vấn/Dịch vụ',
      'Nông nghiệp/Thủy sản',
      'Năng lượng/Môi trường',
      'Thời trang/Mỹ phẩm',
      'Thực phẩm/Đồ uống',
      'Ô tô/Xe máy',
      'Hàng không/Vũ trụ',
      'Game/Giải trí',
      'Blockchain/Cryptocurrency',
      'AI/Machine Learning',
      'Khác',
    ];
  }
}

class CityOptions {
  static List<String> getCities() {
    return [
      'Hà Nội',
      'Hồ Chí Minh',
      'Đà Nẵng',
      'Hải Phòng',
      'Cần Thơ',
      'Biên Hòa',
      'Huế',
      'Nha Trang',
      'Buôn Ma Thuột',
      'Quy Nhon',
      'Vũng Tàu',
      'Nam Định',
      'Việt Trì',
      'Thái Nguyên',
      'Ninh Bình',
      'Hạ Long',
      'Cam Ranh',
      'Rạch Giá',
      'Long Xuyên',
      'Châu Đốc',
      'Hà Tĩnh',
      'Vinh',
      'Đông Hà',
      'Tam Kỳ',
      'Tuy Hòa',
      'Phan Thiết',
      'Bến Tre',
      'Mỹ Tho',
      'Trà Vinh',
      'Sóc Trăng',
      'Cà Mau',
      'Khác',
    ];
  }
}
