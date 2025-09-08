import 'dart:typed_data';

import 'package:equatable/equatable.dart';

class Token extends Equatable {
  const Token({required this.value}) : super();

  final Uint8List value;

  @override
  List<Object?> get props => [value];
}
