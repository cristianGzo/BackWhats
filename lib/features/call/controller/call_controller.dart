import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp_ui/features/auth/controller/auth_controller.dart';
import 'package:whatsapp_ui/features/call/repository/call_repository.dart';
import 'package:whatsapp_ui/features/chat/repositories/chat_repository.dart';
import 'package:whatsapp_ui/features/group/repository/group_repository.dart';
import 'package:whatsapp_ui/models/call.dart';

final callControllerProvider=Provider((ref){
  final callRepository= ref.read(CallRepositoryProvider);
  return CallController(callRepository: callRepository, auth: FirebaseAuth.instance, ref: ref);
});

class CallController{
  final CallRepository callRepository;
  final ProviderRef ref;
  final FirebaseAuth auth;

  CallController({required this.callRepository, 
  required this.ref, required this.auth});

  Stream<DocumentSnapshot> get callStream=> callRepository.callStream;

  void makeCall(BuildContext context, String receiverName, String receiverUid, String receiverProfilePic, bool isGroupChat){
    ref.read(userDataAuthProvider).whenData((value) {
      String callId = const Uuid().v1();
      Call senderCallData = Call(callerId: auth.currentUser!.uid, callerName: value!.name, callerPic: value.profilePic, receiverId: receiverUid, receiverName: receiverName, receiverPic: receiverProfilePic, callId: callId, hasDialled: true);

      Call recieverCallData = Call(callerId: auth.currentUser!.uid, callerName: value.name, callerPic: value.profilePic, receiverId: receiverUid, receiverName: receiverName, receiverPic: receiverProfilePic, callId: callId, hasDialled: false);

      callRepository.makeCalls(senderCallData, context, recieverCallData);
    });
  }

  void endCalls(String callerId, String receiverId, BuildContext context){
    callRepository.endCalls(callerId, receiverId, context);
  }
}