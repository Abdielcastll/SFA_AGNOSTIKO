import 'package:pwa_sales2go_flutter/src/utils/typedef.dart';

abstract class UseCaseWithParams<Type, Params> {
  const UseCaseWithParams();
  ResultParams<Type> call(Params params);
}

abstract class UseCaseWithParam<Type, Params> {
  const UseCaseWithParam();
  ResultParam<Type> call(Params params);
}

abstract class UseCaseWithOutParams<Type> {
  const UseCaseWithOutParams();
  ResultParams<Type> call();
}
