import '../../core/utils/either.dart';
import '../models/product_model.dart';

abstract class ProductRepository {
  Future<Either<String, List<ProductModel>>> getProducts();
  Future<Either<String, List<int>>> getFavoriteIds();
  Future<Either<String, void>> toggleFavorite(
      int productId, List<int> currentIds);
}