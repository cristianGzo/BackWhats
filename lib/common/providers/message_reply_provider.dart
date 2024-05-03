import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/common/enums/message_enum.dart';

class MessageReply{
  final String message;
  final bool isMe;
  final MessageEnum;

  MessageReply(this.message, this.isMe, this.MessageEnum);
}

final MessageReplyProvider= StateProvider<MessageReply?>((ref)=>null);