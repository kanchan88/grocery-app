import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:grocery_app/model/ProductModel.dart';
import 'package:grocery_app/repo/ProductRepo.dart';

abstract class ProductEvent extends Equatable{
  const ProductEvent();
}

class GetProducts extends ProductEvent{

  const GetProducts();

  @override
  List<Object> get props => [];
}

class ProductState extends Equatable{
  const ProductState();

  @override
  List<Object> get props => [];
}

class ProductIsLoaded extends ProductState{
  final _products;
  ProductIsLoaded(this._products);
  List<Product> get getProducts => _products;
}

class ProductIsNotLoaded extends ProductState{
}

class ProductIsLoading extends ProductState{
}


class ProductBloc extends Bloc<ProductEvent, ProductState>{

  ProductRepo productRepo;
  ProductBloc({this.productRepo});

  @override
  ProductState get initialState =>ProductIsNotLoaded();

  @override
  Stream<ProductState> mapEventToState(ProductEvent event) async* {

    if(event is GetProducts){
      yield ProductIsLoading();

      try{
        print("TRYING");
        List<Product> allProduct = await productRepo.fetchProducts();
        print(allProduct);
        yield ProductIsLoaded(allProduct);
      }

      catch(e){
        print(e);
        ProductIsNotLoaded();
      }
    }
  }
}