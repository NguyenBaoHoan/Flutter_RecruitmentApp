import 'package:flutter/material.dart';
import 'dart:collection';

// Giả sử bạn có một model cho tỉnh thành
// import '../../models/province_model.dart';

class ChooseAreaScreen extends StatefulWidget {
  const ChooseAreaScreen({super.key});

  @override
  State<ChooseAreaScreen> createState() => _ChooseAreaScreenState();
}

class _ChooseAreaScreenState extends State<ChooseAreaScreen> {
  // Danh sách các tỉnh thành được chọn
  final Set<String> _selectedProvinces = {};

  // Dữ liệu giả lập cho danh sách các tỉnh thành Việt Nam
  final List<String> _provinces = [
    'An Giang',
    'Bà Rịa - Vũng Tàu',
    'Bắc Giang',
    'Bắc Kạn',
    'Bạc Liêu',
    'Bắc Ninh',
    'Bến Tre',
    'Bình Định',
    'Bình Dương',
    'Bình Phước',
    'Bình Thuận',
    'Cà Mau',
    'Cần Thơ',
    'Cao Bằng',
    'Đà Nẵng',
    'Đắk Lắk',
    'Đắk Nông',
    'Điện Biên',
    'Đồng Nai',
    'Đồng Tháp',
    'Gia Lai',
    'Hà Giang',
    'Hà Nam',
    'Hà Nội',
    'Hà Tĩnh',
    'Hải Dương',
    'Hải Phòng',
    'Hậu Giang',
    'Hòa Bình',
    'Hưng Yên',
    'Khánh Hòa',
    'Kiên Giang',
    'Kon Tum',
    'Lai Châu',
    'Lâm Đồng',
    'Lạng Sơn',
    'Lào Cai',
    'Long An',
    'Nam Định',
    'Nghệ An',
    'Ninh Bình',
    'Ninh Thuận',
    'Phú Thọ',
    'Phú Yên',
    'Quảng Bình',
    'Quảng Nam',
    'Quảng Ngãi',
    'Quảng Ninh',
    'Quảng Trị',
    'Sóc Trăng',
    'Sơn La',
    'Tây Ninh',
    'Thái Bình',
    'Thái Nguyên',
    'Thanh Hóa',
    'Thừa Thiên Huế',
    'Tiền Giang',
    'TP Hồ Chí Minh',
    'Trà Vinh',
    'Tuyên Quang',
    'Vĩnh Long',
    'Vĩnh Phúc',
    'Yên Bái',
  ];

  // Nhóm các tỉnh theo chữ cái đầu
  late Map<String, List<String>> _groupedProvinces;

  @override
  void initState() {
    super.initState();
    _groupedProvinces = _groupProvinces(_provinces);
  }

  // Hàm để nhóm các tỉnh theo chữ cái đầu
  Map<String, List<String>> _groupProvinces(List<String> provinces) {
    final Map<String, List<String>> grouped = {};
    for (var province in provinces) {
      final firstLetter = province[0].toUpperCase();
      if (grouped[firstLetter] == null) {
        grouped[firstLetter] = [];
      }
      grouped[firstLetter]!.add(province);
    }
    // Sắp xếp map theo thứ tự alphabet
    return SplayTreeMap<String, List<String>>.from(
      grouped,
      (a, b) => a.compareTo(b),
    );
  }

  void _toggleSelection(String province) {
    setState(() {
      if (_selectedProvinces.contains(province)) {
        _selectedProvinces.remove(province);
      } else {
        _selectedProvinces.add(province);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Quay lại màn hình trước
          },
        ),
        title: const Text('Hãy chọn khu vực'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              itemCount:
                  _groupedProvinces.keys.length + 1, // +1 cho mục "Toàn quốc"
              itemBuilder: (context, index) {
                if (index == 0) {
                  return _buildNationWideChip();
                }
                String letter = _groupedProvinces.keys.elementAt(index - 1);
                List<String> provincesInGroup = _groupedProvinces[letter]!;
                return _buildGroup(letter, provincesInGroup);
              },
            ),
          ),
          _buildSaveButton(),
        ],
      ),
    );
  }

  // Widget cho mục "Toàn quốc"
  Widget _buildNationWideChip() {
    bool isSelected = _selectedProvinces.contains('Toàn quốc');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            'Toàn quốc',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
        ),
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: [
            ChoiceChip(
              label: Text(
                'Toàn quốc',
                style: TextStyle(
                  color: isSelected ? Colors.blue : Colors.black87,
                ),
              ),
              selected: isSelected,
              onSelected: (selected) {
                _toggleSelection('Toàn quốc');
              },
              backgroundColor: Colors.grey[200],
              selectedColor: Colors.blue.withOpacity(0.1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
                side: BorderSide(
                  color: isSelected ? Colors.blue : Colors.transparent,
                  width: 1,
                ),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 8.0,
              ),
            ),
          ],
        ),
        const Divider(height: 24),
      ],
    );
  }

  // Widget cho mỗi nhóm chữ cái
  Widget _buildGroup(String letter, List<String> provinces) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            letter,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
        ),
        Wrap(
          spacing: 8.0, // Khoảng cách ngang giữa các chip
          runSpacing: 8.0, // Khoảng cách dọc giữa các hàng chip
          children: provinces.map((province) {
            final isSelected = _selectedProvinces.contains(province);
            return ChoiceChip(
              label: Text(
                province,
                style: TextStyle(
                  color: isSelected ? Colors.blue : Colors.black87,
                ),
              ),
              selected: isSelected,
              onSelected: (selected) {
                _toggleSelection(province);
              },
              backgroundColor: Colors.grey[200],
              selectedColor: Colors.blue.withOpacity(0.1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
                side: BorderSide(
                  color: isSelected ? Colors.blue : Colors.transparent,
                  width: 1,
                ),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 8.0,
              ),
            );
          }).toList(),
        ),
        const Divider(height: 24),
      ],
    );
  }

  // Widget cho nút "Lưu"
  Widget _buildSaveButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        16,
        16,
        16,
        32,
      ), // Padding an toàn cho bottom bar
      child: ElevatedButton(
        onPressed: () {
          // Xử lý logic khi nhấn nút Lưu
          print('Các tỉnh đã chọn: $_selectedProvinces');
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Đã lưu các lựa chọn!')));
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2196F3),
          foregroundColor: Colors.white, // Đổi màu chữ thành trắng
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        child: const Text('Lưu'),
      ),
    );
  }
}
