import 'package:cloud_firestore/cloud_firestore.dart';

class LineModel {
  final String? line;

  LineModel({
    this.line,
  });
}

class LinefromSnapshot {
  // id type list from snapshot
  List<LineModel> lineListfromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return LineModel(
        line: doc.get('nombre'),
      );
    }).toList();
  }
}
