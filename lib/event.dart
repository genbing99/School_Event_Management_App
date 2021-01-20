import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Event{
  String _eventID, _name, _type, _description, _teamID, _image;
  DateTime _startTime, _endTime;
  int _maxSubgroup, _maxSubgroupMember;
  double _fees;
  Event.empty(int empty);
  Event(this._eventID, this._name, this._startTime, this._endTime, this._fees, this._type, this._description, this._teamID, this._image, this._maxSubgroup, this._maxSubgroupMember);
  
  
  Future <bool> storeEvent() async{
    try{
      Firestore.instance.collection('Event').document(_eventID).setData(
          {
            'ID':this._eventID, 
            'Name':this._name, 
            'StartTime':this._startTime, 
            'EndTime':this._endTime,
            'Fees':this._fees, 
            'Type':this._type, 
            'Description':this._description, 
            'TeamID':this._teamID, 
            'Image':this._image,
            'Max Subgroup': this._maxSubgroup, 
            'MaxSubgroupMember':this._maxSubgroupMember
          }
        );
      return true;
    }catch (e){
      return false;
    }
  }

  
  void setEventID(String eventID){
    this._eventID=eventID;
  }
  void setName(String name){
    this._name=name;
  }
  void setStartTime(DateTime startTime){
    this._startTime=startTime;
  }
  void setEndTime(DateTime endTime){
    this._endTime=endTime;
  } 
  void setFees(double fees){
    this._fees=fees;
  }
  void setType(String type){
    this._type=type;
  }
  void setDescription(String description){
    this._description=description;
  }
  void setTeamID(String teamID){
    this._teamID=teamID;
  }
  void setImage(String image){
    this._image=image;
  }
  void setMaxSubgroup(int maxSubgroup){
    this._maxSubgroup=maxSubgroup;
  }
  void setMaxSubgroupMember(int maxSubgroupMember){
    this._maxSubgroupMember=maxSubgroupMember;
  }
  String getEventID(){
    return _eventID;
  }
  String getName(){
    return _name;
  }
  DateTime getStartTime(){
    return _startTime;
  }
  DateTime getEndTime(){
    return _endTime;
  } 
  double getFees(){
    return _fees;
  }
  String getType(){
    return _type;
  }
  String getDescription(){
    return _description;
  }
  String getTeamID(){
    return _teamID;
  }
  int getMaxSubgroup(){
    return _maxSubgroup;
  }
  int getMaxSubgroupMember(){
    return _maxSubgroupMember;
  }
  String getImage(){
    return this._image;
  }
  String displayEvent(Event event){
    final formatter = DateFormat("yyyy-MM-dd HH:MM");
    return 'Name: ${event._name} \n Description ${event._description} \n Time: ${formatter.format(event._startTime)} -\n ${formatter.format(event._endTime)}\n Fees: ${event._fees} \n Event ID: ${event._eventID} \n Organizer Team ID: ${event._teamID}';
  }
  String displayManageList(){
    final formatter = DateFormat("yyyy-MM-dd HH:MM");
    return ' Event ID: $_eventID \n Name: $_name \n Time: ${formatter.format(_startTime)} -\n ${formatter.format(_endTime)}\n Fees: $_fees \n Team ID: $_teamID';
  }
  Future <bool> deleteEvent() async{
    try{
      Firestore.instance.collection('Event').document(_eventID).delete();
      Firestore.instance.collection('Event').document(_eventID).collection('Team').getDocuments().then((snapshot) {
        for (DocumentSnapshot doc in snapshot.documents) {
          doc.reference.delete();
      }});
      Firestore.instance.collection('Event').document(_eventID).collection('Attendee').getDocuments().then((snapshot) {
        for (DocumentSnapshot doc in snapshot.documents) {
          doc.reference.delete();
      }});
      Firestore.instance.collection('Event').document(_eventID).collection('Feedback').getDocuments().then((snapshot) {
        for (DocumentSnapshot doc in snapshot.documents) {
          doc.reference.delete();
      }});
      
      return true;
    }catch (e){
      print(e);
      return false;
    }
  }
}