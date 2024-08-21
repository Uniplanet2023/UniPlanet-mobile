import 'dart:convert';
import 'package:uniplanet/core/entities/user.dart';
import 'package:uniplanet/core/isar/collection/user.dart';
import 'package:uniplanet/features/account/domain/entities/account.dart';
import 'package:uniplanet/core/isar/collection/user.dart';
import 'package:isar/isar.dart';


part 'account_model.g.dart';

@Collection()
class AccountModel extends AccountEntity {
  Id isarId = Isar.autoIncrement;
  late String type;
  late bool isBlocked;
  late bool isBlockedPost;
  late bool isBlockedChat;
  final user = IsarLink<UserLocalModel>(); // This stores the linked UserLocalModel in Isar

  AccountModel({
    required this.type,
    required this.isBlocked,
    required this.isBlockedPost,
    required this.isBlockedChat,
  }) : super(
          user: User.initialUser(), // Initialize with a default user
          type: type,
          isBlocked: isBlocked,
          isBlockedPost: isBlockedPost,
          isBlockedChat: isBlockedChat,
        );

  // Factory method to convert domain model to data model
  factory AccountModel.fromDomain(AccountEntity account) {
    final accountModel = AccountModel(
      type: account.type,
      isBlocked: account.isBlocked,
      isBlockedPost: account.isBlockedPost,
      isBlockedChat: account.isBlockedChat,
    );

    // Link the user model
    accountModel.user.value = UserLocalModel.fromUser(account.user); // Convert UserEntity to Isar Model
    return accountModel;
  }

  // Method to convert data model to domain model
  Future<AccountEntity> toDomain() async {
    await user.load();
    return AccountEntity(
      user: user.value!.toUser(), // Convert Isar Model to UserEntity
      type: type,
      isBlocked: isBlocked,
      isBlockedPost: isBlockedPost,
      isBlockedChat: isBlockedChat,
    );
  }

  // Convert to a map for potential serialization
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'type': type,
      'isBlocked': isBlocked,
      'isBlockedPost': isBlockedPost,
      'isBlockedChat': isBlockedChat,
      // Note: `user` will be handled by Isar, so it's not included in the map
    };
  }

  // Convert from a map (e.g., for deserialization)
  factory AccountModel.fromMap(Map<String, dynamic> map) {
    return AccountModel(
      type: map['type'] ?? 'student',
      isBlocked: map['isBlocked'] as bool,
      isBlockedPost: map['isBlockedPost'] as bool,
      isBlockedChat: map['isBlockedChat'] as bool,
    );
  }

  // Convert to JSON
  factory AccountModel.fromJson(String source) =>
      AccountModel.fromMap(json.decode(source) as Map<String, dynamic>);
}