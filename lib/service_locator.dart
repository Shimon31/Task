import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'core/constants/app_constants.dart';
import 'data/datasources/favorites_local_datasource.dart';
import 'data/datasources/product_remote_datasource.dart';
import 'data/repositories/product_repository_impl.dart';
import 'presentation/bloc/favorites_bloc.dart';
import 'presentation/bloc/product_bloc.dart';

class ServiceLocator {
  ServiceLocator._();

  static late ProductBloc productBloc;
  static late FavoritesBloc favoritesBloc;

  static Future<void> init() async {
    final box = await Hive.openBox(AppConstants.favoritesBoxName);

    final remoteDataSource = ProductRemoteDataSourceImpl(client: http.Client());
    final localDataSource = FavoritesLocalDataSourceImpl(box: box);

    final repository = ProductRepositoryImpl(
      remoteDataSource: remoteDataSource,
      localDataSource: localDataSource,
    );

    productBloc = ProductBloc(repository: repository);
    favoritesBloc = FavoritesBloc();
  }
}