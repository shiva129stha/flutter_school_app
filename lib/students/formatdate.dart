import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

String formatDate(Timestamp timestamp) {
  final date = timestamp.toDate();
  final formatter = DateFormat('yyyy-MM-dd HH:mm');
  return formatter.format(date);
}
