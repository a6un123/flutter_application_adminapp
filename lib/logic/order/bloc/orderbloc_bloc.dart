import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_adminapp/data/repositiores/orderrepositiores/orderrepostiores.dart';
import 'orderbloc_event.dart';
import 'orderbloc_state.dart';

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
    // Keep current orders while updating
    final currentOrders = state is AdminOrderLoaded
        ? (state as AdminOrderLoaded).orders
        : [];
    try {
      await _repository.updateStatus(event.orderId, event.status);
      // Don't emit success — stream will auto-update
      // emit.forEach keeps listening so UI updates automatically
    } catch (e) {
      emit(AdminOrderError(e.toString()));
      // Restore orders on error
      if (currentOrders.isNotEmpty) {
        emit(AdminOrderLoaded(List.from(currentOrders)));
      }
    }
  }

  Future<void> _onCancel(
    CancelOrder event,
    Emitter<AdminOrderState> emit,
  ) async {
    final currentOrders = state is AdminOrderLoaded
        ? (state as AdminOrderLoaded).orders
        : [];
    try {
      await _repository.cancelOrder(event.orderId);
      // Stream auto-updates — no need to emit
    } catch (e) {
      emit(AdminOrderError(e.toString()));
      if (currentOrders.isNotEmpty) {
        emit(AdminOrderLoaded(List.from(currentOrders)));
      }
    }
  }
}
