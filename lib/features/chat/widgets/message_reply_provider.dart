
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:whatsapp_ui/common/providers/message_reply_provider.dart';
import 'package:whatsapp_ui/features/chat/widgets/display_text_image_gift.dart';

class MessageReplyPreview extends ConsumerWidget {
  const MessageReplyPreview({Key? key}) : super(key: key);

  void cancelReply(WidgetRef ref){
    ref.read(MessageReplyProvider.state).update((state) => null);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final MessageReply = ref.watch(MessageReplyProvider);
    return Container(
      width: 350,
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        )
      ),
      child: Column(children: [
        Row(
          children: [
            Expanded(child: Text(MessageReply!.isMe ? 'Me' : 'Opposite',
            style: const TextStyle(
              fontWeight: FontWeight.bold
            ),)),
            GestureDetector(child: const Icon(
              Icons.close,
              size: 16,
            ),
            onTap: () => cancelReply,
            ),
          ],
        ),
        const SizedBox(height: 8,),
        DisplayTextImageGIF(message: MessageReply.message, type: MessageReply.MessageEnum)
      ]),
    );
  }
}