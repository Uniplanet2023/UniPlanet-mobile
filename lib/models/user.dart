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
  final List<dynamic> unseenNotifications;
  final List<dynamic> unseenMessages;
  final List<dynamic> like;
  final List<dynamic> selling;
  final List<dynamic> bought;
  final List<dynamic> sold;
  final List<dynamic> chatRooms;
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
      unseenNotifications:
          List<dynamic>.from(map['unseenNotifications'] as List<dynamic>),
      unseenMessages:
          List<dynamic>.from(map['unseenMessages'] as List<dynamic>),
      like: List<dynamic>.from(map['like'] as List<dynamic>),
      selling: List<dynamic>.from(map['selling'] as List<dynamic>),
      bought: List<dynamic>.from(map['bought'] as List<dynamic>),
      sold: List<dynamic>.from(map['sold'] as List<dynamic>),
      chatRooms: List<dynamic>.from(map['chatRooms'] as List<dynamic>),
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
    String? profileImages,
    String? password,
    String? school,
    bool? verified,
    bool? isOnline,
    List<dynamic>? unseenNotifications,
    List<dynamic>? unseenMessages,
    List<dynamic>? like,
    List<dynamic>? selling,
    List<dynamic>? bought,
    List<dynamic>? sold,
    List<dynamic>? chatRooms,
    String? type,
    String? token,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      profileImage: profileImages ?? profileImage,
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
