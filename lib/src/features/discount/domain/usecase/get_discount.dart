import 'package:equatable/equatable.dart';
import 'package:pwa_sales2go_flutter/src/utils/typedef.dart';
import 'package:pwa_sales2go_flutter/src/utils/usecase.dart';
import '../entities/discount.dart';
import '../repositories/discount_repository.dart';

class GetDiscount extends UseCaseWithParams<Discount, GetDiscountParam> {
  final DiscountRepository _repository;

  GetDiscount(this._repository);

  @override
  ResultParams<Discount> call(GetDiscountParam params) =>
      _repository.getDiscount(codigo: params.codigo);
}

class GetDiscountParam extends Equatable {
  final String codigo;

  const GetDiscountParam({required this.codigo});

  const GetDiscountParam.empty() : this(codigo: '');

  @override
  List<Object?> get props => [codigo];
}
