part of 'discount_bloc.dart';

class DiscountState extends Equatable {
  const DiscountState({
    this.discount,
    this.failure,
    this.loading = false,
  });

  final Discount? discount;
  final Failure? failure;
  final bool loading;

  DiscountState copyWith({
    Discount? discount,
    Failure? failure,
    bool? loading,
  }) =>
      DiscountState(
        discount: discount ?? this.discount,
        failure: failure ?? this.failure,
        loading: loading ?? this.loading,
      );

  @override
  List<Object?> get props => [
        discount,
        failure,
        loading,
      ];
}
