import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sync_communication_app/core/core.dart';
import 'package:sync_communication_app/cubit/cubit.dart';
import 'package:sync_communication_app/data/models/call_tile.dart';
import 'package:sync_communication_app/data/models/user_model.dart';
import 'package:sync_communication_app/features/chats/widgets/custom_message_bubble.dart';
import 'package:sync_communication_app/widgets/gradient_background.dart';
import 'package:sync_communication_app/widgets/user_avatar.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.chatId, required this.otherUser});

  final String chatId;
  final UserModel otherUser;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  String callType = "";

  @override
  void initState() {
    super.initState();
    context.read<MessagesCubit>().openChat(widget.chatId);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showCallError(BuildContext context, String? message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Call Failed'),
        content: Text(message ?? 'Something went wrong, please try again.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'OK',
              style: TextStyle(color: context.scheme.secondary),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userId = context.read<UserCubit>().state.user?.uid;

    return BlocListener<ZegoCubit, ZegoState>(

      listener: (context, state) {
        if (state.status == ZegoStatus.error) {
          _showCallError(context, state.errorMessage);
        } else if (state.status == ZegoStatus.ready) {
          context.read<CallsCubit>().addCall(
            CallTile(
              callType: state.callType ?? CallType.voice,
              recieverId: widget.otherUser.uid,
              senderId: userId ?? "",
              timestamp: DateTime.now(),
            ),
          );
        }
      },
      child: GradientBackground(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          scrolledUnderElevation: 0,
          surfaceTintColor: Colors.transparent,
          backgroundColor: context.scheme.surfaceContainerLow,
          elevation: 0,
          leadingWidth: 30,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          ),
          title: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: UserAvatar(
                        emoji: widget.otherUser.emoji,
                        isOnline: widget.otherUser.online ?? false,
                        padding: 10,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.otherUser.username,
                          style: context.textTheme.headlineMedium,
                        ),
                        if (widget.otherUser.lastSeen != null &&
                            !widget.otherUser.online!)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                            child: Text(
                              "Last seen: ${DateFormat('dd/MM/yyyy  hh:mm a').format(widget.otherUser.lastSeen!)}",
                              style: context.textTheme.bodyMedium!.copyWith(
                                color: context.scheme.onSurface.withValues(
                                  alpha: 0.5,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
                // SizedBox(width: 10),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.videocam_rounded),
                      onPressed: () => context.read<ZegoCubit>().startVideoCall(
                        targetUserId: widget.otherUser.uid,
                        targetUserName: widget.otherUser.username,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.call),
                      onPressed: () async {
                        // LoggerService.logInfo(
                        //   "Initiating voice call with userId: ${widget.otherUser.uid}, userName: ${widget.otherUser.username}",
                        // );
                        await context.read<ZegoCubit>().startVoiceCall(
                          targetUserId: widget.otherUser.uid,
                          targetUserName: widget.otherUser.username,
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: BlocBuilder<MessagesCubit, MessagesState>(
                builder: (context, state) {
                  if (state is MessagesLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is MessagesLoaded) {
                    if (state.messages.isEmpty) {
                      return const SizedBox.shrink();
                    }
                    return ListView.builder(
                      reverse: true,
                      itemCount: state.messages.length,
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: CustomMessageBubble(
                          message: state.messages[index].text,
                          isSender: userId == state.messages[index].senderId,
                          time: state.messages[index].createdAt,
                        ),
                      ),
                    );
                  } else {
                    return const Center(child: Text("Failed to load messages"));
                  }
                },
              ),
            ),
            Container(
              color: context.scheme.surfaceContainerLow,
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: TextField(
                        controller: _controller,
                        cursorColor: context.scheme.primary,
                        decoration: InputDecoration(
                          hintText: "Type a message",
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(12),
                            ),
                            borderSide: BorderSide(
                              color: context.scheme.outline,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(12),
                            ),
                            borderSide: BorderSide(
                              color: context.scheme.outline,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(12),
                            ),
                            borderSide: BorderSide(
                              color: context.scheme.outline,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (_controller.text.trim().isEmpty) return;
                      context.read<MessagesCubit>().sendMessage(
                        text: _controller.text.trim(),
                        userId: userId!,
                      );
                      _controller.clear();
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: ShaderMask(
                        shaderCallback: (bounds) =>
                            context.mainLinearGradient.createShader(bounds),
                        child: const Icon(Icons.send, size: 35,color: Colors.white, ),
                      )
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
