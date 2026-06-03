import '../../core/network/exceptions.dart';
import '../../core/utils/either.dart';
import '../datasources/favorites_local_datasource.dart';
import '../datasources/product_remote_datasource.dart';
import '../models/product_model.dart';
import 'product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;
  final FavoritesLocalDataSource localDataSource;

  ProductRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<String, List<ProductModel>>> getProducts() async {
    try {
      final products = await remoteDataSource.getProducts();
      return Right(products);
    } on ServerException catch (e) {
      return Left(e.message);
    } on NetworkException catch (e) {
      return Left(e.message);
    } catch (_) {
      return const Left('An unexpected error occurred. Please try again.');
    }
  }

  @override
  Future<Either<String, List<int>>> getFavoriteIds() async {
    try {
      final ids = await localDataSource.getFavoriteIds();
      return Right(ids);
    } on CacheException catch (e) {
      return Left(e.message);
    } catch (_) {
      return const Left('Failed to load favorites.');
    }
  }

  @override
  Future<Either<String, void>> toggleFavorite(
      int productId,
      List<int> currentIds,
      ) async {
    try {
      final updatedIds = List<int>.from(currentIds);
      if (updatedIds.contains(productId)) {
        updatedIds.remove(productId);
      } else {
        updatedIds.add(productId);
      }
      await localDataSource.saveFavoriteIds(updatedIds);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(e.message);
    } catch (_) {
      return const Left('Failed to update favorites.');
    }
  }
}