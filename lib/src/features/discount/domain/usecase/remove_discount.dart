import 'package:equatable/equatable.dart';
import 'package:pwa_sales2go_flutter/src/utils/typedef.dart';
import 'package:pwa_sales2go_flutter/src/utils/usecase.dart';
import '../repositories/discount_repository.dart';

class RemoveDiscount extends UseCaseWithParams<void, RemoveDiscountParam> {
  final DiscountRepository _repository;

  RemoveDiscount(this._repository);

  @override
  ResultParams<void> call(RemoveDiscountParam params) =>
      _repository.removeDiscount(idOrder: params.idOrder);
}

class RemoveDiscountParam extends Equatable {
  final String idOrder;

  const RemoveDiscountParam({required this.idOrder});

  const RemoveDiscountParam.empty() : this(idOrder: '');

  @override
  List<Object?> get props => [
        idOrder,
      ];
}
