import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:flutter_application_adminapp/data/model/productmodels/productmodels.dart';

abstract class AdminProductEvent extends Equatable {
  const AdminProductEvent();
  @override
  List<Object?> get props => [];
}

class LoadProducts extends AdminProductEvent {}

class AddProduct extends AdminProductEvent {
  final Productmodel product;
  final File? imageFile;
  const AddProduct({required this.product, this.imageFile});
  @override
  List<Object?> get props => [product];
}

class UpdateProduct extends AdminProductEvent {
  final String productId;
  final Map<String, dynamic> data;
  const UpdateProduct({required this.productId, required this.data});
  @override
  List<Object?> get props => [productId, data];
}

class DeleteProduct extends AdminProductEvent {
  final String productId;
  const DeleteProduct(this.productId);
  @override
  List<Object?> get props => [productId];
}
