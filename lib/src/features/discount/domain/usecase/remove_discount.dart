import 'package:equatable/equatable.dart';
import 'package:pwa_sales2go_flutter/src/utils/typedef.dart';
import 'package:pwa_sales2go_flutter/src/utils/usecase.dart';
import '../repositories/discount_repository.dart';

class RemoveDiscount extends UseCaseWithParams<void, RemoveDiscountParam> {
  final DiscountRepository _repository;

  RemoveDiscount(this._repository);

  @override
  ResultParams<void> call(RemoveDiscountParam params) =>
      _repository.removeDiscount(idDiscount: params.idDiscount);
}

class RemoveDiscountParam extends Equatable {
  final String idDiscount;

  const RemoveDiscountParam({required this.idDiscount});

  const RemoveDiscountParam.empty() : this(idDiscount: '');

  @override
  List<Object?> get props => [
        idDiscount,
      ];
}
