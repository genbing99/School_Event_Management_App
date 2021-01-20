import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/attendee.dart';
import 'package:flutter_app/eventAttendeePage.dart';
import 'screenSize.dart';
import 'notificationPage.dart';
import 'profilePage.dart';
import 'resourcesPage.dart';
import 'QRPage.dart';
import 'chatRoomPage.dart';
import 'event.dart';
import 'eventSubgroupPage.dart';
import 'eventMainPage.dart';
import 'feedback.dart';
import 'user.dart';
import 'attendee.dart';

class EventJoinPage extends StatefulWidget{
  final Event _eventClicked;
  EventJoinPage(this._eventClicked);
  @override
  _EventJoinPageState createState() => _EventJoinPageState();
}

class _EventJoinPageState extends State<EventJoinPage>{
  int index=0;
  String _description="";
  Feedback1 _feedbackFirst;
  var _attendeeList = new List<Attendee>();
  var _feedbackList= new List<Feedback1>();
  final formKey = GlobalKey<FormState>();
  @override
  void initState(){
    super.initState();
    getFeedbackList();
    getAttendeeList();
  }
  Future getAttendeeList() async{
    String _userName, _userEmail, _status;
    DateTime _signInTime;
    Firestore.instance.collection('Event').document(widget._eventClicked.getEventID()).collection('Attendee').snapshots().listen((data){
        data.documents.forEach((doc) {
          _userEmail=doc.documentID;
          _userName = doc['Name'];
          _signInTime = doc['SignInTime'].toDate();
          _status=doc['Status'];
          Attendee attendee = new Attendee(widget._eventClicked.getEventID(), _userEmail, _userName, _signInTime, _status);
          if (mounted)
            setState(()=>_attendeeList.add(attendee));
  });});}
  Future getFeedbackList() async{
    String _userName, _description, _userEmail;
    Firestore.instance.collection('Event').document(widget._eventClicked.getEventID()).collection('Feedback').snapshots().listen((data){
        data.documents.forEach((doc) {
          _userName = doc['Name'];
          _description = doc['Description'];
          _userEmail=doc['Email'];
          Feedback1 feedback=new Feedback1(widget._eventClicked.getEventID(), _userEmail, _userName, _description);
          _feedbackList.add(feedback);
          if (mounted)
            setState(()=>_feedbackFirst=_feedbackList[0]);
  });});}
  @override
  Widget build (BuildContext context){
    SizeConfig().init(context);
    return Scaffold(
      appBar: new AppBar(
        iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
        title: new Image.asset('assets/Dream.png',
              fit: BoxFit.cover,
        ),
        backgroundColor: Color(0xFFFFFFFF),
        actions: [
          new IconButton(
            icon: Image.asset('assets/QRScan.png'),
            tooltip: 'QR Code', //Change
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute<Null>(
                            builder: (BuildContext context){
                              return new QRPage();
                            }));
            },
          ),
          new IconButton(
            icon: Image.asset('assets/ChatRoom.png'),
            tooltip: 'Chat Room', //Change
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute<Null>(
                            builder: (BuildContext context){
                              return new ChatRoomPage();
                            }));
            },
          )
        ]
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
          currentIndex: index,
          onTap: (int index) {
            switch (index){
            case 0:  Navigator.of(context).push(MaterialPageRoute<Null>(
                            builder: (BuildContext context){
                              return new EventMainPage();//Change
                            }));
                    break;
            case 1:  Navigator.of(context).push(MaterialPageRoute<Null>(
                            builder: (BuildContext context){
                              return new NotificationPage();//Change
                            }));
                    break;
            case 2:  Navigator.of(context).push(MaterialPageRoute<Null>(
                            builder: (BuildContext context){
                              return new ResourcesPage();//Change
                            }));
                    break;
            case 3: Navigator.of(context).push(MaterialPageRoute<Null>(
                            builder: (BuildContext context){
                              return new ProfilePage1();//Change
                            }));
                    break;
            }
          },
        items:[
          BottomNavigationBarItem(
           icon: Image.asset('assets/Event.png', width: SizeConfig.blockSizeVertical * 6, height:SizeConfig.blockSizeVertical * 6),
           title: new Text('Event'),
         ),
         BottomNavigationBarItem(
           icon: Image.asset('assets/Notification.png', width: SizeConfig.blockSizeVertical * 6, height:SizeConfig.blockSizeVertical * 6),
           title: new Text('Notification'),
         ),
         BottomNavigationBarItem(
           icon: Image.asset('assets/Resources.png', width: SizeConfig.blockSizeVertical * 6, height:SizeConfig.blockSizeVertical * 6),
           title: new Text('Resource'),
         ),
         BottomNavigationBarItem(
           icon: Image.asset('assets/Profile.png', width: SizeConfig.blockSizeVertical * 6, height:SizeConfig.blockSizeVertical * 6),
           title: new Text('Profile'),
         ),
         
        ]
      ),
      body:Container(
        height : SizeConfig.blockSizeVertical * 100,
        width : SizeConfig.blockSizeHorizontal * 100,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: new AssetImage("assets/Event.jpg"),
            fit: BoxFit.fill,
          ),
        ),
      child: Center(
        child:Form(
        key:formKey,
        child: ListView(
          children:<Widget>[
            new Column(
              children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 2), 
                    height : SizeConfig.blockSizeVertical * 7,
                    width : SizeConfig.blockSizeHorizontal * 60,
                    child:Text(
                      'Event Details',
                      style: TextStyle(fontSize: SizeConfig.blockSizeVertical * 4, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    height : SizeConfig.blockSizeVertical * 27,
                    width : SizeConfig.blockSizeHorizontal * 80,
                    decoration: BoxDecoration(
                      borderRadius: new BorderRadius.only(
                            topLeft:  const  Radius.circular(40.0),
                            topRight: const  Radius.circular(40.0),
                            bottomLeft: const  Radius.circular(40.0),
                            bottomRight: const  Radius.circular(40.0)),
                      color: Colors.grey.withOpacity(0.2),
                      border: Border.all(color: Colors.black)),
                    child:Column(
                      children: <Widget>[
                        Container(
                          child:Text(
                            widget._eventClicked.displayEvent(widget._eventClicked),
                            style: TextStyle(fontSize: SizeConfig.blockSizeVertical * 2.0),
                            textAlign: TextAlign.center,
                          )
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              height : SizeConfig.blockSizeVertical * 3,
                              width : SizeConfig.blockSizeHorizontal * 40,
                              child:Text(
                                'Total Attendee: ${_attendeeList.length}',
                                style: TextStyle(fontSize: SizeConfig.blockSizeVertical * 2.0),
                                textAlign: TextAlign.right,
                              )
                            ),
                            Container(
                              height : SizeConfig.blockSizeVertical * 3,
                              width : SizeConfig.blockSizeHorizontal * 30,
                              child: FlatButton.icon(
                                label:Text('List'), //Change assets
                                icon: Image.asset('assets/Search.png', width: SizeConfig.blockSizeVertical * 2, height:SizeConfig.blockSizeVertical * 2),
                                onPressed:() {
                                  Navigator.of(context).push(MaterialPageRoute<Null>(
                                  builder: (BuildContext context){
                                    return new EventAttendeePage(_attendeeList);//Change
                                  }));
                                },
                                
                                )
                            ),
                        ],)
                      ]
                      
                    ),
                  ),
                  Container(                
                    height : SizeConfig.blockSizeVertical * 6,
                    width : SizeConfig.blockSizeHorizontal * 25,
                    margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 1),
                    child: RaisedButton(
                      child:Text("JOIN",
                      style: TextStyle(fontSize: SizeConfig.blockSizeVertical * 3, fontWeight: FontWeight.bold),
                      ),
                      color:Colors.blue.withOpacity(0.5),
                      onPressed: () {
                        Attendee attendee = new Attendee(widget._eventClicked.getEventID(), User.currentUserEmail, User.currentUserName, DateTime.now(), 'Interested');
                        attendee.storeAttedeee();
                        if (widget._eventClicked.getMaxSubgroup()>0){
                          Navigator.of(context).push(MaterialPageRoute<Null>(
                            builder: (BuildContext context){
                              return new EventSubgroupPage(widget._eventClicked);
                            }));
                        }
                        else{
                          Navigator.of(context).push(MaterialPageRoute<Null>(
                            builder: (BuildContext context){
                              return new EventMainPage();
                            }));
                        }
                      },
                      ),
                  ),
                  Container(
                    height : SizeConfig.blockSizeVertical * 30,
                    width : SizeConfig.blockSizeHorizontal * 80,
                    margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 1),
                    decoration: BoxDecoration(
                      borderRadius: new BorderRadius.only(
                            topLeft:  const  Radius.circular(40.0),
                            topRight: const  Radius.circular(40.0),
                            bottomLeft: const  Radius.circular(40.0),
                            bottomRight: const  Radius.circular(40.0)),
                      color: Colors.grey.withOpacity(0.2),
                      border: Border.all(color: Colors.black)),
                    child: new Column(
                      children: <Widget>[
                        Container(
                          height : SizeConfig.blockSizeVertical * 3,
                          width : SizeConfig.blockSizeHorizontal * 60,
                          child:Text(
                            'Comment & Feedback', 
                            style: TextStyle(fontSize: SizeConfig.blockSizeVertical * 2.5, color: Colors.blue[700]),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        ConditionalBuilder(
                          condition: (_feedbackFirst!=null),
                          builder: (context){
                            return Container(
                              height : SizeConfig.blockSizeVertical * 18,
                              width : SizeConfig.blockSizeHorizontal * 70,
                              child: ListView.builder(
                                itemCount:_feedbackList.length,
                                itemBuilder: (context, i) {
                                  return ListTile(
                                    title: new Container(
                                      child:Column(
                                        children: <Widget>[
                                          Container(
                                            height : SizeConfig.blockSizeVertical * 3,
                                            width : SizeConfig.blockSizeHorizontal * 65,
                                            child: Text(
                                            '${_feedbackList[i].getName()}: ',
                                            textAlign: TextAlign.left,
                                            )
                                          ),
                                          Container(
                                            height : SizeConfig.blockSizeVertical * 3,
                                            width : SizeConfig.blockSizeHorizontal * 65,
                                            decoration: BoxDecoration(
                                              border: Border.all(color: Colors.black),
                                              color: Colors.white,
                                            ),
                                            child: Text(
                                              '${_feedbackList[i].getDescription()}'
                                            ),
                                          ),
                                      ],)
                                    ),
                                  );
                                }
                              ),
                            );
                          }
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              height : SizeConfig.blockSizeVertical * 4,
                              width : SizeConfig.blockSizeHorizontal * 60,
                              margin: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 1, top: SizeConfig.blockSizeVertical * 1),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                                color: Colors.white,
                              ),
                              child: TextFormField(
                              decoration: InputDecoration(labelText: ''),
                              onSaved: (val) => _description = val
                              ),
                            ),
                            Spacer(),
                            Container(                
                              height : SizeConfig.blockSizeVertical * 5,
                              width : SizeConfig.blockSizeHorizontal * 18,
                              margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 1),
                              child: RaisedButton(
                                shape: new CircleBorder(),
                                child:Text("SEND",
                                style: TextStyle(fontSize: SizeConfig.blockSizeVertical * 1.6, fontWeight: FontWeight.bold),
                                ),
                                color:Colors.green.withOpacity(0.7),
                                onPressed: () async {
                                  if (formKey.currentState.validate()){
                                    formKey.currentState.save();
                                    Feedback1 feedback = new Feedback1(widget._eventClicked.getEventID(), User.currentUserEmail, User.currentUserName, _description);
                                    feedback.storeFeedback();
                                    setState(()=>_feedbackList.add(feedback));
                                    _feedbackList.clear(); //Weird, but worked
                                    formKey.currentState.reset();
                                  }
                                },
                                ),
                            ),
                          ]
                        ),
                      ],
                    ),
                  ),
              ],
            )
          ]
        )
      )
    )));
  }
}

