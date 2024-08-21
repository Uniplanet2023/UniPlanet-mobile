import 'package:dartz/dartz.dart';
import 'package:uniplanet/core/error/failures.dart';
import 'package:uniplanet/models/product.dart';

abstract class SaleProductRepository {
  Future<Either<Failure, void>> addOnSaleProduct();
  Future<Either<Failure, void>> deleteOnSaleProduct();
  Future<Either<Failure, List<Product>?>>
      getMyProduct(); // Load More On Sale Products & load on sale products
  Future<Either<Failure, void>> updateOnSaleProduct();
}
