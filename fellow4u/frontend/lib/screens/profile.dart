import 'package:flutter/material.dart';
import '../core/constants.dart';
import 'settings.dart'; // Import trang cài đặt

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: 50), // Khoảng cách cho avatar lẹm lên
            _buildMyPhotos(),
            const SizedBox(height: 30),
            _buildMyJourneys(),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // 1. Header: Ảnh bìa + Avatar + Icon Cài đặt
  Widget _buildHeader(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Image.network(
          'https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&q=80&w=800',
          height: 180,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
        Positioned(
          top: 40,
          right: 15,
          child: IconButton(
            icon: const Icon(Icons.settings, color: Colors.white, size: 28),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsScreen()),
            ),
          ),
        ),
        Positioned(
          bottom: -40,
          left: 20,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const CircleAvatar(
                radius: 45,
                backgroundImage: NetworkImage(
                  'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&q=80&w=200',
                ),
              ),
              const SizedBox(width: 15),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Yoo Jin',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'yoojin@gmail.com',
                      style: TextStyle(color: hintColor, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // 2. Section: My Photos (Cuộn ngang)
  Widget _buildMyPhotos() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'My Photos',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Icon(Icons.arrow_forward_ios, size: 16, color: hintColor),
            ],
          ),
        ),
        const SizedBox(height: 15),
        SizedBox(
          height: 100,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            separatorBuilder: (context, index) => const SizedBox(width: 10),
            itemBuilder: (context, index) => ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                'https://picsum.photos/200/200?random=$index',
                width: 100,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // 3. Section: My Journeys (Danh sách dọc)
  Widget _buildMyJourneys() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'My Journeys',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Icon(Icons.arrow_forward_ios, size: 16, color: hintColor),
            ],
          ),
        ),
        const SizedBox(height: 15),
        _buildJourneyCard(
          'A memory in Danang',
          'Danang, Vietnam',
          'Jan 20, 2020',
        ),
        const SizedBox(height: 20),
        _buildJourneyCard('Sapa in spring', 'Sapa, Vietnam', 'Jan 20, 2020'),
      ],
    );
  }

  Widget _buildJourneyCard(String title, String location, String date) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Collage Image Header
          SizedBox(
            height: 160,
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                    ),
                    child: Image.network(
                      'https://picsum.photos/400/300?random=$title',
                      fit: BoxFit.cover,
                      height: double.infinity,
                    ),
                  ),
                ),
                const SizedBox(width: 2),
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(10),
                          ),
                          child: Image.network(
                            'https://picsum.photos/200/200?random=1$title',
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            bottomRight: Radius.circular(10),
                          ),
                          child: Image.network(
                            'https://picsum.photos/200/200?random=2$title',
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 14,
                        color: primaryColor,
                      ),
                      Text(
                        location,
                        style: const TextStyle(
                          color: primaryColor,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    date,
                    style: const TextStyle(color: hintColor, fontSize: 12),
                  ),
                ],
              ),
              Row(
                children: const [
                  Icon(Icons.favorite, color: Colors.red, size: 18),
                  SizedBox(width: 4),
                  Text(
                    '234 Likes',
                    style: TextStyle(color: hintColor, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
