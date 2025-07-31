import 'package:flutter/material.dart';
import '../../models/job_model.dart';
import '../../data/job_database.dart';
import '../../widgets/job_card.dart';
import 'recruiter_no_data_widget.dart';
import 'recruiter_post_job_screen.dart';


class RecruiterManageJobsScreen extends StatefulWidget {
  const RecruiterManageJobsScreen({super.key});

  @override
  State<RecruiterManageJobsScreen> createState() => _RecruiterManageJobsScreenState();
}

class _RecruiterManageJobsScreenState extends State<RecruiterManageJobsScreen> {
  final List<Job> jobs = [];
  String searchQuery = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadJobs();
  }

  Future<void> _loadJobs() async {
    final list = await JobDatabase.instance.readAllJobs();
    setState(() {
      jobs.clear();
      jobs.addAll(list);
      isLoading = false;
    });
  }

  List<Job> getJobsByStatus(String status) =>
      jobs.where((job) => job.status == status).toList();

  List<Job> filterJobs(List<Job> jobList) {
    if (searchQuery.isEmpty) return jobList;
    final q = searchQuery.toLowerCase();
    return jobList.where((job) =>
        job.title.toLowerCase().contains(q) ||
        job.company.toLowerCase().contains(q) ||
        job.salary.toLowerCase().contains(q) ||
        job.location.toLowerCase().contains(q) ||
        job.description.toLowerCase().contains(q)
    ).toList();
  }

  void _updateJobStatus(int index, String newStatus) async {
    final job = jobs[index];
    final updatedJob = job.copyWith(status: newStatus);
    await JobDatabase.instance.updateJob(updatedJob, updatedJob.id!); // cần id
    setState(() {
      jobs[index] = updatedJob;
    });
  }

  void _editJob(int index) async {
    final oldJob = jobs[index];
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecruiterPostJobScreen(
          initialJob: oldJob,
          onJobPosted: (editedJob) async {
            final newJob = editedJob.copyWith(id: oldJob.id);
            await JobDatabase.instance.updateJob(newJob, oldJob.id!);
            setState(() {
              jobs[index] = newJob;
            });
          },
        ),
      ),
    );
  }

  Widget _buildStatsDescription(List<Job> currentList) {
    final listChucDanh = currentList.map((j) => j.title).toSet().toList();
    String chucdanh = listChucDanh.join(', ');
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
      child: Text(
        "Hiện tại đang có ${currentList.length} vị trí"
            "${listChucDanh.isNotEmpty ? " (${chucdanh})" : ""}. "
            "Vị trí sẽ duyệt theo chức danh/vị trí công việc mà bạn đã đăng.",
        style: const TextStyle(
          color: Colors.blue,
          fontWeight: FontWeight.w600,
          fontSize: 15,
        ),
      ),
    );
  }

  Widget _buildSearchBar(void Function(String) onChanged) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Tìm kiếm theo tên, chức danh, lương, mô tả...',
          prefixIcon: const Icon(Icons.search),
          fillColor: Colors.white,
          filled: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(color: Color(0xFFD8D8D8), width: 1),
          ),
        ),
        onChanged: onChanged,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Quản lý vị trí'),
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(48),
            child: Align(
              alignment: Alignment.centerLeft,
              child: TabBar(
                isScrollable: true,
                labelColor: Colors.blue,
                unselectedLabelColor: Colors.black,
                indicatorColor: Colors.blue,
                labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
                tabs: const [
                  Tab(text: "Tất cả"),
                  Tab(text: "Đang mở"),
                  Tab(text: "Đang chờ duyệt"),
                  Tab(text: "Không được duyệt"),
                  Tab(text: "Đã đóng"),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            // TAB TẤT CẢ
            Column(
              children: [
                _buildStatsDescription(filterJobs(jobs)),
                _buildSearchBar((q) => setState(() => searchQuery = q)),
                Expanded(
                  child: filterJobs(jobs).isEmpty
                      ? const RecruiterNoDataWidget(text: "Chưa có vị trí nào!")
                      : ListView.builder(
                          itemCount: filterJobs(jobs).length,
                          itemBuilder: (context, index) {
                            final filteredJob = filterJobs(jobs)[index];
                            final realIndex = jobs.indexOf(filteredJob);
                            return JobCard(
                              job: filteredJob,
                              onEdit: () => _editJob(realIndex),
                              onChangeStatus: (status) => _updateJobStatus(realIndex, status),
                            );
                          },
                        ),
                ),
              ],
            ),
            // TAB ĐANG MỞ
            Column(
              children: [
                _buildStatsDescription(filterJobs(getJobsByStatus("open"))),
                _buildSearchBar((q) => setState(() => searchQuery = q)),
                Expanded(
                  child: filterJobs(getJobsByStatus("open")).isEmpty
                      ? const RecruiterNoDataWidget(text: "Không có vị trí đang mở")
                      : ListView.builder(
                          itemCount: filterJobs(getJobsByStatus("open")).length,
                          itemBuilder: (context, idx) {
                            final filteredJob = filterJobs(getJobsByStatus("open"))[idx];
                            final realIndex = jobs.indexOf(filteredJob);
                            return JobCard(
                              job: filteredJob,
                              onEdit: () => _editJob(realIndex),
                              onChangeStatus: (status) => _updateJobStatus(realIndex, status),
                            );
                          },
                        ),
                ),
              ],
            ),
            // TAB ĐANG CHỜ DUYỆT
            Column(
              children: [
                _buildStatsDescription(filterJobs(getJobsByStatus("pending"))),
                _buildSearchBar((q) => setState(() => searchQuery = q)),
                Expanded(
                  child: filterJobs(getJobsByStatus("pending")).isEmpty
                      ? const RecruiterNoDataWidget(text: "Chưa có vị trí chờ duyệt")
                      : ListView.builder(
                          itemCount: filterJobs(getJobsByStatus("pending")).length,
                          itemBuilder: (context, idx) {
                            final filteredJob = filterJobs(getJobsByStatus("pending"))[idx];
                            final realIndex = jobs.indexOf(filteredJob);
                            return JobCard(
                              job: filteredJob,
                              onEdit: () => _editJob(realIndex),
                              onChangeStatus: (status) => _updateJobStatus(realIndex, status),
                            );
                          },
                        ),
                ),
              ],
            ),
            // KHÔNG ĐƯỢC DUYỆT
            Column(
              children: [
                _buildStatsDescription(filterJobs(getJobsByStatus("rejected"))),
                _buildSearchBar((q) => setState(() => searchQuery = q)),
                Expanded(
                  child: filterJobs(getJobsByStatus("rejected")).isEmpty
                      ? const RecruiterNoDataWidget(text: "Không có vị trí bị từ chối")
                      : ListView.builder(
                          itemCount: filterJobs(getJobsByStatus("rejected")).length,
                          itemBuilder: (context, idx) {
                            final filteredJob = filterJobs(getJobsByStatus("rejected"))[idx];
                            final realIndex = jobs.indexOf(filteredJob);
                            return JobCard(
                              job: filteredJob,
                              onEdit: () => _editJob(realIndex),
                              onChangeStatus: (status) => _updateJobStatus(realIndex, status),
                            );
                          },
                        ),
                ),
              ],
            ),
            // ĐÃ ĐÓNG
            Column(
              children: [
                _buildStatsDescription(filterJobs(getJobsByStatus("closed"))),
                _buildSearchBar((q) => setState(() => searchQuery = q)),
                Expanded(
                  child: filterJobs(getJobsByStatus("closed")).isEmpty
                      ? const RecruiterNoDataWidget(text: "Không có vị trí đã đóng")
                      : ListView.builder(
                          itemCount: filterJobs(getJobsByStatus("closed")).length,
                          itemBuilder: (context, idx) {
                            final filteredJob = filterJobs(getJobsByStatus("closed"))[idx];
                            final realIndex = jobs.indexOf(filteredJob);
                            return JobCard(
                              job: filteredJob,
                              onEdit: () => _editJob(realIndex),
                              onChangeStatus: (status) => _updateJobStatus(realIndex, status),
                            );
                          },
                        ),
                ),
              ],
            ),
          ],
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RecruiterPostJobScreen(
                      onJobPosted: (job) async {
                        int id = await JobDatabase.instance.createJob(job);
                        Job jobWithId = job.copyWith(id: id);
                        setState(() {
                          jobs.add(jobWithId);
                        });
                      },
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Đăng một công việc mới",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
