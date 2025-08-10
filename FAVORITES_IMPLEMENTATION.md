# Favorites Implementation Guide

## Tổng quan

Đã implement đầy đủ chức năng favorites cho ứng dụng Flutter dựa trên các endpoint backend đã cung cấp.

## Các file đã tạo/cập nhật

### 1. Models

- `lib/models/favorite_job_model.dart` - Model cho FavoriteJob
- `lib/models/job_model.dart` - Thêm method `toJson()` cho Job model

### 2. Services

- `lib/services/favorite_job_service.dart` - Service để gọi API favorites

### 3. Widgets

- `lib/widgets/favorite_job_card.dart` - Widget hiển thị job card trong favorites
- `lib/widgets/favorite_button.dart` - Widget button để thêm/xóa favorites

### 4. Screens

- `lib/screens/profile/favorites_page.dart` - Cập nhật để sử dụng API thực tế

## Các chức năng đã implement

### 1. Lấy danh sách job yêu thích

```dart
// GET /api/favorite-jobs?userId=1
Future<List<FavoriteJob>> getFavoriteJobs(int userId)
```

### 2. Thêm job vào favorites

```dart
// POST /api/favorite-jobs/add?userId=1&jobId=1
Future<String> addToFavorites(int userId, int jobId)
```

### 3. Xóa job khỏi favorites

```dart
// DELETE /api/favorite-jobs/remove?userId=1&jobId=1
Future<String> removeFromFavorites(int userId, int jobId)
```

### 4. Kiểm tra job có được yêu thích không

```dart
// GET /api/favorite-jobs/check?userId=1&jobId=1
Future<bool> checkIfFavorited(int userId, int jobId)
```

### 5. Đếm số job yêu thích

```dart
// GET /api/favorite-jobs/count?userId=1
Future<int> countFavoriteJobs(int userId)
```

## Cách sử dụng

### 1. Trong Job Card (để thêm/xóa favorites)

```dart
import '../widgets/favorite_button.dart';

// Trong widget build
FavoriteButton(
  jobId: job.id!,
  userId: currentUserId, // Thay thế bằng userId thực tế
  onFavoriteChanged: () {
    // Callback khi thay đổi trạng thái favorite
  },
)
```

### 2. Trong Favorites Page

```dart
import '../services/favorite_job_service.dart';

final favoriteJobService = FavoriteJobService();
final favoriteJobs = await favoriteJobService.getFavoriteJobs(userId);
```

### 3. Kiểm tra trạng thái favorite

```dart
final isFavorited = await favoriteJobService.checkIfFavorited(userId, jobId);
```

## Lưu ý quan trọng

### 1. User ID

Hiện tại đang hardcode `userId = 1` trong `favorites_page.dart`. Cần thay thế bằng userId thực tế từ authentication system:

```dart
// TODO: Thay thế bằng userId thực tế từ authentication
final int _userId = 1;
```

### 2. Error Handling

Tất cả các API call đều có error handling và hiển thị thông báo lỗi cho user.

### 3. Loading States

Các widget đều có loading states để UX tốt hơn.

### 4. Refresh Functionality

Favorites page có pull-to-refresh để reload danh sách.

## Cấu trúc Response từ Backend

### FavoriteJob Response

```json
{
  "id": 1,
  "job": {
    "id": 1,
    "name": "Back-End Developer",
    "salary": "20-35 Triệu",
    "location": "Thủ Đức - Hồ Chí Minh"
    // ... other job fields
  },
  "createdAt": "2024-01-01T00:00:00Z",
  "updatedAt": "2024-01-01T00:00:00Z",
  "createdBy": "user@example.com",
  "updatedBy": "user@example.com"
}
```

## Testing

### 1. Test API endpoints với Postman

- ✅ GET /api/favorite-jobs?userId=1
- ✅ POST /api/favorite-jobs/add?userId=1&jobId=1
- ✅ DELETE /api/favorite-jobs/remove?userId=1&jobId=1
- ✅ GET /api/favorite-jobs/check?userId=1&jobId=1
- ✅ GET /api/favorite-jobs/count?userId=1

### 2. Test Flutter App

- ✅ Load favorites page
- ✅ Hiển thị danh sách favorites
- ✅ Thêm job vào favorites
- ✅ Xóa job khỏi favorites
- ✅ Refresh danh sách
- ✅ Error handling

## Next Steps

1. **Authentication Integration**: Thay thế hardcoded userId bằng userId thực tế
2. **Favorite Companies**: Implement tab "Công ty" cho favorite companies
3. **Offline Support**: Thêm cache cho favorites khi offline
4. **Push Notifications**: Thông báo khi có job mới phù hợp với favorites
5. **Analytics**: Track user behavior với favorites
