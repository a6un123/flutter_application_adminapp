import 'package:equatable/equatable.dart';
import 'package:flutter_application_adminapp/data/model/productmodels/productmodels.dart';

class Cartmodel extends Equatable {
  final Productmodel product;
  final int quantity;

  const Cartmodel({required this.product, required this.quantity});

  double get totalPrice => product.price * quantity;

  @override
  List<Object?> get props => [product, quantity];
}
