import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hbk/models/User.dart';
import 'package:hbk/providers/MessageProvider.dart';
import 'package:hbk/providers/RequestQuoteProvider.dart';
import 'package:hbk/providers/UserProvider.dart';
import 'package:hbk/screens/MyAccount/InboxDetailScreen.dart';
import 'package:hbk/screens/NotificationViewScreen.dart';
import 'package:hbk/widgets/myDrawerWidget.dart';
import 'package:hbk/widgets/myDrawerWidgetNew.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

//
import '../widgets/myAppBar.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = "/home";

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _autoLoggedIn = false;

  String videoURL = "https://www.youtube.com/watch?v=GUj4PRvEKsI";
  // String videoURL = "https://www.youtube.com/watch?v=P5efihG6Qq0&t=3s";
  YoutubePlayerController _controller;
  
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  String _message = '';

  @override
  void initState() {
    _controller = YoutubePlayerController(
          initialVideoId: YoutubePlayer.convertUrlToId(videoURL),
          flags: YoutubePlayerFlags(autoPlay: false),
        );
    _registerOnFirebase();
    getMessage();
    super.initState();
  }

  @override
  didChangeDependencies() async {
    super.didChangeDependencies();
    if (!_autoLoggedIn) {
      await Provider.of<UserProvider>(context, listen: false).autoLogin();
      _autoLoggedIn = true;
      String token = Provider.of<UserProvider>(context, listen: false).token;
      Provider.of<MessageProvider>(context, listen: false).getUnReadMessageCount(token);
    }
  }

  void getMessage() {
    _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
      print('received message');
      // _navigateToItemDetail(message["data"]["screen"]);
      print(message["data"]["screen"]);
      setState(() => _message = message["notification"]["body"]);
    }, onResume: (Map<String, dynamic> message) async {
      print('on resume $message');
      _navigateToItemDetail(message);
      setState(() => _message = message["notification"]["body"]);
    }, onLaunch: (Map<String, dynamic> message) async {
      print('on launch $message');
      _navigateToItemDetail(message);
      setState(() => _message = message["notification"]["body"]);
    });
  }
  _registerOnFirebase() {
    _firebaseMessaging.subscribeToTopic('all');
    // _firebaseMessaging.getToken().then((token) => print(token));
    _firebaseMessaging.getToken().then((String token) async {
      assert(token != null);
      print('fb token ::'+token);
      
      String tok = await Provider.of<UserProvider>(context, listen: false).getFirebaseToken();
      print('tok :'+tok);
    });
  }
  _navigateToItemDetail(Map<String, dynamic> message) async {
    String routeName = message["data"]["screen"];
    String id =  message["data"]["id"];

    print(routeName);
    if(routeName == NotificationViewScreen.routeName){
      await Navigator.pushNamed(context, routeName,
          arguments: {
            'id': id,
          });
    }
    // if(routeName == InboxDetailScreen.routeName){
    //   String subject =  message["data"]["subject"];
    //   String msg =  message["data"]["message"];
    //   await Navigator.pushNamed(context, routeName,
    //       arguments: {
    //         'id': id,
    //         'subject': subject,
    //         'message': msg,
    //       });
    // }
    else{
      await Navigator.pushReplacementNamed(context, routeName);
    }
    
    // _navKey.currentState.popUntil((r) => r.isFirst);
    // _navKey.currentState.pushNamed(routeName);
  }

  @override
  Widget build(BuildContext context) {
    User loggedInUser = Provider.of<UserProvider>(context).loggedInUser;
    if(loggedInUser !=null) {
      String token = Provider.of<UserProvider>(context).token;
      Provider.of<MessageProvider>(context).getUnReadMessageCount(token);
      Provider.of<RequestQuoteProvider>(context).getUnreadQuateCount(token);
    }

    return Scaffold(
      appBar: myAppBar(),
      drawer: LightDrawerPage(),
      body: ListView(
        padding: EdgeInsets.fromLTRB(20, 30, 20, 20),
        children: <Widget>[
          Text(
            'Welcome',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 20.0,
          ),
          YoutubePlayer(
            controller: _controller,
            showVideoProgressIndicator: true,
          ),
          SizedBox(
            height: 40.0,
          ),
          Text(
            'WITH US EVERYTHING IS STRAIGHT FORWARD.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            'You take care of the easy part, we take care of the hard part. As simple as that.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15),
          ),
          SizedBox(
            height: 20.0,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(25.0),
            child: Image.asset('assets/img/home1.png'),
          ),
          // Image.network(
          //   'https://hbkglobaltrading.com/wp-content/uploads/2016/06/CHINA-ONLY-hbk-shipping-process_7-500x194_2a.png',
          //   fit: BoxFit.cover,
          //   loadingBuilder: (BuildContext context, Widget child,
          //       ImageChunkEvent loadingProgress) {
          //     if (loadingProgress == null) return child;
          //     return Center(
          //       child: CircularProgressIndicator(
          //         value: loadingProgress.expectedTotalBytes != null
          //             ? loadingProgress.cumulativeBytesLoaded /
          //                 loadingProgress.expectedTotalBytes
          //             : null,
          //       ),
          //     );
          //   },
          // ),
          SizedBox(
            height: 20.0,
          ),
          Text(
            'We go the extra mile by taking care of all your requirements. No need to worry about',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 30.0,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(25.0),
            child: Image.asset('assets/img/home2.png'),
          ),
          // Image.network(
          //   'https://www.hbkglobaltrading.com/wp-content/uploads/2016/08/no-worries2-2.png',
          //   fit: BoxFit.cover,
          //   loadingBuilder: (BuildContext context, Widget child,
          //       ImageChunkEvent loadingProgress) {
          //     if (loadingProgress == null) return child;
          //     return Center(
          //       child: CircularProgressIndicator(
          //         value: loadingProgress.expectedTotalBytes != null
          //             ? loadingProgress.cumulativeBytesLoaded /
          //                 loadingProgress.expectedTotalBytes
          //             : null,
          //       ),
          //     );
          //   },
          // ),
        ],
      ),
    );
  }
}
