import 'package:flutter/material.dart';
import '../core/constants.dart';

class AddFriendScreen extends StatefulWidget {
  const AddFriendScreen({super.key});

  @override
  State<AddFriendScreen> createState() => _AddFriendScreenState();
}

class _AddFriendScreenState extends State<AddFriendScreen> {
  final List<Map<String, dynamic>> _friends = [
    {
      'name': 'Pena Valdez',
      'img':
          'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?auto=format&fit=crop&q=80&w=100',
      'selected': false,
    },
    {
      'name': 'Gil Hajoon',
      'img':
          'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&q=80&w=100',
      'selected': true,
    },
    {
      'name': 'Fitzgerald',
      'img':
          'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format&fit=crop&q=80&w=100',
      'selected': false,
    },
    {
      'name': 'KerriBarber',
      'img':
          'https://images.unsplash.com/photo-1517841905240-472988babdf9?auto=format&fit=crop&q=80&w=100',
      'selected': true,
    },
    {
      'name': 'WhiteCastaneda',
      'img':
          'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&q=80&w=100',
      'selected': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Lấy ra danh sách những người đã chọn
    final selectedFriends = _friends
        .where((f) => f['selected'] == true)
        .toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: textColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Add Friends',
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'DONE',
              style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              height: 45,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: const [
                  Icon(Icons.search, color: hintColor),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search Friend',
                        hintStyle: TextStyle(color: hintColor, fontSize: 14),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Selected Friends (Nằm ngang)
          if (selectedFriends.isNotEmpty)
            Container(
              height: 60,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: selectedFriends.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundImage: NetworkImage(
                            selectedFriends[index]['img'],
                          ),
                        ),
                        Positioned(
                          top: -2,
                          right: -2,
                          child: GestureDetector(
                            onTap: () {
                              setState(
                                () =>
                                    selectedFriends[index]['selected'] = false,
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: const BoxDecoration(
                                color: Colors.black,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 12,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

          if (selectedFriends.isNotEmpty) const SizedBox(height: 10),

          // Danh sách bạn bè
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _friends.length,
              itemBuilder: (context, index) {
                final friend = _friends[index];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    radius: 25,
                    backgroundImage: NetworkImage(friend['img']),
                  ),
                  title: Text(
                    friend['name'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  trailing: GestureDetector(
                    onTap: () {
                      setState(() => friend['selected'] = !friend['selected']);
                    },
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: friend['selected'] ? primaryColor : Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: friend['selected']
                              ? primaryColor
                              : Colors.grey.shade400,
                        ),
                      ),
                      child: friend['selected']
                          ? const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 16,
                            )
                          : null,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
