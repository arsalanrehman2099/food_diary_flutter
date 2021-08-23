import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_diary/firebase/chat_helper.dart';
import 'package:food_diary/firebase/user_helper.dart';
import 'package:food_diary/models/chat.dart';
import 'package:food_diary/screens/dashboard/user_profile_screen.dart';
import 'package:food_diary/utils/constant_manager.dart';
import 'package:food_diary/utils/size_config.dart';
import 'package:food_diary/widgets/center_loader.dart';
import 'package:food_diary/widgets/my_chat_item.dart';
import 'package:food_diary/widgets/other_chat_item.dart';
import 'package:food_diary/widgets/profile_image.dart';

class ChatScreen extends StatefulWidget {
  final other_id;
  final other_name;
  final other_img;

  ChatScreen({this.other_id, this.other_name, this.other_img});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController tMessage = TextEditingController();

  var chats = [];

  bool _loading = false;

  Timer? timer;

  @override
  void initState() {
    _readMessages();
  }

  _sendMessage() async {
    if (tMessage.text != "") {
      Chat chat = Chat(
        id: ConstantManager.generateRandomString(20),
        senderId: UserHelper().myId(),
        receiverId: widget.other_id,
        message: tMessage.text,
        type: 'text',
        timestamp: Timestamp.now(),
      );

      final response = await ChatHelper().sendMessage(chat);
      setState(() => tMessage.text = "");
      if (response['error'] == 1) {
        ConstantManager.showtoast(response['message'].toString());
      }
    }
  }

  _readMessages() async {
    setState(() => _loading = true);
    chats =
        await ChatHelper().readMessages(UserHelper().myId(), widget.other_id);

    timer = Timer.periodic(Duration(seconds: 2), (Timer t) {
      setState(() {
        if (chats != []) {
          _loading = false;
          timer?.cancel();
        }
      });
      // if (chats != [])
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _loading
          ? CenterLoader()
          : Column(
              children: [
                MessageList(),
                MessageBox(),
              ],
            ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      centerTitle: true,
      backgroundColor: ConstantManager.secondaryClr,
      title: Text(widget.other_name, style: ConstantManager.htextStyle),
      actions: [
        GestureDetector(
          onTap: () {
            ConstantManager.screenNavigation(
                context, UserProfileScreen(widget.other_id));
          },
          child: Container(
            margin:
                EdgeInsets.only(right: SizeConfig.blockSizeHorizontal * 3.0),
            child: Center(
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    padding: const EdgeInsets.all(1.0),
                    child: ProfileImage(
                      image: widget.other_img,
                      size: SizeConfig.blockSizeVertical * 2.2,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      backgroundColor: Colors.green,
                      radius: 5.0,
                    ),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget MessageList() {
    return Expanded(
      child: ListView.separated(
        shrinkWrap: true,
        reverse: true,
        itemCount: chats.length,
        separatorBuilder: (_, i) =>
            SizedBox(height: SizeConfig.safeBlockVertical),
        itemBuilder: (ctx, i) {
          return chats[i].senderId == UserHelper().myId()
              ? MyChatItem(
                  message: chats[i].message,
                  dateTime: chats[i].timestamp,
                )
              : OtherChatItem(
                  message: chats[i].message,
                  dateTime: chats[i].timestamp,
                  name: widget.other_name,
                  imgUrl: widget.other_img,
                );
        },
      ),
    );
  }

  Widget MessageBox() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(100.0)),
      margin: EdgeInsets.symmetric(
        horizontal: SizeConfig.blockSizeHorizontal * 2.2,
        vertical: SizeConfig.blockSizeVertical * 1.5,
      ),
      padding: EdgeInsets.only(
        left: SizeConfig.blockSizeHorizontal * 4.5,
        right: SizeConfig.blockSizeHorizontal * 2.0,
        top: SizeConfig.blockSizeVertical / 2.0,
        bottom: SizeConfig.blockSizeVertical / 2.0,
      ),
      child: Row(
        children: [
          Flexible(
            child: TextField(
              controller: tMessage,
              cursorColor: Colors.grey,
              keyboardType: TextInputType.multiline,
              maxLines: 4,
              minLines: 1,
              decoration: new InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  hintText: "Type a message..."),
            ),
          ),
          GestureDetector(
            onTap: () {
              print('Attachment');
            },
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              child: Icon(Icons.attach_file, color: Colors.grey),
            ),
          ),
          SizedBox(width: SizeConfig.blockSizeHorizontal),
          GestureDetector(
            onTap: _sendMessage,
            child: CircleAvatar(
              backgroundColor: ConstantManager.secondaryClr,
              child: Icon(Icons.send, color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}
