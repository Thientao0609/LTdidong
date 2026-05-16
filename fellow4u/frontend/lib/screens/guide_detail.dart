import 'package:flutter/material.dart';
import '../core/constants.dart';

class GuideDetailScreen extends StatelessWidget {
  // Thêm 3 biến này để nhận dữ liệu từ trang Explore truyền sang
  final String name;
  final String location;
  final String avatar;

  const GuideDetailScreen({
    super.key,
    required this.name,
    required this.location,
    required this.avatar,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCoverAndAvatar(context),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProfileInfo(),
                  const SizedBox(height: 20),
                  _buildIntroAndVideo(),
                  const SizedBox(height: 25),
                  _buildPricingTable(),
                  const SizedBox(height: 30),
                  _buildExperiencesSection(),
                  const SizedBox(height: 30),
                  _buildReviewsSection(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 1. Ảnh bìa & Avatar & Nút Back
  Widget _buildCoverAndAvatar(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Cover Image
        Image.network(
          'https://images.unsplash.com/photo-1513635269975-59663e0ac1ad?auto=format&fit=crop&q=80&w=800',
          height: 180,
          width: double.infinity,
          fit: BoxFit.cover,

        ),
        // Nút Back
        Positioned(
          top: 40,
          left: 10,
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        // Avatar động (lấy từ biến avatar)
        Positioned(
          bottom: -40,
          left: 20,
          child: Container(
            padding: const EdgeInsets.all(3),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage(avatar),
            ),
          ),
        ),
      ],
    );
  }

  // 2. Thông tin cá nhân (Tên, Đánh giá, Nút Chọn)
  Widget _buildProfileInfo() {
    return Padding(
      padding: const EdgeInsets.only(top: 50),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Info trái
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tên động (lấy từ biến name)
              Text(
                name,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  _buildStars(5),
                  const SizedBox(width: 5),
                  const Text(
                    '127 Reviews',
                    style: TextStyle(color: hintColor, fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              const Text(
                'Vietnamese • English • Korean',
                style: TextStyle(color: hintColor, fontSize: 12),
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  const Icon(Icons.location_on, color: primaryColor, size: 14),
                  const SizedBox(width: 2),
                  // Địa điểm động (lấy từ biến location)
                  Text(
                    location,
                    style: const TextStyle(color: primaryColor, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
          // Nút phải
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              elevation: 0,
            ),
            child: const Text(
              'CHOOSE THIS GUIDE',
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 3. Giới thiệu & Video
  Widget _buildIntroAndVideo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Short Introduction: Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s...',
          style: TextStyle(color: textColor, fontSize: 13, height: 1.5),
        ),
        const SizedBox(height: 15),
        // Khung Video
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image.network(
                'https://images.unsplash.com/photo-1522202176988-66273c2fd55f?auto=format&fit=crop&q=80&w=600',
                height: 160,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Container(color: Colors.black.withOpacity(0.2), height: 160),
              const Icon(Icons.play_circle_fill, color: primaryColor, size: 50),
            ],
          ),
        ),
      ],
    );
  }

  // 4. Bảng giá (Pricing)
  Widget _buildPricingTable() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        children: [
          _buildPriceRow('1 - 3 Travelers', '\$10/hour'),
          const Divider(height: 1, color: Colors.grey),
          _buildPriceRow('4 - 6 Travelers', '\$14/hour'),
          const Divider(height: 1, color: Colors.grey),
          _buildPriceRow('7 - 9 Travelers', '\$17/hour'),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String count, String price) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            count,
            style: const TextStyle(
              color: textColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            price,
            style: const TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // 5. My Experiences
  Widget _buildExperiencesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'My Experiences',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 15),
        _buildExperienceCard(
          '2 Hour Bicycle Tour exploring Hoian',
          'Hoian, Vietnam',
          'Jan 25, 2026',
          '1214 Likes',
        ),
        const SizedBox(height: 20),
        _buildExperienceCard(
          'Food tour in Danang',
          'Danang, Vietnam',
          'Jan 20, 2026',
          '234 Likes',
        ),
      ],
    );
  }

  Widget _buildExperienceCard(
    String title,
    String location,
    String date,
    String likes,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Khung ảnh cắt ghép (Collage)
        SizedBox(
          height: 160,
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    bottomLeft: Radius.circular(8),
                  ),
                  child: Image.network(
                    'https://images.unsplash.com/photo-1559592413-7cec4d0cae2b?auto=format&fit=crop&q=80&w=400',
                    fit: BoxFit.cover,
                    height: double.infinity,
                  ),
                ),
              ),
              const SizedBox(width: 2),
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(8),
                        ),
                        child: Image.network(
                          'https://images.unsplash.com/photo-1542314831-c6a4d14b83cc?auto=format&fit=crop&q=80&w=200',
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(8),
                        ),
                        child: Image.network(
                          'https://images.unsplash.com/photo-1552465011-b4e21bf6e79a?auto=format&fit=crop&q=80&w=200',
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
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 5),
        Row(
          children: [
            const Icon(Icons.location_on, color: primaryColor, size: 14),
            Text(
              location,
              style: const TextStyle(color: primaryColor, fontSize: 12),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(date, style: const TextStyle(color: hintColor, fontSize: 12)),
            Row(
              children: [
                const Icon(
                  Icons.favorite_border,
                  color: primaryColor,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  likes,
                  style: const TextStyle(color: hintColor, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  // 6. Reviews
  Widget _buildReviewsSection() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              'Reviews',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'SEE MORE',
              style: TextStyle(
                color: primaryColor,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        _buildReviewItem(
          'Pena Valdez',
          'Jan 22, 2026',
          'Lorem Ipsum is simply dummy text of the printing and typesetting industry...',
          'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?auto=format&fit=crop&q=80&w=100',
        ),
        const Divider(color: Colors.grey, height: 30),
        _buildReviewItem(
          'Daehyun',
          'Jan 22, 2026',
          'Many desktop publishing packages and web page editors now use Lorem Ipsum...',
          'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&q=80&w=100',
        ),
      ],
    );
  }

  Widget _buildReviewItem(
    String name,
    String date,
    String content,
    String avatar,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(radius: 20, backgroundImage: NetworkImage(avatar)),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStars(5),
                  Text(
                    date,
                    style: const TextStyle(color: hintColor, fontSize: 11),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                content,
                style: const TextStyle(
                  color: textColor,
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Helper: Hàm vẽ N Ngôi sao
  Widget _buildStars(int count) {
    return Row(
      children: List.generate(
        count,
        (index) => const Icon(Icons.star, color: Colors.amber, size: 14),
      ),
    );
  }
}
