import 'package:equatable/equatable.dart';
import 'package:pwa_sales2go_flutter/src/utils/typedef.dart';
import 'package:pwa_sales2go_flutter/src/utils/usecase.dart';
import '../repositories/discount_repository.dart';

class AddDiscountOrder extends UseCaseWithParams<void, AddDiscountOrderParam> {
  final DiscountRepository _repository;

  AddDiscountOrder(this._repository);

  @override
  ResultParams<void> call(AddDiscountOrderParam params) =>
      _repository.addDiscountOrder(idDiscount: params.idDiscount,idOrder:params.idOrder,idClient:params.idClient );
}

class AddDiscountOrderParam extends Equatable {
  final String idDiscount;
  final String idOrder;
   final String idClient;

  const AddDiscountOrderParam({required this.idDiscount, required this.idOrder, required this.idClient});

  const AddDiscountOrderParam.empty() : this(idDiscount: '',idOrder:'',idClient:'');

  @override
  List<Object?> get props => [
        idDiscount,
        idOrder,idClient
      ];
}
