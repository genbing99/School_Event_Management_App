import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app/subgroupMember.dart';
import 'subgroupMember.dart';

class Subgroup{
  String _eventID, _name;
  int _totalMember;
  var _subgroupMemberList = new List<SubgroupMember>();
  Subgroup(this._eventID, this._name, this._totalMember);
  Future <bool> storeSubgroup() async{
    try{
      Firestore.instance.collection('Event').document(_eventID).collection('Subgroup').document(_name).setData(
        {'Name':_name, 'TotalMember':_totalMember});
      return true;
    }catch (e){
      print(e);
      return false;
    }
  }
  void addSubgroupMember(SubgroupMember _member){
    _subgroupMemberList.add(_member);
  }
  List<SubgroupMember> getSubgroupMemberList(){
    return _subgroupMemberList;
  }
  String getName(){
    return _name;
  }
  int getTotalMember(){
    return _totalMember;
  }
}