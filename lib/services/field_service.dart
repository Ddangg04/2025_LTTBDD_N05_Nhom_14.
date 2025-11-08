import 'package:firebase_database/firebase_database.dart';

class FieldService {
  final DatabaseReference _fieldsRef =
      FirebaseDatabase.instance.ref('san_bong');

  Stream<DatabaseEvent> getFieldsStream() => _fieldsRef.onValue;
}
