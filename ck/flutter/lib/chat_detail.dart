import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'addfriend.dart';

class ChatDetailScreen extends StatefulWidget {
  final String name;
  final String avatar;

  const ChatDetailScreen({
    super.key,
    required this.name,
    required this.avatar,
  });

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {

  bool isRecording = false;

  final TextEditingController messageController = TextEditingController();

  /// gửi tin nhắn lên firebase
  void sendMessage() {

    if (messageController.text.trim().isEmpty) return;

    FirebaseFirestore.instance.collection("messages").add({
      "text": messageController.text,
      "sender": "me",
      "time": FieldValue.serverTimestamp(),
    });

    messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(widget.avatar),
            ),
            const SizedBox(width: 10),
            Text(
              widget.name,
              style: const TextStyle(color: Colors.black),
            )
          ],
        ),

        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddFriendScreen(),
                ),
              );
            },
          )
        ],
      ),

      body: Column(
        children: [

          /// CHAT LIST FROM FIREBASE
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("messages")
                  .orderBy("time")
                  .snapshots(),

              builder: (context, snapshot) {

                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                var messages = snapshot.data!.docs;

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: messages.length,

                  itemBuilder: (context, index) {

                    var msg = messages[index];
                    bool isMe = msg["sender"] == "me";

                    return Align(
                      alignment: isMe
                          ? Alignment.centerRight
                          : Alignment.centerLeft,

                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        padding: const EdgeInsets.all(12),
                        constraints: const BoxConstraints(maxWidth: 250),

                        decoration: BoxDecoration(
                          color: isMe
                              ? const Color(0xFF00C6A7)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(14),
                        ),

                        child: Text(
                          msg["text"],
                          style: TextStyle(
                            color: isMe
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          /// INPUT / VOICE
          isRecording ? _voiceRecorder() : _chatInput(),
        ],
      ),
    );
  }

  /// NORMAL CHAT INPUT
  Widget _chatInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      color: Colors.white,

      child: SafeArea(
        child: Row(
          children: [

            IconButton(
              icon: const Icon(Icons.mic, color: Colors.grey),
              onPressed: () {
                setState(() {
                  isRecording = true;
                });
              },
            ),

            const SizedBox(width: 10),

            const Icon(Icons.image, color: Colors.grey),

            const SizedBox(width: 10),

            Expanded(
              child: TextField(
                controller: messageController,
                decoration: InputDecoration(
                  hintText: "Type message",
                  filled: true,
                  fillColor: const Color(0xfff2f2f2),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 10),

            GestureDetector(
              onTap: sendMessage,

              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFF00C6A7),
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(10),

                child: const Icon(
                  Icons.send,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  /// VOICE RECORDER UI
  Widget _voiceRecorder() {
    return Container(
      height: 120,
      color: Colors.white,

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          const Text(
            "0:12",
            style: TextStyle(color: Colors.grey),
          ),

          const SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [

              IconButton(
                icon: const Icon(Icons.close, size: 30),
                onPressed: () {
                  setState(() {
                    isRecording = false;
                  });
                },
              ),

              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF00C6A7),
                    width: 3,
                  ),
                ),
                child: const Icon(
                  Icons.mic,
                  color: Color(0xFF00C6A7),
                  size: 30,
                ),
              ),

              Container(
                decoration: const BoxDecoration(
                  color: Color(0xFF00C6A7),
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(12),
                child: const Icon(
                  Icons.send,
                  color: Colors.white,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}