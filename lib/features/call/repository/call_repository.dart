import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp_ui/common/repositories/common_firebase_storage_repository.dart';
import 'package:whatsapp_ui/common/utils/utils.dart';
import 'package:whatsapp_ui/features/call/screens/call_screen.dart';
import 'package:whatsapp_ui/features/group/repository/group_repository.dart';
import 'package:whatsapp_ui/models/call.dart';
import 'package:whatsapp_ui/models/group.dart' as model;

final CallRepositoryProvider= Provider((ref) => CallRepository(firestore: FirebaseFirestore.instance, auth: FirebaseAuth.instance));

class CallRepository{
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  CallRepository({
    required this.firestore,
    required this.auth,
  });

  Stream<DocumentSnapshot> get callStream=> firestore.collection('call').doc(auth.currentUser!.uid).snapshots();

  void makeCalls(Call senderCallData, BuildContext context, Call receiverCallData) async{
    try{
      await firestore.collection('call').doc(senderCallData.callerId).set(senderCallData.toMap());
      await firestore.collection('call').doc(senderCallData.receiverId).set(receiverCallData.toMap());

      Navigator.push(context, MaterialPageRoute(builder: (context) => CallScreen(channelId: senderCallData.callId, call: senderCallData, isGroupChat: false)
      ));
    }catch(e){
      showSnackBar(context: context, content: e.toString());
    }
  }

  void endCalls(String callerId, String receiverId, BuildContext context) async{
    try{
      await firestore.collection('call').doc(callerId).delete();
      await firestore.collection('call').doc(receiverId).delete();
      
      
    }catch(e){
      showSnackBar(context: context, content: e.toString());
    }
  }
}