import 'dart:convert';
import 'package:uniplanet/core/entities/user.dart';
import 'package:uniplanet/features/account/domain/entities/user_interaction_entity.dart';

class UserInteractionModel {
  final User user;
  final String advertisement;

  UserInteractionModel({
    required this.user,
    required this.advertisement,
  });

  // Convert from domain model to data model
  factory UserInteractionModel.fromDomain(
      UserInteractionEntity userInteractionEntity) {
    return UserInteractionModel(
      user: userInteractionEntity.user,
      advertisement: userInteractionEntity.advertisement,
    );
  }

  // Convert from data model to domain model
  UserInteractionEntity toDomain() {
    return UserInteractionEntity(
      user: user,
      advertisement: advertisement,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'user': user.toMap(),
      'advertisement': advertisement,
    };
  }

  factory UserInteractionModel.fromMap(Map<String, dynamic> map) {
    return UserInteractionModel(
      user: User.fromMap(map['account']),
      advertisement: map['advertisement'] ?? '',
    );
  }

  factory UserInteractionModel.fromJson(String source) =>
      UserInteractionModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
