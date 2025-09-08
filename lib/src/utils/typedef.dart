import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import '../../core/error/failure.dart';

typedef ResultParams<Type> = Future<Either<Failure, Type>>;

typedef ResultParam<Type> = Either<Failure, Type>;

typedef DataMap = Map<String, dynamic>;

typedef ListDocMap = List<DocumentChange<DataMap>>;

typedef QuerySnapData = QuerySnapshot<Map<String, dynamic>>;
