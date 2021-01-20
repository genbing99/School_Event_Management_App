import 'package:cloud_firestore/cloud_firestore.dart';

class Notification1{
  String _details, _userEmail;
  int _level;
  Notification1(this._userEmail, this._level, this._details);
  Future <bool> storeNotification() async{
    try{
        Firestore.instance.collection('Notification').document().setData(
          {'Issuer':_userEmail, 'Level':_level, 'Details': _details});
      return true;
    }catch (e){
      print(e);
      return false;
    }
  }
  String getDetails(){
    return _details;
  }
  int getLevel(){
    return _level;
  }
}