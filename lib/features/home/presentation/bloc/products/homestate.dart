import 'package:livilon/features/home/domain/model/productmodel.dart';

abstract class Homestate {}

abstract class HomeActionstate extends Homestate {}

class HomeInitial extends Homestate {}

class HomeLoadinggstate extends Homestate {}

class HomeLoadedSuccesState extends Homestate {
  final List<Productmodel> products;
  HomeLoadedSuccesState({required this.products});
}

class HomeErrorState extends Homestate {}

class HomeNavigateTowishlistPageActionstate extends HomeActionstate {}

class HomeNavigateToCartPageActionstate extends HomeActionstate {}
