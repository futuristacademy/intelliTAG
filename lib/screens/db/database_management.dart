import 'package:cloud_firestore/cloud_firestore.dart';


class DataBaseManagement{
  static DocumentReference tagAggregator;
  static DocumentReference userAggregator;


  void init()
  {
    tagAggregator = Firestore.instance.collection("Aggregators").document("Tags");
    userAggregator = Firestore.instance.collection("Aggregators").document("Users");

  }
}