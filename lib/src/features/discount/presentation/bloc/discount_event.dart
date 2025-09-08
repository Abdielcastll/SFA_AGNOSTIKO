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
  final String idDiscount;

  const RemoveDiscountEvent(this.idDiscount);
  @override
  List<Object> get props => [idDiscount];
}

class AddDiscountOrderEvent extends DiscountEvent {
  final AddDiscountOrderParam params;

  const AddDiscountOrderEvent(this.params);
  @override
  List<Object> get props => [params];
}

class ResetDiscountBlocEvent extends DiscountEvent {}
