import 'dart:convert';

import 'package:uniplanet_mobile/models/myChatRoom.dart';

class User {
  final String id;
  final String name;
  final String email;
  final String profileImage;
  final String school;
  final bool verified;
  final List<String> myEvent;
  final List<String> recentSearchHistory;
  final List<String> like;
  final List<String> selling;
  final List<String> bought;
  final List<String> sold;
  final List<MyChatRoom> myChatRoom;

  final String type;
  final String token;
  User({
    required this.id,
    required this.name,
    required this.email,
    required this.profileImage,
    required this.school,
    required this.verified,
    required this.myEvent,
    required this.recentSearchHistory,
    required this.like,
    required this.selling,
    required this.bought,
    required this.sold,
    required this.myChatRoom,
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
        myEvent: [],
        recentSearchHistory: [],
        like: [],
        selling: [],
        bought: [],
        sold: [],
        myChatRoom: [],
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
      'myEvent': myEvent,
      'recentSearchHistory': recentSearchHistory,
      'like': like,
      'selling': selling,
      'bought': bought,
      'sold': sold,
      'myChatRooms': myChatRoom,
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
      myEvent: List<String>.from(map['myEvent'] ?? []),
      recentSearchHistory: List<String>.from(map['recentSearchHistory'] ?? []),
      like: List<String>.from(map['like'] ?? []),
      selling: List<String>.from(map['selling'] ?? []),
      bought: List<String>.from(map['bought'] ?? []),
      sold: List<String>.from(map['sold'] ?? []),
      myChatRoom: (map['myChatRoom'] as List<dynamic>?)
              ?.map((e) => MyChatRoom.fromMap(e as Map<String, dynamic>))
              .toList() ??
          [],
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
    List<String>? myEvent,
    List<String>? recentSearchHistory,
    List<String>? like,
    List<String>? selling,
    List<String>? bought,
    List<String>? sold,
    List<MyChatRoom>? myChatRoom,
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
      myEvent: myEvent ?? this.myEvent,
      recentSearchHistory: recentSearchHistory ?? this.recentSearchHistory,
      like: like ?? this.like,
      selling: selling ?? this.selling,
      bought: bought ?? this.bought,
      sold: sold ?? this.sold,
      myChatRoom: myChatRoom ?? this.myChatRoom,
      type: type ?? this.type,
      token: token ?? this.token,
    );
  }
}
