import 'package:flutter/material.dart';
import '../core/constants.dart';

class TourDetailScreen extends StatefulWidget {
  // Thêm 3 biến này để nhận dữ liệu từ trang Explore
  final String title;
  final String price;
  final String imgUrl;

  const TourDetailScreen({
    super.key,
    required this.title,
    required this.price,
    required this.imgUrl,
  });

  @override
  State<TourDetailScreen> createState() => _TourDetailScreenState();
}

class _TourDetailScreenState extends State<TourDetailScreen> {
  int _selectedDay = 1; // 1: Day 1, 2: Day 2

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderImage(context),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 20.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTitleAndPrice(),
                  const SizedBox(height: 25),
                  _buildSummaryCard(),
                  const SizedBox(height: 30),
                  _buildScheduleSection(),
                  const SizedBox(height: 30),
                  _buildPriceSection(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Đang chuyển đến trang đặt tour...'),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              child: const Text(
                'BOOK THIS TOUR',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // 1. Ảnh bìa (Đã dùng ảnh động widget.imgUrl)
  Widget _buildHeaderImage(BuildContext context) {
    return Stack(
      children: [
        Image.network(
          widget.imgUrl, // Lấy ảnh từ Explore truyền sang
          height: 250,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
        Container(
          height: 80,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.black.withOpacity(0.5), Colors.transparent],
            ),
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.share_outlined,
                        color: Colors.white,
                      ),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.favorite_border,
                        color: Colors.white,
                      ),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.bookmark_border,
                        color: Colors.white,
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 15,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [_buildDot(true), _buildDot(false), _buildDot(false)],
          ),
        ),
      ],
    );
  }

  Widget _buildDot(bool isActive) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 3),
      width: isActive ? 20 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive ? primaryColor : Colors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  // 2. Tiêu đề và Giá (Đã dùng dữ liệu động widget.title và widget.price)
  Widget _buildTitleAndPrice() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.title, // Lấy tên tour từ Explore truyền sang
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Row(
                    children: List.generate(
                      5,
                      (index) =>
                          const Icon(Icons.star, color: Colors.amber, size: 14),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    '145 Reviews',
                    style: TextStyle(color: hintColor, fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: const [
                  Text(
                    'Provider    ',
                    style: TextStyle(color: hintColor, fontSize: 13),
                  ),
                  Text(
                    'dulichviet',
                    style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              widget.price, // Lấy giá từ Explore truyền sang
              style: const TextStyle(
                color: primaryColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              '\$450.00',
              style: TextStyle(
                color: hintColor,
                fontSize: 14,
                decoration: TextDecoration.lineThrough,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // 3. Khung Summary (Cập nhật tên tour theo dữ liệu động)
  Widget _buildSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Summary',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          _buildSummaryRow(
            'Itinerary',
            widget.title,
          ), // Cập nhật tên vào Itinerary
          const SizedBox(height: 15),
          _buildSummaryRow('Duration', '2 days, 2 nights'),
          const SizedBox(height: 15),
          _buildSummaryRow('Departure Date', 'Feb 12'),
          const SizedBox(height: 15),
          _buildSummaryRow('Departure Place', 'Ho Chi Minh'),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: hintColor, fontSize: 12)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(color: textColor, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  // 4. Lịch trình (Schedule)
  Widget _buildScheduleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            Icon(Icons.map_outlined, size: 24, color: textColor),
            SizedBox(width: 10),
            Text(
              'Schedule',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 15),
        Row(
          children: [
            _buildDayTab(1, 'Day 1'),
            const SizedBox(width: 10),
            _buildDayTab(2, 'Day 2'),
          ],
        ),
        const SizedBox(height: 20),
        const Text(
          'Ho Chi Minh - Da Nang',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 15),

        if (_selectedDay == 1) ...[
          _buildTimelineItem(
            '6:00AM',
            'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s...',
          ),
          _buildTimelineItem(
            '10:00AM',
            'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text...',
          ),
          _buildTimelineItem(
            '1:00PM',
            'Lorem Ipsum is simply dummy text of the printing and typesetting industry...\n\nIt has survived not only five centuries, but also the leap into electronic typesetting.',
          ),
          _buildTimelineItem(
            '8:00PM',
            'Lorem Ipsum is simply dummy text of the printing and typesetting industry...',
            isLast: true,
          ),
        ] else ...[
          _buildTimelineItem('8:00AM', 'Nội dung lịch trình ngày 2...'),
          _buildTimelineItem(
            '12:00PM',
            'Ăn trưa và nghỉ ngơi...',
            isLast: true,
          ),
        ],
      ],
    );
  }

  Widget _buildDayTab(int dayIndex, String text) {
    bool isActive = _selectedDay == dayIndex;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedDay = dayIndex;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: isActive ? primaryColor : Colors.grey.shade300,
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isActive ? Colors.white : hintColor,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildTimelineItem(
    String time,
    String content, {
    bool isLast = false,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            children: [
              Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: primaryColor,
                  border: Border.all(color: const Color(0xFFB2EFE0), width: 3),
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(width: 2, color: Colors.grey.shade200),
                ),
            ],
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    time,
                    style: const TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    content,
                    style: const TextStyle(
                      color: textColor,
                      height: 1.5,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 5. Bảng Giá (Price)
  Widget _buildPriceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            Icon(Icons.monetization_on_outlined, size: 24, color: textColor),
            SizedBox(width: 10),
            Text(
              'Price',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 15),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Column(
            children: [
              _buildPriceRow(
                'Adult (>10 years old)',
                widget.price,
              ), // Cập nhật giá động
              const Divider(height: 1, color: Colors.grey),
              _buildPriceRow('Child (5 - 10 years old)', '\$320.00'),
              const Divider(height: 1, color: Colors.grey),
              _buildPriceRow('Child (<5 years old)', 'Free', isFree: true),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPriceRow(String type, String price, {bool isFree = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(type, style: const TextStyle(color: textColor, fontSize: 13)),
          Text(
            price,
            style: TextStyle(
              color: isFree ? textColor : textColor,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
