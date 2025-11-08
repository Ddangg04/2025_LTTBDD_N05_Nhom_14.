import 'package:firebase_database/firebase_database.dart';

class FieldService {
  final DatabaseReference _fieldsRef = FirebaseDatabase.instance.ref('fields');

  // Stream realtime
  Stream<DatabaseEvent> getFieldsStream() => _fieldsRef.onValue;
}
