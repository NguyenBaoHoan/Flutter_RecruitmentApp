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
        // <<< SỬA ĐỔI >>> AppBar sẽ tự động đổi màu
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
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
    final theme = Theme.of(context); // <<< THÊM MỚI >>>
    bool isSelected = _selectedProvinces.contains('Toàn quốc');
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            'Toàn quốc',
            // <<< SỬA ĐỔI >>> Xóa màu cố định
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: [
            ChoiceChip(
              label: const Text('Toàn quốc'),
              selected: isSelected,
              onSelected: (selected) {
                _toggleSelection('Toàn quốc');
              },
              // <<< SỬA ĐỔI >>> ChoiceChip sẽ tự động đổi màu theo theme
              backgroundColor: theme.colorScheme.surfaceVariant,
              selectedColor: theme.colorScheme.primaryContainer,
              labelStyle: TextStyle(
                color: isSelected ? theme.colorScheme.onPrimaryContainer : theme.colorScheme.onSurfaceVariant,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
                side: BorderSide(
                  color: isSelected ? theme.colorScheme.primary : Colors.transparent,
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
    final theme = Theme.of(context); // <<< THÊM MỚI >>>
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            letter,
            // <<< SỬA ĐỔI >>> Xóa màu cố định
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: provinces.map((province) {
            final isSelected = _selectedProvinces.contains(province);
            return ChoiceChip(
              label: Text(province),
              selected: isSelected,
              onSelected: (selected) {
                _toggleSelection(province);
              },
              // <<< SỬA ĐỔI >>> ChoiceChip sẽ tự động đổi màu theo theme
              backgroundColor: theme.colorScheme.surfaceVariant,
              selectedColor: theme.colorScheme.primaryContainer,
              labelStyle: TextStyle(
                color: isSelected ? theme.colorScheme.onPrimaryContainer : theme.colorScheme.onSurfaceVariant,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
                side: BorderSide(
                  color: isSelected ? theme.colorScheme.primary : Colors.transparent,
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
    final theme = Theme.of(context); // <<< THÊM MỚI >>>

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      child: ElevatedButton(
        onPressed: () {
          print('Các tỉnh đã chọn: $_selectedProvinces');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Đã lưu các lựa chọn!')),
          );
        },
        // <<< SỬA ĐỔI >>> Dùng màu từ theme
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.colorScheme.onPrimary,
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