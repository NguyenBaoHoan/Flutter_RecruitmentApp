# Debug Logs Guide

## 🔍 Các Log đã thêm

### 1. User Preferences Service

```
💾 [USER PREFERENCES] Saving user: {...}
💾 [USER PREFERENCES] User ID: 2 (type: int)
💾 [USER PREFERENCES] User saved successfully

🔍 [USER PREFERENCES] Getting userId: 2 (type: int?)
🔍 [USER PREFERENCES] All keys: {user_data, user_id}
🔍 [USER PREFERENCES] Key: user_data, Value: {...} (type: String)
🔍 [USER PREFERENCES] Key: user_id, Value: 2 (type: int)
```

### 2. Favorites Page

```
🔍 [FAVORITES PAGE] Loading userId and jobs...
🔍 [FAVORITES PAGE] Retrieved userId: 2 (type: int?)
🔍 [FAVORITES PAGE] User is logged in, loading favorite jobs...
🔍 [FAVORITES PAGE] Loading favorite jobs for userId: 2
🔍 [FAVORITES PAGE] Successfully loaded 3 favorite jobs
```

### 3. Job Detail Screen

```
🔍 [JOB DETAIL] Loading userId...
🔍 [JOB DETAIL] Retrieved userId: 2 (type: int?)
```

### 4. Favorite Button

```
🔍 [FAVORITE BUTTON] Checking favorite status for jobId: 3, userId: 2
🔍 [FAVORITE BUTTON] Favorite status: true

🔄 [FAVORITE BUTTON] Toggling favorite for jobId: 3, userId: 2
🔄 [FAVORITE BUTTON] Current state: favorited
🗑️ [FAVORITE BUTTON] Removing from favorites...
✅ [FAVORITE BUTTON] Successfully toggled favorite state to: not favorited
```

### 5. Favorite Job Service

```
🔍 [FAVORITE SERVICE] Getting favorite jobs for userId: 2
🔍 [FAVORITE SERVICE] API URL: http://10.0.2.2:8080/api/favorite-jobs?userId=2
🔍 [FAVORITE SERVICE] Response status: 200
🔍 [FAVORITE SERVICE] Response body: [...]
🔍 [FAVORITE SERVICE] Parsed JSON data: [...]
🔍 [FAVORITE SERVICE] Processing job: {...}
🔍 [FAVORITE SERVICE] Successfully parsed 3 favorite jobs

➕ [FAVORITE SERVICE] Adding job to favorites
➕ [FAVORITE SERVICE] userId: 2 (type: int)
➕ [FAVORITE SERVICE] jobId: 3 (type: int)
➕ [FAVORITE SERVICE] API URL: http://10.0.2.2:8080/api/favorite-jobs/add?userId=2&jobId=3
➕ [FAVORITE SERVICE] Response status: 200
➕ [FAVORITE SERVICE] Response body: Thêm job vào danh sách yêu thích thành công
```

## 🐛 Cách Debug

### 1. Chạy ứng dụng và xem logs

```bash
flutter run
```

### 2. Filter logs theo tag

```bash
# Chỉ xem logs của User Preferences
flutter logs | grep "USER PREFERENCES"

# Chỉ xem logs của Favorites
flutter logs | grep "FAVORITES"

# Chỉ xem logs của Favorite Button
flutter logs | grep "FAVORITE BUTTON"

# Chỉ xem logs của Favorite Service
flutter logs | grep "FAVORITE SERVICE"
```

### 3. Debug SharedPreferences

```dart
// Thêm vào bất kỳ đâu để debug
final prefs = await SharedPreferences.getInstance();
final keys = prefs.getKeys();
print('All SharedPreferences keys: $keys');
for (final key in keys) {
  final value = prefs.get(key);
  print('Key: $key, Value: $value, Type: ${value.runtimeType}');
}
```

## 🔧 Các lỗi thường gặp

### 1. Type Cast Error

```
Lỗi: type 'String' is not a subtype of type 'int?' in type cast
```

**Nguyên nhân**: userId được lưu dưới dạng String thay vì int
**Giải pháp**: Kiểm tra cách lưu userId trong SharedPreferences

### 2. Null User ID

```
🔍 [FAVORITES PAGE] Retrieved userId: null (type: Null)
```

**Nguyên nhân**: User chưa đăng nhập hoặc userId bị mất
**Giải pháp**: Kiểm tra quá trình đăng nhập và lưu user

### 3. API Error

```
❌ [FAVORITE SERVICE] Error getting favorite jobs: Exception: Failed to get favorite jobs: 400
```

**Nguyên nhân**: Server lỗi hoặc userId không hợp lệ
**Giải pháp**: Kiểm tra server và userId

## 📋 Checklist Debug

### 1. Kiểm tra đăng nhập

- [ ] User đăng nhập thành công
- [ ] User data được lưu vào SharedPreferences
- [ ] userId có kiểu dữ liệu đúng (int)

### 2. Kiểm tra API calls

- [ ] URL API đúng
- [ ] userId và jobId được truyền đúng
- [ ] Response từ server hợp lệ

### 3. Kiểm tra UI updates

- [ ] Loading states hiển thị đúng
- [ ] Error messages hiển thị đúng
- [ ] Success feedback hoạt động

## 🚀 Tips Debug

### 1. Clear SharedPreferences

```dart
// Xóa tất cả data để test từ đầu
final prefs = await SharedPreferences.getInstance();
await prefs.clear();
```

### 2. Test với userId cố định

```dart
// Tạm thời hardcode userId để test
final userId = 2; // Thay vì lấy từ SharedPreferences
```

### 3. Mock API Response

```dart
// Tạo mock data để test UI
final mockFavoriteJobs = [
  FavoriteJob.fromJson({
    'id': 1,
    'job': Job.sampleJob.toJson(),
    'createdAt': DateTime.now().toIso8601String(),
    'updatedAt': DateTime.now().toIso8601String(),
    'createdBy': 'test@example.com',
    'updatedBy': 'test@example.com',
  })
];
```
