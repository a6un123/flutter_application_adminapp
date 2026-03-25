import 'package:flutter_application_adminapp/data/repositiores/productrepositiories/productrepositiores.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'product_event.dart';
import 'product_state.dart';

class AdminProductBloc extends Bloc<AdminProductEvent, AdminProductState> {
  final ProductRepository _repository;

  AdminProductBloc(this._repository) : super(AdminProductInitial()) {
    on<LoadProducts>(_onLoad);
    on<AddProduct>(_onAdd);
    on<UpdateProduct>(_onUpdate);
    on<DeleteProduct>(_onDelete);
  }

  Future<void> _onLoad(
    LoadProducts event,
    Emitter<AdminProductState> emit,
  ) async {
    emit(AdminProductLoading());
    await emit.forEach(
      _repository.getProducts(),
      onData: (products) => AdminProductLoaded(products),
      onError: (e, _) => AdminProductError(e.toString()),
    );
  }

  Future<void> _onAdd(AddProduct event, Emitter<AdminProductState> emit) async {
    try {
      await _repository.addProduct(event.product, imageFile: event.imageFile);
      emit(AdminProductSuccess());
    } catch (e) {
      emit(AdminProductError(e.toString()));
    }
  }

  Future<void> _onUpdate(
    UpdateProduct event,
    Emitter<AdminProductState> emit,
  ) async {
    try {
      await _repository.updateProduct(event.productId, event.data);
      emit(AdminProductSuccess());
    } catch (e) {
      emit(AdminProductError(e.toString()));
    }
  }

  Future<void> _onDelete(
    DeleteProduct event,
    Emitter<AdminProductState> emit,
  ) async {
    try {
      await _repository.deleteProduct(event.productId);
      emit(AdminProductSuccess());
    } catch (e) {
      emit(AdminProductError(e.toString()));
    }
  }
}
