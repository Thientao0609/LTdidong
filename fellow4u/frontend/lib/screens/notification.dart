import 'package:flutter/material.dart';
import '../core/constants.dart'; // Đảm bảo import file chứa primaryColor

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  // Dữ liệu giả lập (Dummy Data) giống trong hình
  final List<Map<String, dynamic>> _notifications = [
    {
      'id': 1,
      'avatar':
          'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format&fit=crop&q=80&w=100', // Hình nam
      'name': 'Tuan Tran',
      'message':
          'accepted your request for the trip in Danang, Vietnam on Jan 20, 2020',
      'date': 'Jan 16',
      'type': 'accept', // Dùng để xác định icon badge
      'hasButton': false,
      'isRead': true,
    },
    {
      'id': 2,
      'avatar':
          'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&q=80&w=100', // Hình nữ
      'name': 'Emmy',
      'message':
          'sent you an offer for the trip in Ho Chi Minh, Vietnam on Feb 12, 2020',
      'date': 'Jan 16',
      'type': 'offer',
      'hasButton': false,
      'isRead': true,
    },
    {
      'id': 3,
      'avatar': 'LOGO', // Đánh dấu là logo app
      'name': 'System',
      'message':
          'Thanks! Your trip in Danang, Vietnam on Jan 20, 2020 has been finished. Please leave a review for the guide Tuan Tran.',
      'date': 'Jan 24',
      'type': 'review',
      'hasButton': true, // Có nút Leave Review
      'isRead': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.zero,
              itemCount: _notifications.length,
              separatorBuilder: (context, index) =>
                  const Divider(height: 1, color: Color(0xFFEEEEEE)),
              itemBuilder: (context, index) {
                return _buildNotificationItem(_notifications[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  // Widget Header với hình nền
  Widget _buildHeader() {
    return SizedBox(
      height: 180, // Chiều cao header
      child: Stack(
        children: [
          // Hình nền (Cầu Rồng / Đà Nẵng)
          Positioned.fill(
            child: Image.network(
              'https://images.unsplash.com/photo-1559592413-7cec4d0cae2b?auto=format&fit=crop&q=80&w=800', // Ảnh Đà Nẵng
              fit: BoxFit.cover,
            ),
          ),
          // Lớp phủ mờ nhẹ để chữ dễ đọc hơn (nếu cần)
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.1)),
          ),
          // Nội dung Header
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '9:41', // Giả lập status bar trong design
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: const [
                          Icon(
                            Icons.signal_cellular_alt,
                            color: Colors.white,
                            size: 18,
                          ),
                          SizedBox(width: 5),
                          Icon(Icons.wifi, color: Colors.white, size: 18),
                          SizedBox(width: 5),
                          Icon(
                            Icons.battery_full,
                            color: Colors.white,
                            size: 18,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Notifications',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.search, color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget hiển thị từng item thông báo
  Widget _buildNotificationItem(Map<String, dynamic> data) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar + Badge Icon
          Stack(
            children: [
              Container(
                margin: const EdgeInsets.only(right: 5, bottom: 5),
                child: data['avatar'] == 'LOGO'
                    ? CircleAvatar(
                        radius: 25,
                        backgroundColor: primaryColor,
                        child: const Icon(
                          Icons.card_travel, // Đã thay thế Icons.mode_travel
                          color: Colors.white,
                        ),
                      )
                    : CircleAvatar(
                        radius: 25,
                        backgroundImage: NetworkImage(data['avatar']),
                      ),
              ),
              // Badge Icon nhỏ ở góc
              Positioned(
                right: 0,
                bottom: 0,
                child: _buildBadgeIcon(data['type']),
              ),
            ],
          ),
          const SizedBox(width: 15),
          // Nội dung Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 15,
                      color: Color(0xFF333333),
                      height: 1.4,
                    ),
                    children: [
                      // Nếu không phải system thì in đậm tên
                      if (data['name'] != 'System')
                        TextSpan(
                          text: '${data['name']} ', // Tên người dùng
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ), // Có thể bỏ bold nếu muốn giống y hệt hình
                        ),
                      TextSpan(text: data['message']),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  data['date'],
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),

                // Nút "Leave Review" nếu có
                if (data['hasButton'])
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor, // Màu xanh chủ đạo
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                      ),
                      child: const Text(
                        'Leave Review',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper tạo Badge Icon (tròn nhỏ)
  Widget _buildBadgeIcon(String type) {
    IconData icon;
    Color color;

    switch (type) {
      case 'accept':
        icon = Icons.location_on;
        color = Colors.green; // Màu xanh lá mạ
        break;
      case 'offer':
        icon = Icons.description; // Icon tờ giấy
        color = Colors.amber; // Màu vàng
        break;
      case 'review':
        icon = Icons.edit;
        color = Colors.blue; // Màu xanh dương
        break;
      default:
        icon = Icons.notifications;
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2), // Viền trắng
      ),
      child: Icon(icon, size: 12, color: Colors.white),
    );
  }
}
