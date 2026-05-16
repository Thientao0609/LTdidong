import 'package:flutter/material.dart';
import 'chat_detail.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],

      body: Column(
        children: [

          // HEADER
          Container(
            height: 160,
            padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                    "https://images.unsplash.com/photo-1507525428034-b723cf961d3e"),
                fit: BoxFit.cover,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  "Chat",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(Icons.search, color: Colors.white)
              ],
            ),
          ),

          // SEARCH
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search Chat",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // CHAT LIST
          Expanded(
            child: ListView(
              children: const [

                ChatItem(
                  name: "Tuan Tran",
                  message: "It's a beautiful place",
                  time: "10:30 AM",
                  avatar: "./assets/TuanTran.png",
                ),

                ChatItem(
                  name: "Emmy",
                  message: "We can start at 8am",
                  time: "",
                  avatar: "./assets/anna.png",
                  unread: true,
                ),

                ChatItem(
                  name: "Khai Ho",
                  message: "See you tomorrow",
                  time: "11:30 AM",
                  avatar: "./assets/John.png",
                ),

              ],
            ),
          )
        ],
      ),
    );
  }
}

class ChatItem extends StatelessWidget {

  final String name;
  final String message;
  final String time;
  final String avatar;
  final bool unread;

  const ChatItem({
    super.key,
    required this.name,
    required this.message,
    required this.time,
    required this.avatar,
    this.unread = false,
  });

  @override
  Widget build(BuildContext context) {

    return ListTile(

      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatDetailScreen(
              name: name,
              avatar: avatar,
            ),
          ),
        );
      },

      leading: CircleAvatar(
        backgroundImage: NetworkImage(avatar),
        radius: 25,
      ),

      title: Text(
        name,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),

      subtitle: Text(message),

      trailing: unread
          ? Container(
              width: 20,
              height: 20,
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Text(
                  "1",
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            )
          : Text(
              time,
              style: const TextStyle(color: Colors.grey),
            ),
    );
  }
}