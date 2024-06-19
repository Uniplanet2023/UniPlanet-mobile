class ClickData {
  final String date;
  final int clickCount;

  ClickData({
    required this.date,
    required this.clickCount,
  });

  // Factory constructor to create a ClickData instance from a JSON map
  factory ClickData.fromJson(Map<String, dynamic> json) {
    return ClickData(
      date: json['date'],
      clickCount: json['clickCount'],
    );
  }

  // Method to convert a ClickData instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'clickCount': clickCount,
    };
  }

  // Factory constructor to create a ClickData instance from a Dart map
  factory ClickData.fromMap(Map<String, dynamic> map) {
    return ClickData(
      date: map['date'],
      clickCount: map['clickCount'],
    );
  }

  // Method to convert a ClickData instance to a Dart map
  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'clickCount': clickCount,
    };
  }

  @override
  String toString() {
    return 'ClickData(date: $date, clickCount: $clickCount)';
  }
}
