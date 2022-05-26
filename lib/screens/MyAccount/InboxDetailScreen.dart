import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hbk/models/MessageDetails.dart';
import 'package:hbk/providers/MessageProvider.dart';
import 'package:hbk/providers/UserProvider.dart';
import 'package:hbk/screens/MyAccount/InboxScreen.dart';
import 'package:hbk/widget_controllers/MyProgressWithMsg.dart';
import 'package:provider/provider.dart';

class InboxDetailScreen extends StatefulWidget {
  static const routeName = "/inbox-detail";
  @override
  _InboxDetailScreenState createState() => _InboxDetailScreenState();
}

class _InboxDetailScreenState extends State<InboxDetailScreen> {
  List<MessageDetails> messagesList = new List();
  bool _loadedInitData = false;
  bool _loading = false;
  int id;
  String subject;
  String message;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (!_loadedInitData) {
      setState(() {
        _loading = true;
      });

      String token = Provider.of<UserProvider>(context).token;
      final args =
          ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
      id = args['id'];
      subject = args['subject'];
      message = args['message'];

      messagesList =
          await Provider.of<MessageProvider>(context).getMessageDetail(args['id'], token);

      Provider.of<MessageProvider>(context, listen: false).markedAsRead(args['id']);

      // print(messagesList[0].value);
      setState(() {
        _loading = false;
      });

      _loadedInitData = true;
    }
  }


  String text;
  TextEditingController _controller;
  final List<String> avatars = [
    'assets/img/user.jpg',
    'assets/img/user.jpg',
  ];
  final List<MessagedDetailsTemp> messages = [
    MessagedDetailsTemp(0, "But I may not go if the weather is bad."),
    MessagedDetailsTemp(0, "I suppose I am."),
    MessagedDetailsTemp(1, "Are you going to market today?"),
    MessagedDetailsTemp(0, "I am good too"),
    MessagedDetailsTemp(1, "I am fine, thank you. How are you?"),
    MessagedDetailsTemp(1, "Hi,"),
    MessagedDetailsTemp(0, "How are you today?"),
    MessagedDetailsTemp(0, "Hello,"),
  ];
  final rand = Random();

   @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(subject),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.delete,
              color: Colors.white,
            ),
            onPressed: () {
              showAlertDialog(context, deleteQuote);
            },
          )
        ],
      ),
      body:  _loading
              ? Container(
                  padding: EdgeInsets.only(top: 20),
                  child: MyProgressWithMsg(
                    msg: 'Loading...',
                  ),
                )
              : Column(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                margin: EdgeInsets.all(7),
                color: Theme.of(context).primaryColor,
                clipBehavior: Clip.antiAlias,
                child:
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                      child: Text(message, 
                        style:  TextStyle(fontSize: 24.0, fontWeight: FontWeight.w600, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                  ),
              ),
            ],
          ),
          Expanded(
            child: ListView.separated(
              physics: BouncingScrollPhysics(),
              separatorBuilder: (context, index) {
                return const SizedBox(height: 10.0);
              },
              reverse: true,
              itemCount: messagesList.length,
              itemBuilder: (BuildContext context, int index) {
                MessageDetails m = messagesList[index];
                if (m.createdBy == 'user') return _buildMessageRow(m, current: true);
                return _buildMessageRow(m, current: false);
              },
            ),
          ),
          _buildBottomBar(context),
        ],
      ),
    );
  }
Container _buildBottomBar(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: 8.0,
      ),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(30.0),
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: 8.0,
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              textInputAction: TextInputAction.send,
              controller: _controller,
              decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 10.0,
                    horizontal: 20.0,
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  hintText: "Type a message..."),
              onEditingComplete: _save,
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            color: Theme.of(context).primaryColor,
            onPressed: _save,
          )
        ],
      ),
    );
  }

  _save() async {
    if (_controller.text.isEmpty) return;
    FocusScope.of(context).requestFocus(FocusNode());

    String msg = _controller.text;

    setState(() {
      messagesList.insert(0, MessageDetails(
        id:id.toString(),
        entryId: "",
        username:"",
        userId: "",
        dateCreated: "",
        value: _controller.text,
        noteType: "",
        createdBy: "user",
      ));
      _controller.clear();
    });

    String token = Provider.of<UserProvider>(context, listen: false).token;
    bool send = await Provider.of<MessageProvider>(context, listen: false).sendMessage(token,id.toString(),msg);

  }

  Row _buildMessageRow(MessageDetails message, {bool current}) {
    return Row(
      mainAxisAlignment:
          current ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment:
          current ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(width: current ? 30.0 : 20.0),
        // if (!current) ...[
        //   CircleAvatar(
        //     backgroundImage: NetworkImage(
        //       current ? avatars[0] : avatars[1],
        //     ),
        //     radius: 20.0,
        //   ),
        //   const SizedBox(width: 5.0),
        // ],
        Container(
          width: 250,
          padding: const EdgeInsets.symmetric(
            vertical: 8.0,
            horizontal: 16.0,
          ),
          decoration: BoxDecoration(
              color: current ? Theme.of(context).primaryColor : Colors.white,
              borderRadius: BorderRadius.circular(10.0)),
          child: Text(
            message.value,
            style: TextStyle(
                color: current ? Colors.white : Colors.black, fontSize: 18.0),
          ),
        ),
        // if (current) ...[
        //   const SizedBox(width: 5.0),
        //   CircleAvatar(
        //     backgroundImage: NetworkImage(
        //       current ? avatars[0] : avatars[1],
        //     ),
        //     radius: 10.0,
        //   ),
        // ],
        SizedBox(width: current ? 20.0 : 30.0),
      ],
    );
  }

  deleteQuote() async {
    String token = Provider.of<UserProvider>(context, listen: false).token;
    print(token);
    bool deleteData =
        await Provider.of<MessageProvider>(context, listen: false)
            .deleteData(
      id.toString(),
      token,
    );

    if (deleteData) {
      // Navigator.pushNamed(context, InboxScreen.routeName);
      // Navigator.pushNamedAndRemoveUntil(context, InboxScreen.routeName, (r) => false);
      Navigator.of(context).pop();
    }
  }

  showAlertDialog(BuildContext context, Function deleteQuote) {
  // set up the buttons
  Widget cancelButton = FlatButton(
    child: Text("Cancel"),
    onPressed: () {
      Navigator.of(context).pop(); // dismiss dialog
    },
  );
  Widget continueButton = FlatButton(
    child: Text("Delete"),
    onPressed: () {
      Navigator.of(context).pop(); // dismiss dialog
      deleteQuote();
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Delete Confirmation?"),
    content: Text("Would you like to delete the Item "),
    actions: [
      cancelButton,
      continueButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}



}


class MessagedDetailsTemp {
  final int user;
  final String description;

  MessagedDetailsTemp(this.user, this.description);
}