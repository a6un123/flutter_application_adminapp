import 'package:equatable/equatable.dart';
import 'package:flutter_application_adminapp/data/model/productmodels/productmodels.dart';

abstract class AdminProductState extends Equatable {
  const AdminProductState();
  @override
  List<Object?> get props => [];
}

class AdminProductInitial extends AdminProductState {}

class AdminProductLoading extends AdminProductState {}

class AdminProductSuccess extends AdminProductState {}

class AdminProductLoaded extends AdminProductState {
  final List<Productmodel> products;
  const AdminProductLoaded(this.products);
  @override
  List<Object?> get props => [products];
}

class AdminProductError extends AdminProductState {
  final String message;
  const AdminProductError(this.message);
  @override
  List<Object?> get props => [message];
}
