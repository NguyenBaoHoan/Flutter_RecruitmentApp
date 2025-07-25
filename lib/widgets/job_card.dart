import 'package:flutter/material.dart';
import '../models/job_model.dart';

class JobCard extends StatelessWidget {
  final Job job;
  final VoidCallback? onEdit;
  final Function(String)? onChangeStatus;

  const JobCard({
    Key? key,
    required this.job,
    this.onEdit,
    this.onChangeStatus,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: const Icon(
                      Icons.business_center,
                      color: Colors.blue,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          job.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          job.company,
                          style: TextStyle(color: Colors.grey[600], fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  _buildPopupMenu(context),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _buildInfoChip(job.salary, Colors.grey[200]!),
                  const SizedBox(width: 8),
                  _buildInfoChip(job.location, Colors.grey[200]!),
                  const SizedBox(width: 8),
                  _buildInfoChip(job.postDate, Colors.grey[200]!),
                ],
              ),
              if (job.description.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  job.description,
                  style: const TextStyle(color: Colors.black87, fontSize: 13),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const SizedBox(height: 12),
              _buildStatusLabel(job.status),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(color: Colors.grey[700], fontSize: 12),
      ),
    );
  }

  Widget _buildPopupMenu(BuildContext context) {
    // Đẹp, có icon màu, bo tròn, bóng đổ nhẹ
    return PopupMenuButton<String>(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 10,
      onSelected: (value) {
        switch (value) {
          case 'edit':
            onEdit?.call();
            break;
          case 'open':
            onChangeStatus?.call('open');
            break;
          case 'pending':
            onChangeStatus?.call('pending');
            break;
          case 'rejected':
            onChangeStatus?.call('rejected');
            break;
          case 'closed':
            onChangeStatus?.call('closed');
            break;
        }
      },
      icon: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Colors.blue, Colors.teal]),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.2),
              blurRadius: 8,
              spreadRadius: 1,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Icon(Icons.more_vert, color: Colors.white, size: 24),
        padding: const EdgeInsets.all(4),
      ),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'edit',
          child: Row(
            children: const [
              Icon(Icons.edit, color: Colors.indigo, size: 20),
              SizedBox(width: 10),
              Text('Chỉnh sửa thông tin', style: TextStyle(fontWeight: FontWeight.w500)),
            ],
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem(
          value: 'open',
          child: Row(
            children: const [
              Icon(Icons.lock_open, color: Colors.green, size: 20),
              SizedBox(width: 10),
              Text('Chuyển sang Đang mở'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'pending',
          child: Row(
            children: const [
              Icon(Icons.hourglass_top, color: Colors.orange, size: 20),
              SizedBox(width: 10),
              Text('Chuyển sang Đang chờ duyệt'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'rejected',
          child: Row(
            children: const [
              Icon(Icons.cancel_rounded, color: Colors.red, size: 20),
              SizedBox(width: 10),
              Text('Chuyển sang Không được duyệt'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'closed',
          child: Row(
            children: const [
              Icon(Icons.lock, color: Colors.grey, size: 20),
              SizedBox(width: 10),
              Text('Chuyển sang Đã đóng'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatusLabel(String status) {
    String text = "";
    Color color;
    switch (status) {
      case 'open':
        text = 'Đang mở';
        color = Colors.green;
        break;
      case 'pending':
        text = 'Đang chờ duyệt';
        color = Colors.orange;
        break;
      case 'rejected':
        text = 'Không được duyệt';
        color = Colors.redAccent;
        break;
      case 'closed':
        text = 'Đã đóng';
        color = Colors.grey;
        break;
      default:
        text = '';
        color = Colors.transparent;
    }
    return text.isNotEmpty
        ? Container(
      margin: const EdgeInsets.only(top: 2),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold),
      ),
    )
        : const SizedBox.shrink();
  }
}
