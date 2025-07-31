
// lib/widgets/job_detail/company_info_card.dart
import 'package:flutter/material.dart'; // Import thư viện Flutter Material để sử dụng các widget cơ bản.
import '../../models/job_model.dart'; // Import model Job để lấy thông tin công ty từ đối tượng job.

// Định nghĩa một StatelessWidget tên là CompanyInfoCard để hiển thị thông tin công ty.
class CompanyInfoCard extends StatelessWidget {
  final Job job; // Thuộc tính job, chứa thông tin chi tiết về công ty và công việc.

  // Constructor nhận vào một đối tượng job, super.key để hỗ trợ key cho widget.
  const CompanyInfoCard({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    // Hàm build trả về widget giao diện của CompanyInfoCard.
    return Container(
      // Container dùng để bọc toàn bộ nội dung, có padding và decoration.
      padding: const EdgeInsets.all(16), // Padding 16px cho tất cả các cạnh.
      decoration: BoxDecoration(
        color: Colors.white, // Màu nền trắng cho card.
        borderRadius: BorderRadius.circular(12), // Bo góc 12px.
        border: Border.all(color: Colors.grey.shade200), // Viền màu xám nhạt.
      ),
      child: Row(
        // Sử dụng Row để xếp logo và thông tin công ty theo chiều ngang.
        children: [
          // Hiển thị logo công ty từ assets.
          Image.asset(
            job.companyLogoAsset, // Đường dẫn asset logo lấy từ job.
            width: 50, // Chiều rộng logo 50px.
            height: 50, // Chiều cao logo 50px.
            errorBuilder: (context, error, stackTrace) {
              // Nếu không load được ảnh, hiển thị icon mặc định.
              return const Icon(Icons.business, size: 50, color: Colors.grey); // Icon fallback.
            },
          ),
          const SizedBox(width: 16), // Khoảng cách ngang 16px giữa logo và thông tin.
          Expanded(
            // Expanded để phần thông tin chiếm hết không gian còn lại.
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Căn lề trái cho các dòng thông tin.
              children: [
                // Hiển thị tên công ty, in đậm, cỡ chữ 16.
                Text(
                  job.companyName,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 4), // Khoảng cách dọc 4px.
                // Hiển thị vị trí công ty và quy mô công ty, dùng bodyMedium style.
                Text(
                  '${job.locationCompany} | ${job.companySize}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 4), // Khoảng cách dọc 4px.
                // Hiển thị ngành nghề công ty, dùng bodyMedium style.
                Text(
                  job.companyIndustry,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}