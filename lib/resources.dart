import 'package:cloud_firestore/cloud_firestore.dart';
import 'user.dart';

class Resource{
  String _resourceID, _name, _type, _status, _borrowerEmail, _teamID, _userEmail;
  DateTime _expiredDate;
  Resource(this._resourceID, this._name, this._type, this._status, this._expiredDate, this._borrowerEmail, this._teamID, this._userEmail);
  
  Future <bool> storeResource() async{
    try{
      Firestore.instance.collection('Resource').document(_resourceID).setData
      (
        {
          'Name':_name, 
          'Type': _type, 
          'Status': _status, 'Type': _type, 'ExpiredDate':_expiredDate,
          'BorrowerEmail':_borrowerEmail, 
          'TeamID': _teamID, 
          'LenderEmail':_userEmail 
        }
      );
      return true;
    }catch (e){
      print(e);
      return false;
    }
  }

  String displayResources(){
    return ('Item Name: $_name \nResource Type: $_type\nTeam ID: $_teamID\nBorrower Email: $_borrowerEmail');
  }
  String displayBorrowedResources(){
    return ('Item Name: $_name \nResource Type: $_type\nTeam ID: $_teamID\nLender Email: $_userEmail');
  }
  String getLenderEmail(){
    return _userEmail;
  }
  Future <bool> updateLender() async{
    _status='Lent';
    _userEmail= User.currentUserEmail;
    try{
      Firestore.instance.collection('Resource').document(_resourceID).updateData
      (
        {
          'Status': _status, 
          'LenderEmail':_userEmail 
        }
      );
      return true;
    }catch (e){
      print(e);
      return false;
    }
  }
}