import 'package:cloud_firestore/cloud_firestore.dart';

class Feedback1{
  String _eventID, _userName, _description, _userEmail;
  Feedback1(this._eventID, this._userEmail, this._userName, this._description);
  Future <bool> storeFeedback() async{
    try{
      Firestore.instance.collection('Event').document(_eventID).collection('Feedback').document().setData(
        {'Email': _userEmail, 'Name': _userName, 'Description':_description});
      return true;
    }catch (e){
      print(e);
      return false;
    }
  }
  String getName(){
    return _userName;
  }
  String getDescription(){
    return _description;
  }
}