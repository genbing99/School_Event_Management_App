import 'package:cloud_firestore/cloud_firestore.dart';

class Team{
  String _eventID;
  int _totalMember;
  List <String> _addedUserEmail, _addedUserRole;
  Team(this._eventID, this._addedUserEmail, this._addedUserRole);
  Future <bool> storeTeam() async{
    _totalMember=_addedUserEmail.length;
    try{
      for (int i=0; i<_totalMember; i++)
        Firestore.instance.collection('Event').document(_eventID).collection('Team').document(_addedUserEmail[i]).setData(
          {'UserEmail':_addedUserEmail[i], 'UserRole':_addedUserRole[i]});
      return true;
    }catch (e){
      print(e);
      return false;
    }
  }
}