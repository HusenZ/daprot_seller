import 'package:daprot_seller/domain/add_product_repo.dart';
import 'package:daprot_seller/domain/model/product_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository productRepo = ProductRepository();
  ProductBloc() : super(ProductInitial()) {
    on<AddProductEvent>((event, emit) async {
      emit(LoadingState());
      String message = await productRepo.addProduct(event.product);
      emit(AddProductState(message: message));
    });
    on<UpdateProductEvent>((event, emit) async {
      emit(LoadingState());
      String message =
          await productRepo.updateProduct(event.product, event.originalProduct);
      emit(AddProductState(message: message));
    });
    on<DeleteProductEvent>((event, emit) async {
      emit(DeleteLoadingState());
      await productRepo.deleteProduct(event.productId).then((value) {
        if (value) {
          emit(DeleteSuccessState());
        } else {
          emit(DeleteErrorState("Uable To Delete"));
        }
      });
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
  final ProductFromDB originalProduct;
  UpdateProductEvent(this.product, this.originalProduct);
}

class DeleteProductEvent extends ProductEvent {
  final String productId;
  DeleteProductEvent(this.productId);
}

// States
abstract class ProductState {}

class ProductInitial extends ProductState {}

class LoadingState extends ProductState {}

class DeleteLoadingState extends ProductState {}

class SuccessState extends ProductState {}

class DeleteSuccessState extends ProductState {}

class AddProductState extends ProductState {
  final String message;

  AddProductState({required this.message});
}

class DeleteErrorState extends ProductState {
  final String message;

  DeleteErrorState(this.message);
}
