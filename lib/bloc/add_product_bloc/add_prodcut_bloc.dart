import 'package:daprot_seller/domain/add_product_repo.dart';
import 'package:daprot_seller/domain/model/product_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc() : super(ProductInitial()) {
    on<AddProductEvent>((event, emit) async {
      emit(LoadingState());
      String message = await AddProductRepo().addProduct(event.product);
      emit(AddProductState(message: message));
    });
    on<UpdateProductEvent>((event, emit) async {
      emit(LoadingState());
      String message = await AddProductRepo().addProduct(event.product);
      emit(AddProductState(message: message));
    });
  }
}

// Events
abstract class ProductEvent {}

class AddProductEvent extends ProductEvent {
  final Product product;
  AddProductEvent(this.product);
}

class UpdateProductEvent extends ProductEvent {
  final Product product;
  UpdateProductEvent(this.product);
}

// States
abstract class ProductState {}

class ProductInitial extends ProductState {}

class LoadingState extends ProductState {}

class SuccessState extends ProductState {}

class AddProductState extends ProductState {
  final String message;

  AddProductState({required this.message});
}
