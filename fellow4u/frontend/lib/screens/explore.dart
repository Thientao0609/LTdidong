import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../core/api_service.dart';
import 'guide_detail.dart';
import 'tour_detail.dart';
import 'search_screen.dart'; // Thêm import trang Search vào đây

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            _HeaderSection(),
            SizedBox(height: 10),

            _TopJourneysSection(),
            _BestGuidesSection(),
            _TopExperiencesSection(),
            _FeaturedToursSection(),
            _TravelNewsSection(),

            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

// 1. Header & Thanh tìm kiếm
class _HeaderSection extends StatelessWidget {
  const _HeaderSection();

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 220,
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                'https://images.unsplash.com/photo-1559592413-7cec4d0cae2b?auto=format&fit=crop&q=80&w=800',
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            color: Colors.black.withOpacity(0.2),
            padding: const EdgeInsets.only(top: 60, left: 20, right: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Explore',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: const [
                    Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.white, size: 16),
                        SizedBox(width: 4),
                        Text(
                          'Da Nang',
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.cloud, color: Colors.white, size: 24),
                        SizedBox(width: 5),
                        Text(
                          '26°C',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: -25,
          left: 20,
          right: 20,
          child: Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.search, color: hintColor),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    readOnly: true, // Ngăn bàn phím bật lên ở trang này
                    onTap: () {
                      // Chuyển sang màn hình SearchScreen
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  const SearchScreen(),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                                // Thêm hiệu ứng mờ dần (Fade) cho mượt
                                return FadeTransition(
                                  opacity: animation,
                                  child: child,
                                );
                              },
                        ),
                      );
                    },
                    decoration: const InputDecoration(
                      hintText: 'Hi, where do you want to explore?',
                      hintStyle: TextStyle(color: hintColor, fontSize: 14),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// 2. Top Journeys
class _TopJourneysSection extends StatelessWidget {
  const _TopJourneysSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40, left: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Top Journeys',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          SizedBox(
            height: 240,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildJourneyCard(
                  'Da Nang - Ba Na - Hoi An',
                  '\$400.00',
                  'https://images.unsplash.com/photo-1559592413-7cec4d0cae2b?auto=format&fit=crop&q=80&w=400',
                ),
                _buildJourneyCard(
                  'Thailand',
                  '\$600.00',
                  'https://images.unsplash.com/photo-1552465011-b4e21bf6e79a?auto=format&fit=crop&q=80&w=400',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJourneyCard(String title, String price, String imgUrl) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.network(
              imgUrl,
              height: 130,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 5),
                Row(
                  children: const [
                    Icon(Icons.calendar_today, size: 12, color: hintColor),
                    SizedBox(width: 4),
                    Text(
                      'Jan 30, 2026',
                      style: TextStyle(fontSize: 11, color: hintColor),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Row(
                  children: const [
                    Icon(Icons.access_time, size: 12, color: hintColor),
                    SizedBox(width: 4),
                    Text(
                      '3 days',
                      style: TextStyle(fontSize: 11, color: hintColor),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  price,
                  style: const TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// 3. Best Guides
class _BestGuidesSection extends StatelessWidget {
  const _BestGuidesSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Best Guides',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Text(
                  'SEE MORE',
                  style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          SizedBox(
            height: 200,
            child: FutureBuilder<List<dynamic>>(
              future: ApiService.getGuides(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No guides found'));
                }
                final guides = snapshot.data!;
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: guides.length,
                  itemBuilder: (context, index) {
                    final guide = guides[index];
                    return _buildGuideCard(
                      context,
                      guide['name'],
                      guide['location'],
                      guide['avatar'],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuideCard(
    BuildContext context,
    String name,
    String location,
    String imgUrl,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GuideDetailScreen(
              name: name,
              location: location,
              avatar: imgUrl,
            ),
          ),
        );
      },
      child: Container(
        width: 140,
        margin: const EdgeInsets.only(right: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                imgUrl,
                height: 140,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            Row(
              children: [
                const Icon(Icons.location_on, size: 12, color: primaryColor),
                Text(
                  location,
                  style: const TextStyle(fontSize: 11, color: primaryColor),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// 4. Top Experiences
class _TopExperiencesSection extends StatelessWidget {
  const _TopExperiencesSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Top Experiences',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          SizedBox(
            height: 220,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildExpCard(
                  '2 Hour Bicycle Tour...',
                  'Tuan Tran',
                  'https://images.unsplash.com/photo-1517649763962-0c623066013b?auto=format&fit=crop&q=80&w=300',
                  'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format&fit=crop&q=80&w=100',
                ),
                _buildExpCard(
                  '1 day at Bana Hill',
                  'Linh Hana',
                  'https://images.unsplash.com/photo-1583417311718-ee2f659cb51e?auto=format&fit=crop&q=80&w=300',
                  'https://images.unsplash.com/photo-1517841905240-472988babdf9?auto=format&fit=crop&q=80&w=100',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpCard(
    String title,
    String guideName,
    String bgImg,
    String avatarImg,
  ) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.bottomCenter,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  bgImg,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                bottom: -20,
                child: Column(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(avatarImg),
                      radius: 20,
                      backgroundColor: Colors.white,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        guideName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            maxLines: 2,
          ),
        ],
      ),
    );
  }
}

// 5. Featured Tours (Đã cập nhật dữ liệu động cho hàm _buildFeatureCard)
class _FeaturedToursSection extends StatelessWidget {
  const _FeaturedToursSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Featured Tours',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                'SEE MORE',
                style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          _buildFeatureCard(
            context,
            'Da Nang - Ba Na - Hoi An',
            '\$400.00',
            'https://images.unsplash.com/photo-1559592413-7cec4d0cae2b?auto=format&fit=crop&q=80&w=600',
          ),
          const SizedBox(height: 15),
          _buildFeatureCard(
            context,
            'Melbourne - Sydney',
            '\$600.00',
            'https://images.unsplash.com/photo-1514395462725-fb4566210144?auto=format&fit=crop&q=80&w=600',
          ),
        ],
      ),
    );
  }

  // Đã truyền các biến title, price, imgUrl sang trang Tour Detail
  Widget _buildFeatureCard(
    BuildContext context,
    String title,
    String price,
    String imgUrl,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                TourDetailScreen(title: title, price: price, imgUrl: imgUrl),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
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
                          Icon(
                            Icons.calendar_today,
                            size: 12,
                            color: hintColor,
                          ),
                          SizedBox(width: 5),
                          Text(
                            'Jan 30, 2026',
                            style: TextStyle(fontSize: 12, color: hintColor),
                          ),
                        ],
                      ),
                    ],
                  ),
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
            ),
          ],
        ),
      ),
    );
  }
}

// 6. Travel News
class _TravelNewsSection extends StatelessWidget {
  const _TravelNewsSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Travel News',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                'SEE MORE',
                style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          _buildNewsCard(
            'New Destination in Danang City',
            'Feb 5, 2026',
            'https://images.unsplash.com/photo-1542314831-c6a4d14b83cc?auto=format&fit=crop&q=80&w=600',
          ),
          const SizedBox(height: 15),
          _buildNewsCard(
            '\$1 Flight Ticket',
            'Feb 5, 2026',
            'https://images.unsplash.com/photo-1436491865332-7a61a109cc05?auto=format&fit=crop&q=80&w=600',
          ),
        ],
      ),
    );
  }

  Widget _buildNewsCard(String title, String date, String imgUrl) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        Text(date, style: const TextStyle(fontSize: 12, color: hintColor)),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(
            imgUrl,
            height: 120,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
      ],
    );
  }
}
