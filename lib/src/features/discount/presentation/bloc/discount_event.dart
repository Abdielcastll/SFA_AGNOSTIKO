part of 'discount_bloc.dart';

abstract class DiscountEvent extends Equatable {
  const DiscountEvent();
  @override
  List<Object> get props => [];
}

class GetDiscountEvent extends DiscountEvent {
  final String code;
  const GetDiscountEvent(this.code);
  @override
  List<Object> get props => [code];
}

class RemoveDiscountEvent extends DiscountEvent {
  final String idOrder;

  const RemoveDiscountEvent(this.idOrder);
  @override
  List<Object> get props => [idOrder];
}

class ResetDiscountBlocEvent extends DiscountEvent {}
