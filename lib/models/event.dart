import 'dart:convert';

class Event {
  final String id;
  final String title;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final String location;
  final List<String> images;
  final String
      organizer; // Assuming organizer ID is sufficient for your use case
  final List<String> likes; // Assuming list of user IDs who liked the event
  final DateTime createdAt;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.location,
    required this.images,
    required this.organizer,
    required this.likes,
    required this.createdAt,
  });

  // A method to initialize an Event with default values
  static Event initialEvent() {
    return Event(
      id: "",
      title: "",
      description: "",
      startDate: DateTime.now(),
      endDate: DateTime.now(),
      location: "",
      images: [],
      organizer: "",
      likes: [],
      createdAt: DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'title': title,
      'description': description,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'location': location,
      'images': images,
      'organizer': organizer,
      'likes': likes,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      id: map['_id'] ?? "",
      title: map['title'] ?? "",
      description: map['description'] ?? "",
      startDate: DateTime.parse(map['startDate']),
      endDate: DateTime.parse(map['endDate']),
      location: map['location'] ?? "",
      images: List<String>.from(map['images'] ?? []),
      organizer: map['organizer'] ?? "",
      likes: List<String>.from(map['likes'] ?? []),
      createdAt: DateTime.parse(map['createdAt'] ?? DateTime.now().toString()),
    );
  }

  String toJson() => json.encode(toMap());

  factory Event.fromJson(String source) => Event.fromMap(json.decode(source));
}
