// lib/data/models/task_model.dart
class TaskModel {
  final String id;
  final String title;
  final String description;
  final String date;
  final String time;
  bool isDone;

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    this.isDone = false,
  });

  // Auto-calculate status based on isDone and current time
  String get status {
    if (isDone) {
      return 'Selesai';
    }
    
    // Parse task date and time
    try {
      final taskDateTime = _parseDateTime(date, time);
      final now = DateTime.now();
      
      if (now.isAfter(taskDateTime)) {
        return 'Terlambat';
      } else {
        return 'Belum Selesai';
      }
    } catch (e) {
      // If parsing fails, default to 'Belum Selesai'
      return 'Belum Selesai';
    }
  }

    DateTime get parsedDateTime {
    try {
      return _parseDateTime(date, time);
    } catch (e) {
      print("Error parsing date/time in TaskModel for task ID $id: $date $time - $e");
      return DateTime(1970); // Tanggal default jika error
    }
  }

  DateTime _parseDateTime(String dateStr, String timeStr) {
    // Parse date in format "dd MMM yyyy" or "d MMM yyyy"
    final dateParts = dateStr.split(' ');
    if (dateParts.length != 3) throw FormatException('Invalid date format');
    
    final day = int.parse(dateParts[0]);
    final monthName = dateParts[1];
    final year = int.parse(dateParts[2]);
    
    // Map month names to numbers
    final monthMap = {
      'January': 1, 'Januari': 1,
      'February': 2, 'Februari': 2,
      'March': 3, 'Maret': 3,
      'April': 4,
      'May': 5, 'Mei': 5,
      'June': 6, 'Juni': 6,
      'July': 7, 'Juli': 7,
      'August': 8, 'Agustus': 8,
      'September': 9,
      'October': 10, 'Oktober': 10,
      'November': 11,
      'December': 12, 'Desember': 12,
    };
    
    final month = monthMap[monthName] ?? 1;
    
    // Parse time in format "HH:mm" or "HH.mm"
    final timeParts = timeStr.replaceAll('.', ':').split(':');
    final hour = int.parse(timeParts[0]);
    final minute = timeParts.length > 1 ? int.parse(timeParts[1]) : 0;
    
    return DateTime(year, month, day, hour, minute);
  }

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      date: json['date'],
      time: json['time'],
      isDone: json['isDone'] == 1 || json['isDone'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date,
      'time': time,
      'isDone': isDone,
    };
  }
}