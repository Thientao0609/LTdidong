import 'package:flutter/material.dart';
import '../core/constants.dart';

class TripDetailScreen extends StatelessWidget {
  const TripDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: textColor, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Trip Detail',
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderImage(),
            const SizedBox(height: 30),

            _buildInfoRow('Date', 'Feb 2, 2020'),
            _buildInfoRow('Time', '8:00AM - 10:00AM'),
            _buildInfoRow('Guide', 'Emmy', isGuide: true),
            _buildInfoRow('Number of Travelers', '2'),

            const SizedBox(height: 10),

            const Text(
              'Attractions',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _buildAttractionChip('Ho Guom'),
                _buildAttractionChip('Ho Hoan Kiem'),
                _buildAttractionChip('Pho 12 Pho Kim Ma'),
              ],
            ),

            const SizedBox(height: 40),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'Fee',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                Text(
                  '\$20.00',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),

            // Nút Mark Finished đã được thêm sự kiện Navigator.pop
            _buildMarkFinishedButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderImage() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            'https://images.unsplash.com/photo-1559592413-7cec4d0cae2b?auto=format&fit=crop&q=80&w=800',
            height: 180,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          bottom: 12,
          left: 12,
          child: Row(
            children: const [
              Icon(Icons.location_on, color: Colors.white, size: 18),
              SizedBox(width: 4),
              Text(
                'Danang, Vietnam',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: -20,
          right: 20,
          child: Container(
            padding: const EdgeInsets.all(3),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage(
                'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&q=80&w=200',
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isGuide = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: textColor,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: isGuide ? primaryColor : hintColor,
              fontSize: 15,
              fontWeight: isGuide ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttractionChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.location_on, color: primaryColor, size: 16),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(color: textColor, fontSize: 13)),
        ],
      ),
    );
  }

  // Cập nhật hàm build nút bấm để nhận context và thực hiện quay lại trang cũ
  Widget _buildMarkFinishedButton(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: () {
          // Hiện thông báo nhẹ và quay lại trang My Trips
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Trip marked as finished!'),
              duration: Duration(seconds: 1),
            ),
          );
          Navigator.pop(context);
        },
        borderRadius: BorderRadius.circular(25),
        child: Container(
          width: 180,
          height: 45,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.check, color: textColor, size: 20),
              SizedBox(width: 8),
              Text(
                'Mark Finished',
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
