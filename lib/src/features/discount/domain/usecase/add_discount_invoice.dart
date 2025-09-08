import 'package:equatable/equatable.dart';
import 'package:pwa_sales2go_flutter/src/utils/typedef.dart';
import 'package:pwa_sales2go_flutter/src/utils/usecase.dart';
import '../repositories/discount_repository.dart';

class AddDiscountInvocice extends UseCaseWithParams<void, AddDiscountInvociceParam> {
  final DiscountRepository _repository;

  AddDiscountInvocice(this._repository);

  @override
  ResultParams<void> call(AddDiscountInvociceParam params) =>
      _repository.addDiscountInvoice(idDiscount: params.idDiscount,idInvoice:params.idInvoice,idClient:params.idClient  );
}

class AddDiscountInvociceParam extends Equatable {
  final String idDiscount;
  final String idInvoice;
  final String idClient;

  const AddDiscountInvociceParam({required this.idDiscount, required this.idInvoice, required this.idClient});

  const AddDiscountInvociceParam.empty() : this(idDiscount: '',idInvoice:'', idClient:'');

  @override
  List<Object?> get props => [
        idDiscount,
        idInvoice,
        idClient
      ];
}
