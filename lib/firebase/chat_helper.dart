import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_diary/models/chat.dart';

class ChatHelper {
  static const collectionName = 'Chats';

  final _firestore = FirebaseFirestore.instance;

  sendMessage(Chat? chat) async {
    var response = {};
    await _firestore
        .collection(collectionName)
        .doc(chat?.id)
        .set(chat!.toMap())
        .then((value) {
      response['error'] = 0;
    }).catchError(
      (err) {
        response['error'] = 1;
        response['message'] = err.toString();
      },
    );
    return response;
  }

  readMessages(myId, otherId) async {
    List<Chat> chatData = [];

    await _firestore
        .collection(collectionName)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .listen((e) {
      chatData.clear();

      for (int i = 0; i < e.docs.length; i++) {
        Chat chat = Chat().fromMap(e.docs[i].data());
        if ((chat.senderId == myId && chat.receiverId == otherId) ||
            (chat.senderId == otherId && chat.receiverId == myId))
          chatData.add(chat);
      }

    });

    return await chatData;
  }
}
