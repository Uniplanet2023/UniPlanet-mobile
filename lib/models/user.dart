// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class User {
  final String id;
  final String name;
  final String email;
  final String profileImage;
  final String school;
  final bool verified;
  final bool isOnline;
  final List<String> unseenNotifications;
  final List<String> unseenMessages;
  final List<String> like;
  final List<String> selling;
  final List<String> bought;
  final List<String> sold;
  final List<String> chatRooms;
  final String type;
  final String token;
  User({
    required this.id,
    required this.name,
    required this.email,
    required this.profileImage,
    required this.school,
    required this.verified,
    required this.isOnline,
    required this.unseenNotifications,
    required this.unseenMessages,
    required this.like,
    required this.selling,
    required this.bought,
    required this.sold,
    required this.chatRooms,
    required this.type,
    this.token = "",
  });
  static initialUser() {
    return User(
        id: '',
        name: '',
        email: '',
        profileImage: '',
        school: '',
        verified: false,
        isOnline: false,
        unseenNotifications: [],
        unseenMessages: [],
        like: [],
        selling: [],
        bought: [],
        sold: [],
        chatRooms: [],
        type: '',
        token: '');
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'email': email,
      'profileImage': profileImage,
      'school': school,
      'verified': verified,
      'isOnline': isOnline,
      'unseenNotifications': unseenNotifications,
      'unseenMessages': unseenMessages,
      'like': like,
      'selling': selling,
      'bought': bought,
      'sold': sold,
      'chatRooms': chatRooms,
      'type': type,
      'token': token,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['_id'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      profileImage: map['profileImage'] as String ??
          'https://res.cloudinary.com/dtgmmfv3d/image/upload/v1698359487/defaultImage/uj24px95hnrhydxobjl1.jpg',
      school: map['school'] as String,
      verified: map['verified'] as bool,
      isOnline: map['isOnline'] as bool,
      unseenNotifications: List<String>.from(map['unseenNotifications']),
      unseenMessages: List<String>.from(map['unseenMessages']),
      like: List<String>.from(map['like']),
      selling: List<String>.from(map['selling']),
      bought: List<String>.from(map['bought']),
      sold: List<String>.from(map['sold']),
      chatRooms: List<String>.from(map['chatRooms']),
      type: map['type'] as String,
      token: map['token'] ?? "",
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? profileImage,
    String? school,
    bool? verified,
    bool? isOnline,
    List<String>? unseenNotifications,
    List<String>? unseenMessages,
    List<String>? like,
    List<String>? selling,
    List<String>? bought,
    List<String>? sold,
    List<String>? chatRooms,
    String? type,
    String? token,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      profileImage: profileImage ?? this.profileImage,
      school: school ?? this.school,
      verified: verified ?? this.verified,
      isOnline: isOnline ?? this.isOnline,
      unseenNotifications: unseenNotifications ?? this.unseenNotifications,
      unseenMessages: unseenMessages ?? this.unseenMessages,
      like: like ?? this.like,
      selling: selling ?? this.selling,
      bought: bought ?? this.bought,
      sold: sold ?? this.sold,
      chatRooms: chatRooms ?? this.chatRooms,
      type: type ?? this.type,
      token: token ?? this.token,
    );
  }
}
