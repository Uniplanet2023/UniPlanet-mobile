import 'package:dartz/dartz.dart';
import 'package:uniplanet/core/error/failures.dart';
import 'package:uniplanet/models/product.dart';

abstract class SoldProductRepository {
  Future<Either<Failure, void>> addSoldProduct();
  Future<Either<Failure, void>> deleteSoldProduct();
  Future<Either<Failure, List<Product>?>>
      getMyProduct(); // Load More On Sold Products & load on Sold productsx
}
