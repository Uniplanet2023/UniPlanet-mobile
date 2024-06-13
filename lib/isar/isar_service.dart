import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uniplanet/isar/collection/account.dart';
import 'package:uniplanet/isar/collection/chat_room.dart';
import 'package:uniplanet/isar/collection/message.dart';
import 'package:uniplanet/isar/collection/product.dart';
import 'package:uniplanet/isar/collection/user.dart';
import 'package:uniplanet/models/account.dart';
import 'package:uniplanet/models/chat_room.dart';
import 'package:uniplanet/models/message.dart';
import 'package:uniplanet/models/product.dart';

class IsarService {
  late Future<Isar> db;
  static final IsarService _instance = IsarService._internal();
  static IsarService get instance => _instance;

  IsarService._internal() {
    db = openDB();
  }

  Future<Isar> openDB() async {
    final dir = await getApplicationDocumentsDirectory();
    if (Isar.instanceNames.isEmpty) {
      return await Isar.open(
        directory: dir.path,
        [
          UserModelSchema,
          AccountModelSchema,
          ChatRoomModelSchema,
          MessageModelSchema,
          ProductModelSchema,
        ],
        inspector: true,
      );
    }
    return Future.value(Isar.getInstance());
  }

  Future<void> saveProductList(List<Product> productList) async {
    final isar = await db;

    final List<ProductModel> productModels = [];
    final List<UserModel> userModelsToInsert = [];
    final List<UserModel> existingUsers =
        await isar.userModels.where().findAll();

    // Create a map for quick lookup of existing users
    final Map<String, UserModel> existingUserMap = {
      for (var user in existingUsers) user.email: user
    };

    for (var product in productList) {
      ProductModel productModel = ProductModel.fromProduct(product);

      UserModel sellerModel;
      if (existingUserMap.containsKey(product.seller.email)) {
        sellerModel = existingUserMap[product.seller.email]!;
      } else {
        sellerModel = UserModel.fromUser(product.seller);
        userModelsToInsert.add(sellerModel);
        existingUserMap[product.seller.email] = sellerModel;
      }

      productModel.seller.value = sellerModel;
      productModels.add(productModel);
    }

    await isar.writeTxn(() async {
      await isar.productModels.clear();
      // Bulk insert users if there are new users to insert
      if (userModelsToInsert.isNotEmpty) {
        await isar.userModels.putAll(userModelsToInsert);
      }
      // Bulk insert products
      await isar.productModels.putAll(productModels);

      // Save the links within the same transaction
      for (var productModel in productModels) {
        await productModel.seller.save();
      }
    });
  }

  Future<List<Product>> getProductList() async {
    final isar = await db;
    final productModels = await isar.productModels.where().findAll();
    final products = <Product>[];

    await isar.writeTxn(() async {
      for (var productModel in productModels) {
        final product = await productModel.toProduct();
        products.add(product);
      }
    });

    return products;
  }

  Future<void> saveMessages(List<Message> messages) async {
    final isar = await db;
    List<MessageModel> messageModels =
        messages.map((e) => MessageModel.fromMessage(e)).toList();

    isar.writeTxnSync(() {
      isar.messageModels.putAllSync(messageModels);
    });
  }

  Future<Account> saveAccount(Account account) async {
    final isar = await db;
    AccountModel accountModel = AccountModel.fromAccount(account);
    UserModel userModel = UserModel.fromUser(account.user);
    // Check if a user with the same email already exists
    final existingUser = await isar.userModels
        .where()
        .filter()
        .emailEqualTo(account.user.email)
        .findFirst();
    final existingAccount = await isar.accountModels.where().findFirst();
    accountModel.user.value = userModel;
    await isar.writeTxn(() async {
      // Update isarUser
      if (existingUser != null) {
        await isar.userModels.delete(existingUser.isarId);
      }
      await isar.userModels.put(userModel);
      // Update isarAccount
      if (existingAccount != null) {
        await isar.accountModels.delete(existingAccount.isarId);
      }
      await isar.accountModels.put(accountModel);
      await accountModel.user.save();
    });
    return account;
  }

  Future<Account?> getAccount() async {
    final isar = await db;

    final accountModel = await isar.accountModels.where().findFirst();
    if (accountModel != null) {
      return await accountModel.toAccount();
    }
    return null;
  }

  Future<void> saveChatData(List<ChatRoom> chatRooms) async {
    final isar = await db;

    final List<ChatRoomModel> chatRoomModels = [];
    final List<UserModel> userModelsToInsert = [];
    final List<MessageModel> messageModelsToInsert = [];
    final List<UserModel> existingUsers =
        await isar.userModels.where().findAll();

    // Create a map for quick lookup of existing users
    final Map<String, UserModel> existingUserMap = {
      for (var user in existingUsers) user.email: user
    };

    for (var chatRoom in chatRooms) {
      ChatRoomModel chatRoomModel = ChatRoomModel.fromChatRoom(chatRoom);

      UserModel sellerModel;
      if (existingUserMap.containsKey(chatRoom.seller.email)) {
        sellerModel = existingUserMap[chatRoom.seller.email]!;
      } else {
        sellerModel = UserModel.fromUser(chatRoom.seller);
        userModelsToInsert.add(sellerModel);
        existingUserMap[chatRoom.seller.email] = sellerModel;
      }

      UserModel buyerModel;
      if (existingUserMap.containsKey(chatRoom.buyer.email)) {
        buyerModel = existingUserMap[chatRoom.buyer.email]!;
      } else {
        buyerModel = UserModel.fromUser(chatRoom.buyer);
        userModelsToInsert.add(buyerModel);
        existingUserMap[chatRoom.buyer.email] = buyerModel;
      }

      chatRoomModel.seller.value = sellerModel;
      chatRoomModel.buyer.value = buyerModel;

      if (chatRoom.lastMessage != null) {
        final lastMessageModel =
            MessageModel.fromMessage(chatRoom.lastMessage!);
        chatRoomModel.lastMessage.value = lastMessageModel;
        messageModelsToInsert.add(lastMessageModel);
      } else {
        chatRoomModel.lastMessage.value = null;
      }

      chatRoomModels.add(chatRoomModel);
    }

    await isar.writeTxn(() async {
      await isar.chatRoomModels.clear();
      await isar.messageModels.clear();
      // Bulk insert users if there are new users to insert
      if (userModelsToInsert.isNotEmpty) {
        await isar.userModels.putAll(userModelsToInsert);
      }
      // Bulk insert messages if there are new messages to insert
      if (messageModelsToInsert.isNotEmpty) {
        await isar.messageModels.putAll(messageModelsToInsert);
      }
      // Bulk insert chat rooms
      await isar.chatRoomModels.putAll(chatRoomModels);

      // Save the links within the same transaction
      for (var chatRoomModel in chatRoomModels) {
        await chatRoomModel.seller.save();
        await chatRoomModel.buyer.save();
        if (chatRoomModel.lastMessage.value != null) {
          await chatRoomModel.lastMessage.save();
        }
      }
    });
  }

  Future<List<ChatRoom>> getChatRooms() async {
    final isar = await db;
    final chatRoomModels = await isar.chatRoomModels.where().findAll();
    final chatRooms = <ChatRoom>[];

    for (var chatRoomModel in chatRoomModels) {
      final chatRoom = await chatRoomModel.toChatRoom();
      chatRooms.add(chatRoom);
    }

    return chatRooms;
  }

  Future<void> cleanDb() async {
    final isar = await db;
    await isar.writeTxn(() => isar.clear());
  }

  Future<void> closeIsar() async {
    final isar = await db;
    await isar.close();
  }
}
