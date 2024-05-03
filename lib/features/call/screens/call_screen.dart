import 'package:agora_uikit/agora_uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/common/widgets/loader.dart';
import 'package:whatsapp_ui/config/agora_config.dart';
import 'package:whatsapp_ui/features/call/controller/call_controller.dart';
import 'package:whatsapp_ui/models/call.dart';


class CallScreen extends ConsumerStatefulWidget {
  final String channelId;
  final Call call;
  final bool isGroupChat;

  const CallScreen({
    Key? key,
    required this.channelId,
    required this.call,
    required this.isGroupChat,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CallScreenStateState();
}

class _CallScreenStateState extends ConsumerState<CallScreen> {
  AgoraClient? client;
  String baseUrl= 'https://flutter-twitch-whats.fly.dev/';

  @override
  void initState() {
    super.initState();
  
    client =AgoraClient(
      agoraConnectionData: AgoraConnectionData(appId: AgoraConfig.appId, channelName: widget.channelId, tokenUrl:  baseUrl)
    );
    initAgora();
  }

  void initAgora()async {
    await client!.initialize();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: client == null ? const Loader() : SafeArea(child: Stack(children: [
        AgoraVideoViewer(client: client!),
        AgoraVideoButtons(client: client!, disconnectButtonChild: IconButton(
          onPressed: () async {
            await client!.engine.leaveChannel();
            ref.read(callControllerProvider).endCalls(widget.call.callerId, widget.call.receiverId, context);
            Navigator.pop(context);
          }, icon: const Icon(Icons.call_end),),)
      ],)),
    );
  }
}