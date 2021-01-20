import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'screenSize.dart';
import 'eventMainPage.dart';
import 'profilePage.dart';
import 'resourcesPage.dart';
import 'chatRoomPage.dart';
import 'notificationPage.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'QRGeneratePage.dart';
import 'user.dart';

class QRPage extends StatefulWidget{
  @override
  _QRPageState createState() => _QRPageState();
}

Future <bool> updateAttendee(String _eventID) async{
  try{
      Firestore.instance.collection('Event').document(_eventID).collection('Attendee').document(User.currentUserEmail).setData(
        {'Name':User.currentUserName, 'SignInTime': DateTime.now(), 'Status': 'Attended'});
      return true;
    }catch (e){
      print(e);
      return false;
    }
}
class _QRPageState extends State<QRPage>{
  int index=0;
  String _scanBarCode;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey <ScaffoldState>();
  Future scanBarcodeNormal() async {
    String barcodeScanRes;
    barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        "#ff6666", "Cancel", true, ScanMode.QR);
    setState(() {
      _scanBarCode = barcodeScanRes;
    });
  }
  @override
  Widget build (BuildContext context){
    SizeConfig().init(context);
    return Scaffold(
      key: _scaffoldKey,
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
            image: new AssetImage("assets/QR.jpg"),
            fit: BoxFit.fill,
          ),
        ),
      child:Center(
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top:SizeConfig.blockSizeVertical * 20),                 
              height : SizeConfig.blockSizeVertical * 8,
              width : SizeConfig.blockSizeHorizontal * 50,
              child: RaisedButton(
                child:Text("Scan QR Code",
                style: TextStyle(fontSize: SizeConfig.blockSizeVertical * 2.3),),
                color:Colors.blue.withOpacity(0.6),
                onPressed: () async {
                  scanBarcodeNormal();
                  if (await updateAttendee(_scanBarCode))
                    _scaffoldKey.currentState.showSnackBar(SnackBar(content:Text('Successfully Update Attendance To Event   ->$_scanBarCode')));
                }
              ),
            ),
            Container(
              margin: EdgeInsets.only(top:SizeConfig.blockSizeVertical * 20),                 
              height : SizeConfig.blockSizeVertical * 8,
              width : SizeConfig.blockSizeHorizontal * 50,
              child: RaisedButton(
                child:Text("Create QR Code",
                style: TextStyle(fontSize: SizeConfig.blockSizeVertical * 2.3),),
                color:Colors.blue.withOpacity(0.6),
                onPressed: () async {
                  Navigator.of(context).push(MaterialPageRoute<Null>(
                    builder: (BuildContext context){
                      return new QRGeneratePage();
                    }));
                }
              ),
            ),
        ],),
      )
      ),
    );
  }
}