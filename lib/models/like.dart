class Like {
  final String id;
  final String userId;
  final String productId;

  Like({required this.id, required this.userId, required this.productId});

  factory Like.fromJson(Map<String, dynamic> json) {
    return Like(
        id: json['id'], userId: json['userId'], productId: json['productId']);
  }
}
