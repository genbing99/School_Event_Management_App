import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Attendee{
  String _eventID, _userName, _userEmail, _status;
  DateTime _signInTime;
  Attendee(this._eventID, this._userEmail, this._userName, this._signInTime, this._status);
  
  Future <bool> storeAttedeee() async{
    try{
      Firestore.instance.collection('Event').document(_eventID).
      collection('Attendee').document(_userEmail).setData
      (
        {
          'Name': _userName, 
          'SignInTime': _signInTime, 
          'Status': _status
        }
      );
      return true;
    }catch (e){
      print(e);
      return false;
    }
  }
  String displayAttendee(){
    final formatter = DateFormat("yyyy-MM-dd HH:MM");
    return ('User Name: $_userName \nUser Email: $_userEmail \nStatus: $_status \nSign In Time: ${formatter.format(_signInTime)}');
  }
}