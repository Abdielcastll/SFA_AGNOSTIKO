import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pwa_sales2go_flutter/core/error/failure.dart';
import 'package:pwa_sales2go_flutter/src/features/discount/domain/usecase/add_discount_order.dart';

import '../../discount_data.dart';

part 'discount_event.dart';
part 'discount_state.dart';

class DiscountBloc extends Bloc<DiscountEvent, DiscountState> {
  final AddDiscountOrder _addDiscountOrder;
  final GetDiscount _getDiscount;
  final RemoveDiscount _removeDiscount;
  DiscountBloc(
    AddDiscountOrder addDiscountOrder,
    GetDiscount getDiscount,
    RemoveDiscount removeDiscount,
  )   : _getDiscount = getDiscount,
        _removeDiscount = removeDiscount,
        _addDiscountOrder = addDiscountOrder,
        super(const DiscountState()) {
    on<GetDiscountEvent>(_onGetDiscountEventHandler);
    on<RemoveDiscountEvent>(_onRemoveDiscountEventHandler);
    on<ResetDiscountBlocEvent>(_onResetDiscountBlocHandler);
    on<AddDiscountOrderEvent>(_onAddDiscountOrderHandler);
  }

  FutureOr<void> _onGetDiscountEventHandler(
    GetDiscountEvent event,
    Emitter<DiscountState> emit,
  ) async {
    emit(state.copyWith(loading: true));
    final result = await _getDiscount(GetDiscountParam(codigo: event.code));
    result.fold(
      (failure) => emit(
        state.copyWith(
          failure: failure,
          loading: false,
        ),
      ),
      (discount) => emit(
        state.copyWith(
          discount: discount,
          loading: false,
        ),
      ),
    );
  }

  FutureOr<void> _onRemoveDiscountEventHandler(
    RemoveDiscountEvent event,
    Emitter<DiscountState> emit,
  ) async {
    emit(state.copyWith(loading: true));
    final result = await _removeDiscount(
        RemoveDiscountParam(idDiscount: event.idDiscount));
    result.fold(
      (failure) => emit(
        state.copyWith(
          failure: failure,
          loading: false,
        ),
      ),
      (_) => emit(const DiscountState()),
    );
  }

  FutureOr<void> _onResetDiscountBlocHandler(
    ResetDiscountBlocEvent event,
    Emitter<DiscountState> emit,
  ) {
    emit(const DiscountState());
  }

  FutureOr<void> _onAddDiscountOrderHandler(
      AddDiscountOrderEvent event, Emitter<DiscountState> emit) async {
    emit(state.copyWith(loading: true));
    final result = await _addDiscountOrder(event.params);
    result.fold(
      (failure) => emit(
        state.copyWith(
          failure: failure,
          loading: false,
        ),
      ),
      (discount) => emit(
        state.copyWith(
          loading: false,
        ),
      ),
    );
  }
}
