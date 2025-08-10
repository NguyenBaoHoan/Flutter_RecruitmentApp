# Hướng dẫn Test Chức năng Favorites

## 🎯 Tổng quan

Hướng dẫn test chức năng favorites đã được implement với SharedPreferences và API thực tế.

## 📱 Các chức năng đã cập nhật

### 1. Job Detail Screen

- ✅ **Favorite Button**: Nút yêu thích trong AppBar của job detail
- ✅ **User ID từ SharedPreferences**: Tự động lấy userId từ SharedPreferences
- ✅ **API Integration**: Gọi API thực tế để thêm/xóa favorites

### 2. Favorites Page

- ✅ **User Authentication**: Kiểm tra đăng nhập trước khi load favorites
- ✅ **Error Handling**: Hiển thị thông báo khi chưa đăng nhập
- ✅ **Real-time Updates**: Cập nhật UI ngay khi thay đổi favorites

## 🧪 Cách Test

### Bước 1: Đăng nhập

1. Mở ứng dụng
2. Đăng nhập với tài khoản hợp lệ
3. Kiểm tra userId được lưu trong SharedPreferences

### Bước 2: Test Job Detail Screen

1. Mở một job detail bất kỳ
2. Kiểm tra nút favorite (❤️) trong AppBar
3. Click vào nút favorite để thêm/xóa khỏi favorites
4. Kiểm tra thông báo thành công/lỗi

### Bước 3: Test Favorites Page

1. Vào màn hình "Thú vị" (Favorites)
2. Kiểm tra tab "Vị trí" hiển thị danh sách job yêu thích
3. Test pull-to-refresh để reload danh sách
4. Click vào nút favorite trên job card để xóa khỏi favorites

### Bước 4: Test Error Cases

1. **Chưa đăng nhập**:
   - Logout khỏi ứng dụng
   - Vào favorites page
   - Kiểm tra thông báo "Vui lòng đăng nhập"
2. **API Error**:
   - Tắt server backend
   - Test các chức năng favorites
   - Kiểm tra error handling

## 🔧 Cấu hình Test

### 1. Backend Server

```bash
# Đảm bảo server đang chạy
http://localhost:8080/api/favorite-jobs
```

### 2. Test Data

```json
// Test user
{
  "id": 2,
  "email": "test@example.com",
  "name": "Test User"
}

// Test job
{
  "id": 3,
  "name": "Back-End Developer",
  "salary": "20-35 Triệu"
}
```

### 3. API Endpoints Test

```bash
# Lấy danh sách favorites
GET /api/favorite-jobs?userId=2

# Thêm vào favorites
POST /api/favorite-jobs/add?userId=2&jobId=3

# Xóa khỏi favorites
DELETE /api/favorite-jobs/remove?userId=2&jobId=3

# Kiểm tra trạng thái
GET /api/favorite-jobs/check?userId=2&jobId=3

# Đếm số favorites
GET /api/favorite-jobs/count?userId=2
```

## 📋 Checklist Test

### Job Detail Screen

- [ ] Nút favorite hiển thị đúng trạng thái (filled/outline)
- [ ] Click favorite thêm job vào favorites thành công
- [ ] Click favorite xóa job khỏi favorites thành công
- [ ] Hiển thị thông báo thành công/lỗi
- [ ] Loading state khi đang gọi API

### Favorites Page

- [ ] Load danh sách favorites khi đã đăng nhập
- [ ] Hiển thị thông báo khi chưa đăng nhập
- [ ] Pull-to-refresh hoạt động
- [ ] Xóa job khỏi favorites từ job card
- [ ] Error handling khi API lỗi
- [ ] Loading state khi đang tải dữ liệu

### SharedPreferences

- [ ] Lưu user data khi đăng nhập
- [ ] Lấy userId từ SharedPreferences
- [ ] Xóa user data khi logout
- [ ] Kiểm tra trạng thái đăng nhập

## 🐛 Debug Tips

### 1. Kiểm tra SharedPreferences

```dart
// Debug: In ra userId
final userId = await UserPreferencesService.getUserId();
print('Current userId: $userId');
```

### 2. Kiểm tra API Response

```dart
// Debug: In ra response từ API
print('API Response: ${response.body}');
```

### 3. Kiểm tra Error

```dart
// Debug: In ra error
print('Error: ${e.toString()}');
```

## 📱 UI/UX Features

### 1. Loading States

- CircularProgressIndicator khi đang tải
- Disabled button khi đang gọi API

### 2. Error Handling

- Snackbar thông báo lỗi
- Error screen với nút retry
- Thông báo khi chưa đăng nhập

### 3. Success Feedback

- Snackbar thông báo thành công
- Icon thay đổi trạng thái ngay lập tức

### 4. Responsive Design

- Pull-to-refresh
- Error states
- Empty states
- Loading states

## 🚀 Performance

### 1. API Calls

- Chỉ gọi API khi cần thiết
- Cache userId từ SharedPreferences
- Optimistic UI updates

### 2. Memory Management

- Dispose controllers đúng cách
- Check mounted state trước khi setState

### 3. Error Recovery

- Retry mechanism
- Fallback states
- Graceful degradation
