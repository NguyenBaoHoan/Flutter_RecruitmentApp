class Job {
  final String title;
  final String salary;
  final String location;
  final String experience;
  final String educationLevel;
  final String jobType;
  final String postedDate;
  final List<String> description;
  final List<String> requirements;
  final List<String> benefits;
  final String workAddress;
  final String companyName;
  final String companyLogoAsset;
  final String locationCompany;
  final String companySize;
  final String companyIndustry;

  Job({
    required this.title,
    required this.salary,
    required this.location,
    required this.experience,
    required this.educationLevel,
    required this.jobType,
    required this.postedDate,
    required this.description,
    required this.requirements,
    required this.benefits,
    required this.workAddress,
    required this.companyName,
    required this.companyLogoAsset,
    required this.locationCompany,
    required this.companySize,
    required this.companyIndustry,
  });

  // Dữ liệu mẫu để hiển thị
  static Job get sampleJob => Job(
        title: 'Back-End Developer',
        salary: '20-35 Triệu',
        location: 'Thủ Đức - Hồ Chí Minh',
        experience: '1 đến 3 năm',
        educationLevel: 'Cao đẳng',
        jobType: 'Toàn thời gian',
        postedDate: '15 ngày trước',
        description: [
          'Thiết kế, xây dựng và duy trì hệ thống backend, API và cơ sở dữ liệu phục vụ các ứng dụng web/mobile.',
          'Tối ưu hóa hiệu suất, bảo mật và khả năng mở rộng của hệ thống.',
          'Hợp tác chặt chẽ với Front-end Developers, QA và các bộ phận liên quan để triển khai tính năng mới.',
          'Tham gia phân tích yêu cầu, thiết kế hệ thống và đưa ra giải pháp kỹ thuật phù hợp.',
          'Đảm bảo chất lượng mã nguồn theo tiêu chuẩn lập trình và quy trình CI/CD của công ty.',
        ],
        requirements: [
          'Tối thiểu 2 năm kinh nghiệm làm việc ở vị trí Back-End Developer.',
          'Thành thạo ít nhất một ngôn ngữ lập trình: C/C++, Python, Java, JavaScript (ES6).',
          'Kinh nghiệm phát triển ứng dụng web và quen thuộc với ít nhất một framework back-end phổ biến như Express, Django, Java spring boot hoặc tương đương.',
          'Quen thuộc với Git và có kỹ năng làm việc nhóm và độc lập tốt.',
          'Ưu tiên ứng viên có kinh nghiệm làm việc trong lĩnh vực công nghệ, giải trí hoặc truyền thông.',
          'Nắm vững kiến thức về cấu trúc dữ liệu và thuật toán, có tư duy logic và khả năng giải quyết vấn đề tốt.',
          'Hiểu biết về cơ sở dữ liệu (Relational và Non-relational), mô hình dữ liệu và hiệu suất truy xuất.',
        ],
        benefits: [
          'Thưởng: Tiền thưởng ngày lễ và các ngày nghỉ theo luật định trong năm',
          'Chăm sóc sức khỏe: Bảo hiểm y tế cá nhân',
          'Căn-tin: Trợ cấp ăn uống',
        ],
        workAddress: 'SAV.5-03.03, The Sun Avenue, 28 Mai Chí Thọ, P.An Phú, Tp Thủ Đức - 28 Đường Mai Chí Thọ, An Phú, Thủ Đức, Hồ Chí Minh',
        companyName: 'CÔNG TY TNHH CÔNG NGHỆ GIẢI TRÍ & TRUYỀN THÔNG EVOLUX',
        companyLogoAsset: 'assets/evolux_logo.png', // Nhớ thêm logo vào assets
        locationCompany: 'Thủ Đức - Hồ Chí Minh',
        companySize: '20 - 99 người',
        companyIndustry: 'Truyền thông/Báo chí/Quảng cáo',
      );
}
