import 'package:flutter/material.dart';
import '../core/constants.dart';
import 'create_new_trip.dart'; // Đã thêm import trang Create New Trip
import 'trip_detail.dart'; // Đã thêm import trang Trip Detail

class MyTripsScreen extends StatefulWidget {
  const MyTripsScreen({super.key});

  @override
  State<MyTripsScreen> createState() => _MyTripsScreenState();
}

class _MyTripsScreenState extends State<MyTripsScreen> {
  int _selectedTab = 0; // 0: Current, 1: Next, 2: Past, 3: Wish List
  final List<String> _tabs = [
    'Current Trips',
    'Next Trips',
    'Past Trips',
    'Wish List',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Column(
        children: [
          _buildHeader(),
          _buildTabBar(),
          Expanded(child: _buildListContent()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Mở màn hình Create New Trip khi bấm vào nút (+)
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateNewTripScreen(),
            ),
          );
        },
        backgroundColor: primaryColor,
        elevation: 4,
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }

  // ==========================================
  // 1. HEADER
  // ==========================================
  Widget _buildHeader() {
    return Stack(
      children: [
        Image.network(
          'https://images.unsplash.com/photo-1559592413-7cec4d0cae2b?auto=format&fit=crop&q=80&w=800',
          height: 140,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
        Container(
          height: 140,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.black.withOpacity(0.4), Colors.transparent],
            ),
          ),
        ),
        SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'My Trips',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.search, color: Colors.white, size: 28),
                  onPressed: () {},
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ==========================================
  // 2. TAB BAR
  // ==========================================
  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          children: List.generate(_tabs.length, (index) {
            bool isActive = _selectedTab == index;
            return GestureDetector(
              onTap: () => setState(() => _selectedTab = index),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 5),
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isActive ? primaryColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),


                ),
                child: Text(
                  _tabs[index],
                  style: TextStyle(
                    color: isActive ? Colors.white : hintColor,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  // ==========================================
  // 3. NỘI DUNG TỪNG TAB
  // ==========================================
  Widget _buildListContent() {
    if (_selectedTab == 0) {
      return ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildTripCard(
            title: 'Dragon Bridge Trip',
            date: 'Jan 30, 2020',
            time: '13:00 - 15:00',
            guideName: 'Tuan Tran',
            location: 'Da Nang, Vietnam',
            imgUrl:
                'https://images.unsplash.com/photo-1559592413-7cec4d0cae2b?auto=format&fit=crop&q=80&w=600',
            avatars: [
              'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format&fit=crop&q=80&w=100',
            ],
            badge: _buildBadge(
              'Mark Finished',
              color: Colors.black.withOpacity(0.6),
              icon: Icons.check,
            ),
            buttons: [
              _buildOutlineButton(
                'Detail',
                onTap: () {
                  // Mở màn hình Trip Detail
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TripDetailScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      );
    } else if (_selectedTab == 1) {
      return ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildTripCard(
            title: 'Ho Guom Trip',
            date: 'Feb 2, 2020',
            time: '8:00 - 10:00',
            guideName: 'Emmy',
            location: 'Hanoi, Vietnam',
            imgUrl:
                'https://images.unsplash.com/photo-1528127269322-539801943592?auto=format&fit=crop&q=80&w=600',
            avatars: [
              'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&q=80&w=100',
            ],
            buttons: [
              _buildOutlineButton('Detail'),
              _buildOutlineButton('Chat'),
              _buildFilledButton('Pay'),
            ],
          ),
          const SizedBox(height: 20),
          _buildTripCard(
            title: 'Ho Chi Minh Mausoleum',
            date: 'Feb 2, 2020',
            time: '8:00 - 10:00',
            guideName: 'Emmy',
            location: 'Hanoi, Vietnam',
            imgUrl:
                'https://images.unsplash.com/photo-1552465011-b4e21bf6e79a?auto=format&fit=crop&q=80&w=600',
            avatars: [
              'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&q=80&w=100',
            ],
            badge: _buildBadge('Waiting', color: Colors.blue),
            buttons: [_buildOutlineButton('Detail')],
          ),
          const SizedBox(height: 20),
          _buildTripCard(
            title: 'Duc Ba Church',
            date: 'Feb 2, 2020',
            time: '8:00 - 10:00',
            guideName: 'Waiting for offers',
            location: 'Ho Chi Minh, Vietnam',
            imgUrl:
                'https://images.unsplash.com/photo-1542314831-c6a4d14b83cc?auto=format&fit=crop&q=80&w=600',
            badge: _buildBadge('Bidding', color: Colors.orange),
            avatars: [
              'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format&fit=crop&q=80&w=100',
              'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&q=80&w=100',
            ],
            extraAvatars: 3,
            buttons: [
              _buildOutlineButton('Detail'),
              _buildOutlineButton('Chat'),
            ],
          ),
          const SizedBox(height: 20),
          _buildTripCard(
            title: 'Ho Chi Minh Mausoleum',
            date: 'Feb 2, 2020',
            time: '8:00 - 10:00',
            guideName: 'Choose another Guide',
            location: 'Hanoi, Vietnam',
            imgUrl:
                'https://images.unsplash.com/photo-1552465011-b4e21bf6e79a?auto=format&fit=crop&q=80&w=600',
            isPlaceholderAvatar: true,
            buttons: [
              _buildOutlineButton('Detail'),
              _buildFilledButton('Choose another Guide'),
            ],
          ),
        ],
      );
    } else if (_selectedTab == 2) {
      return ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildTripCard(
            title: 'Quoc Tu Giam Temple',
            date: 'Feb 2, 2020',
            time: '8:00 - 10:00',
            guideName: 'Emmy',
            location: 'Hanoi, Vietnam',
            imgUrl:
                'https://images.unsplash.com/photo-1542314831-c6a4d14b83cc?auto=format&fit=crop&q=80&w=600',
            avatars: [
              'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&q=80&w=100',
            ],
            buttons: [],
          ),
          const SizedBox(height: 20),
          _buildTripCard(
            title: 'Dinh Doc Lap',
            date: 'Feb 2, 2020',
            time: '8:00 - 10:00',
            guideName: 'Khai Ho',
            location: 'Ho Chi Minh, Vietnam',
            imgUrl:
                'https://images.unsplash.com/photo-1552465011-b4e21bf6e79a?auto=format&fit=crop&q=80&w=600',
            avatars: [
              'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&q=80&w=100',
            ],
            buttons: [],
          ),
        ],
      );
    } else {
      return ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildWishListCard(
            'Melbourne - Sydney',
            '\$600.00',
            'https://images.unsplash.com/photo-1514395462725-fb4566210144?auto=format&fit=crop&q=80&w=600',
          ),
          const SizedBox(height: 20),
          _buildWishListCard(
            'Hanoi - Ha Long Bay',
            '\$300.00',
            'https://images.unsplash.com/photo-1528127269322-539801943592?auto=format&fit=crop&q=80&w=600',
          ),
        ],
      );
    }
  }

  // ==========================================
  // HELPER WIDGETS
  // ==========================================
  Widget _buildTripCard({
    required String title,
    required String date,
    required String time,
    required String guideName,
    required String location,
    required String imgUrl,
    List<String> avatars = const [],
    int extraAvatars = 0,
    bool isPlaceholderAvatar = false,
    Widget? badge,
    required List<Widget> buttons,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(15),
                ),
                child: Image.network(
                  imgUrl,
                  height: 140,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.6),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 10,
                left: 15,
                child: Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: Colors.white,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      location,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              if (badge != null) Positioned(top: 10, left: 15, child: badge),
              Positioned(
                bottom: -20,
                right: 15,
                child: _buildAvatarStack(
                  avatars,
                  extraAvatars,
                  isPlaceholderAvatar,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 25,
              left: 15,
              right: 15,
              bottom: 15,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                _buildInfoRow(Icons.calendar_today, date),
                const SizedBox(height: 5),
                _buildInfoRow(Icons.access_time, time),
                const SizedBox(height: 5),
                _buildInfoRow(
                  isPlaceholderAvatar
                      ? Icons.person_add_alt_1
                      : Icons.person_outline,
                  guideName,
                  color: isPlaceholderAvatar ? textColor : hintColor,
                  isBold: isPlaceholderAvatar,
                ),
                if (buttons.isNotEmpty) ...[
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Divider(color: Color(0xFFEEEEEE), height: 1),
                  ),
                  Row(
                    children: buttons
                        .map(
                          (btn) => Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                              ),
                              child: btn,
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarStack(
    List<String> urls,
    int extraCount,
    bool isPlaceholder,
  ) {
    if (isPlaceholder) {
      return CircleAvatar(
        radius: 26,
        backgroundColor: Colors.white,
        child: CircleAvatar(
          radius: 23,
          backgroundColor: Colors.white,
          child: Icon(Icons.person_outline, color: primaryColor, size: 30),
        ),
      );
    }
    List<Widget> stackChildren = [];
    double rightPos = 0;
    if (extraCount > 0) {
      stackChildren.add(
        Positioned(
          right: rightPos,
          child: CircleAvatar(
            radius: 26,
            backgroundColor: Colors.white,
            child: CircleAvatar(
              radius: 23,
              backgroundColor: primaryColor,
              child: Text(
                '+$extraCount',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ),
      );
      rightPos += 30;
    }
    for (int i = urls.length - 1; i >= 0; i--) {
      stackChildren.add(
        Positioned(
          right: rightPos,
          child: CircleAvatar(
            radius: 26,
            backgroundColor: Colors.white,
            child: CircleAvatar(
              radius: 23,
              backgroundImage: NetworkImage(urls[i]),
            ),
          ),
        ),
      );
      rightPos += 30;
    }
    return SizedBox(
      width: rightPos + 22,
      height: 52,
      child: Stack(clipBehavior: Clip.none, children: stackChildren),
    );
  }

  Widget _buildInfoRow(
    IconData icon,
    String text, {
    Color color = hintColor,
    bool isBold = false,
  }) {
    return Row(
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            color: color,
            fontSize: 13,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildBadge(String text, {required Color color, IconData? icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, color: Colors.white, size: 12),
            const SizedBox(width: 4),
          ],
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOutlineButton(String text, {VoidCallback? onTap}) {
    return OutlinedButton(
      onPressed: onTap ?? () {},
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: primaryColor, width: 1.2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(vertical: 10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (text == 'Detail')
            const Icon(Icons.info_outline, size: 14, color: primaryColor),
          if (text == 'Chat')
            const Icon(
              Icons.chat_bubble_outline,
              size: 14,
              color: primaryColor,
            ),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(
              color: primaryColor,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilledButton(String text, {VoidCallback? onTap}) {
    return ElevatedButton(
      onPressed: onTap ?? () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(vertical: 10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (text == 'Pay')
            const Icon(Icons.payment, size: 14, color: Colors.white),
          if (text == 'Pay') const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWishListCard(String title, String price, String imgUrl) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: Image.network(
                  imgUrl,
                  height: 160,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: const Icon(
                  Icons.bookmark,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              Positioned(
                bottom: 10,
                left: 15,
                child: Row(
                  children: [
                    Row(
                      children: List.generate(
                        5,
                        (index) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 12,
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    const Text(
                      '1247 likes',
                      style: TextStyle(color: Colors.white, fontSize: 11),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: const [
                        Icon(Icons.calendar_today, size: 12, color: hintColor),
                        SizedBox(width: 5),
                        Text(
                          'Jan 30, 2020',
                          style: TextStyle(fontSize: 12, color: hintColor),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: const [
                        Icon(Icons.access_time, size: 12, color: hintColor),
                        SizedBox(width: 5),
                        Text(
                          '3 days',
                          style: TextStyle(fontSize: 12, color: hintColor),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Icon(Icons.favorite, color: primaryColor, size: 20),
                    const SizedBox(height: 10),
                    Text(
                      price,
                      style: const TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
