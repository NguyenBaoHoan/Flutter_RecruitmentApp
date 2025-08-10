import 'package:flutter/material.dart';
import '../../models/job_model.dart';
import '../../services/job_api_service.dart';
import '../../services/search_history_service.dart';
import '../../widgets/job_detail/job_card.dart';
import '../job_detail/job_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final JobApiService _jobApiService = JobApiService();
  final SearchHistoryService _searchHistoryService = SearchHistoryService();

  List<String> _searchHistory = [];
  List<Job> _searchResults = [];
  bool _isLoading = false;
  bool _hasSearched = false;

  @override
  void initState() {
    super.initState();
    _loadSearchHistory();
  }

  Future<void> _loadSearchHistory() async {
    final history = await _searchHistoryService.getSearchHistory();
    setState(() {
      _searchHistory = history;
    });
  }

  Future<void> _performSearch(String query) async {
    if (query.trim().isEmpty) return;

    setState(() {
      _isLoading = true;
      _hasSearched = true;
    });

    try {
      // Lưu vào lịch sử
      await _searchHistoryService.saveSearchHistory(query);
      await _loadSearchHistory();

      // Thực hiện tìm kiếm
      final result = await _jobApiService.searchJobs(query: query);

      if (result['data'] != null && result['data']['result'] != null) {
        final List<dynamic> jobsData = result['data']['result'];
        final List<Job> jobs = jobsData
            .map((json) => Job.fromJson(json))
            .toList();

        setState(() {
          _searchResults = jobs;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Lỗi tìm kiếm: $e')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _removeFromHistory(String query) async {
    await _searchHistoryService.removeSearchHistory(query);
    await _loadSearchHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // <<< SỬA ĐỔI >>> AppBar sẽ tự động đổi màu theo theme
      appBar: AppBar(
        title: const Text('Tìm kiếm việc làm'),
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(
            child: _hasSearched ? _buildSearchResults() : _buildSearchHistory(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    // <<< THÊM MỚI >>> Lấy theme hiện tại
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        // <<< SỬA ĐỔI >>> Dùng màu từ theme
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.dividerColor),
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Tìm kiếm việc làm...',
          border: InputBorder.none,
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _hasSearched = false;
                      _searchResults.clear();
                    });
                  },
                )
              : null,
        ),
        onSubmitted: _performSearch,
        onChanged: (value) {
          setState(() {});
        },
      ),
    );
  }

  Widget _buildSearchHistory() {
    if (_searchHistory.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // <<< SỬA ĐỔI >>> Icon và Text sẽ tự động đổi màu
            Icon(Icons.history, size: 64),
            SizedBox(height: 16),
            Text('Chưa có lịch sử tìm kiếm'),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Lịch sử tìm kiếm',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () async {
                  await _searchHistoryService.clearSearchHistory();
                  await _loadSearchHistory();
                },
                child: const Text('Xóa tất cả'),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _searchHistory.length,
            itemBuilder: (context, index) {
              final query = _searchHistory[index];
              return ListTile(
                leading: const Icon(Icons.history),
                title: Text(query),
                trailing: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => _removeFromHistory(query),
                ),
                onTap: () {
                  _searchController.text = query;
                  _performSearch(query);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSearchResults() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_searchResults.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // <<< SỬA ĐỔI >>> Icon và Text sẽ tự động đổi màu
            Icon(Icons.search_off, size: 64),
            SizedBox(height: 16),
            Text('Không tìm thấy kết quả'),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final job = _searchResults[index];
        // Giả sử JobCard đã được tối ưu hóa hoặc không dùng màu cố định
        return JobCard(job: job.toMap());
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}