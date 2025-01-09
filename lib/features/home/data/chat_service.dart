import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:livilon/features/home/domain/model/chatmodel.dart';

class ChatService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> sendmessage(String receiverId, String message) async {
    final String currentUserID = firebaseAuth.currentUser!.uid;
    final String currentUserEmail = firebaseAuth.currentUser!.email.toString();
    final Timestamp timeStamp = Timestamp.now();
    MessageModel newMessage = MessageModel(
        senderId: currentUserID,
        senderEmail: currentUserEmail,
        recieverID: receiverId,
        message: message,
        timestamp: timeStamp,
        isDeleted: false);
    List<String> ids = [currentUserID, receiverId];
    ids.sort();
    String chatRoomId = ids.join("_");
    await firestore
        .collection('chatroom')
        .doc(chatRoomId)
        .set({'key': 'value'});
    await firestore
        .collection('chatroom')
        .doc(chatRoomId)
        .collection('messages')
        .add(newMessage.toMap());
  }

  Stream<QuerySnapshot> getMessages(String userId, String otherUserId) {
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join("_");
    return firestore
        .collection('chatroom')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  Future<void> deleteMessage(String receiverID, String messageID) async {
    final String currentUserID = firebaseAuth.currentUser!.uid;

    List<String> ids = [currentUserID, receiverID];
    ids.sort();
    String chatRoomId = ids.join("_");
    DocumentReference messageDocRef = firestore
        .collection('chatroom')
        .doc(chatRoomId)
        .collection('messages')
        .doc(messageID);
    await messageDocRef.update({'isDeleted': true});
    await messageDocRef.delete();
  }

  Stream<QuerySnapshot> getUserChats(String adminId) {
    return firestore
        .collection('chatroom')
        .where('participants', arrayContains: adminId)
        .snapshots();
  }
}
