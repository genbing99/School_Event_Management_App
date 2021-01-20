import 'package:cloud_firestore/cloud_firestore.dart';

class SubgroupMember{
  String _eventID, _memberName, _subgroupName;
  SubgroupMember(this._eventID, this._memberName, this._subgroupName);
  Future <bool> storeSubgroupMember() async{
    try{
      Firestore.instance.collection('Event').document(_eventID).collection('Subgroup').document(_subgroupName).collection('SubgroupMember').document(_memberName).setData(
        {'Name':_memberName});
      return true;
    }catch (e){
      print(e);
      return false;
    }
  }
  String getName(){
    return _memberName;
  }
}