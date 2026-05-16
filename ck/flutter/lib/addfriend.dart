import 'package:flutter/material.dart';

class AddFriendScreen extends StatefulWidget {
  const AddFriendScreen({super.key});

  @override
  State<AddFriendScreen> createState() => _AddFriendScreenState();
}

class _AddFriendScreenState extends State<AddFriendScreen> {

  List<Map<String, dynamic>> friends = [
    {
      "name": "Pena Valdez",
      "avatar": "https://randomuser.me/api/portraits/women/1.jpg",
      "selected": false
    },
    {
      "name": "Gil Hajoon",
      "avatar": "https://randomuser.me/api/portraits/men/2.jpg",
      "selected": true
    },
    {
      "name": "Fitzgerald",
      "avatar": "https://randomuser.me/api/portraits/men/3.jpg",
      "selected": false
    },
    {
      "name": "Kerri Barber",
      "avatar": "https://randomuser.me/api/portraits/women/4.jpg",
      "selected": true
    },
    {
      "name": "WhiteCastaneda",
      "avatar": "https://randomuser.me/api/portraits/women/5.jpg",
      "selected": false
    },
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.grey[100],

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const Icon(Icons.arrow_back, color: Colors.black),
        centerTitle: true,
        title: const Text(
          "Add Friends",
          style: TextStyle(color: Colors.black),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                "DONE",
                style: TextStyle(
                  color: Color(0xFF00C6A7),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          )
        ],
      ),

      body: Column(
        children: [

          /// SEARCH
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search Friend",
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

          /// FRIEND LIST
          Expanded(
            child: ListView.builder(
              itemCount: friends.length,
              itemBuilder: (context, index) {

                final friend = friends[index];

                return ListTile(

                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(friend["avatar"]),
                  ),

                  title: Text(friend["name"]),

                  trailing: GestureDetector(
                    onTap: () {
                      setState(() {
                        friend["selected"] = !friend["selected"];
                      });
                    },

                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey),
                        color: friend["selected"]
                            ? const Color(0xFF00C6A7)
                            : Colors.transparent,
                      ),
                      child: friend["selected"]
                          ? const Icon(Icons.check,
                              size: 16, color: Colors.white)
                          : null,
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}