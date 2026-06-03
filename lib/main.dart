import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/constants/app_theme.dart';
import 'data/models/product_model.dart';
import 'presentation/bloc/favorites_bloc.dart';
import 'presentation/bloc/product_bloc.dart';
import 'presentation/screens/product_list_screen.dart';
import 'service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(ProductModelAdapter());
  Hive.registerAdapter(RatingModelAdapter());

  await ServiceLocator.init();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const ShopApp());
}

class ShopApp extends StatelessWidget {
  const ShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ProductBloc>(
          create: (_) => ServiceLocator.productBloc
            ..add(const LoadProductsEvent()),
        ),
        BlocProvider<FavoritesBloc>(
          create: (_) => ServiceLocator.favoritesBloc,
        ),
      ],
      child: MaterialApp(
        title: 'ShopApp',
        theme: AppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        home: const ProductListScreen(),
      ),
    );
  }
}