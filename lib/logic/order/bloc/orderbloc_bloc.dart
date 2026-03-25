import 'package:flutter_application_adminapp/data/repositiores/orderrepositiores/orderrepostiores.dart';
import 'package:flutter_application_adminapp/logic/order/bloc/orderbloc_event.dart';
import 'package:flutter_application_adminapp/logic/order/bloc/orderbloc_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminOrderBloc extends Bloc<AdminOrderEvent, AdminOrderState> {
  final OrderRepository _repository;

  AdminOrderBloc(this._repository) : super(AdminOrderInitial()) {
    on<LoadAllOrders>(_onLoadAll);
    on<UpdateOrderStatus>(_onUpdateStatus);
    on<CancelOrder>(_onCancel);
  }

  Future<void> _onLoadAll(
    LoadAllOrders event,
    Emitter<AdminOrderState> emit,
  ) async {
    emit(AdminOrderLoading());
    await emit.forEach(
      _repository.getAllOrders(),
      onData: (orders) => AdminOrderLoaded(orders),
      onError: (e, _) => AdminOrderError(e.toString()),
    );
  }

  Future<void> _onUpdateStatus(
    UpdateOrderStatus event,
    Emitter<AdminOrderState> emit,
  ) async {
    try {
      await _repository.updateStatus(event.orderId, event.status);
      emit(AdminOrderSuccess());
    } catch (e) {
      emit(AdminOrderError(e.toString()));
    }
  }

  Future<void> _onCancel(
    CancelOrder event,
    Emitter<AdminOrderState> emit,
  ) async {
    try {
      await _repository.cancelOrder(event.orderId);
      emit(AdminOrderSuccess());
    } catch (e) {
      emit(AdminOrderError(e.toString()));
    }
  }
}
