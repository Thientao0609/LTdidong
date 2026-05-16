import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../core/api_service.dart';

class CreateNewTripScreen extends StatefulWidget {
  const CreateNewTripScreen({super.key});

  @override
  State<CreateNewTripScreen> createState() => _CreateNewTripScreenState();
}

class _CreateNewTripScreenState extends State<CreateNewTripScreen> {
  int _travelerCount = 1;
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _locationController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  // Danh sách giả lập cho phần Attractions
  final List<Map<String, dynamic>> _attractions = [
    {
      'name': 'Dragon Bridge',
      'img':
          'https://images.unsplash.com/photo-1559592413-7cec4d0cae2b?auto=format&fit=crop&q=80&w=400',
      'selected': true,
    },
    {
      'name': 'Cham Museum',
      'img':
          'https://images.unsplash.com/photo-1542314831-c6a4d14b83cc?auto=format&fit=crop&q=80&w=400',
      'selected': false,
    },
    {
      'name': 'My Khe Beach',
      'img':
          'https://images.unsplash.com/photo-1552465011-b4e21bf6e79a?auto=format&fit=crop&q=80&w=400',
      'selected': true,
    },
  ];

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
          'Create New Trip',
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
            _buildLabeledTextField(
              label: 'Where you want to explore',
              hint: 'Danang, Vietnam',
              icon: Icons.location_on_outlined,
              controller: _locationController,
            ),
            const SizedBox(height: 20),

            _buildLabeledTextField(
              label: 'Date',
              hint: 'mm/dd/yy',
              icon: Icons.calendar_today_outlined,
              controller: _dateController,
            ),
            const SizedBox(height: 20),

            // Time Row (From - To)
            const Text(
              'Time',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: textColor,
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: _buildTextFieldOnly(
                    hint: 'From',
                    icon: Icons.access_time,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: _buildTextFieldOnly(
                    hint: 'To',
                    icon: Icons.access_time,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),

            // Number of travelers
            const Text(
              'Number of travelers',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: textColor,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _buildCounterButton(Icons.arrow_drop_down, () {
                  if (_travelerCount > 1) setState(() => _travelerCount--);
                }),
                Container(
                  width: 50,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.grey, width: 1),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      '$_travelerCount',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                _buildCounterButton(Icons.arrow_drop_up, () {
                  setState(() => _travelerCount++);
                }),
              ],
            ),
            const SizedBox(height: 25),

            // Fee
            const Text(
              'Fee',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: textColor,
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: _buildTextFieldOnly(
                    hint: 'Fee',
                    icon: Icons.monetization_on_outlined,
                  ),
                ),
                const SizedBox(width: 15),
                const Padding(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    '(\$/hour)',
                    style: TextStyle(color: textColor, fontSize: 14),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Guide's Language
            _buildLabeledTextField(
              label: "Guide's Language",
              hint: 'Korean, English',
              icon: Icons.public,
            ),
            const SizedBox(height: 25),

            // Attractions Grid
            const Text(
              'Attractions',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: textColor,
              ),
            ),
            const SizedBox(height: 15),
            _buildAttractionsGrid(),
            const SizedBox(height: 30),
          ],
        ),
      ),
      // Nút DONE cố định ở dưới
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _isLoading ? null : () async {
                final location = _locationController.text.trim();
                final date = _dateController.text.trim();

                if (location.isEmpty || date.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Vui lòng nhập địa điểm và ngày!')),
                  );
                  return;
                }

                setState(() => _isLoading = true);

                final response = await ApiService.createTrip(location, date);

                if (!mounted) return;
                setState(() => _isLoading = false);

                if (response['success'] == true) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Tạo chuyến đi thành công!')),
                  );
                  Navigator.pop(context, true);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Lỗi: ${response['message'] ?? 'Không xác định'}')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              child: _isLoading 
                ? const SizedBox(
                    width: 20, 
                    height: 20, 
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                  )
                : const Text(
                    'DONE',
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

  // Helper 1: Label + TextField có gạch dưới
  Widget _buildLabeledTextField({
    required String label,
    required String hint,
    required IconData icon,
    TextEditingController? controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: textColor,
          ),
        ),
        _buildTextFieldOnly(hint: hint, icon: icon, controller: controller),
      ],
    );
  }

  // Helper 2: Chỉ vẽ TextField có gạch dưới
  Widget _buildTextFieldOnly({required String hint, required IconData icon, TextEditingController? controller}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: textColor),
        prefixIcon: Icon(icon, color: hintColor, size: 20),
        prefixIconConstraints: const BoxConstraints(minWidth: 30, minHeight: 0),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: 0.5),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: primaryColor, width: 2),
        ),
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 10),
      ),
    );
  }

  // Helper 3: Nút tăng giảm số lượng
  Widget _buildCounterButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Icon(icon, color: primaryColor, size: 24),
      ),
    );
  }

  // Helper 4: Lưới Attractions
  Widget _buildAttractionsGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        childAspectRatio: 1.5, // Tỉ lệ khung hình chữ nhật ngang
      ),
      itemCount: _attractions.length + 1, // +1 cho nút Add New
      itemBuilder: (context, index) {
        if (index == 0) {
          // Nút Add New
          return GestureDetector(
            onTap: () => _showAddAttractionDialog(context),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.add, color: primaryColor),
                  SizedBox(height: 5),
                  Text(
                    'Add New',
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        // Các thẻ Attraction
        final attr = _attractions[index - 1];
        return GestureDetector(
          onTap: () {
            setState(() {
              attr['selected'] = !attr['selected'];
            });
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: NetworkImage(attr['img']),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: [
                // Phủ mờ để đọc chữ
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.7),
                      ],
                    ),
                  ),
                ),
                // Tên địa điểm
                Positioned(
                  bottom: 10,
                  left: 10,
                  right: 10,
                  child: Text(
                    attr['name'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                // Icon Checkmark
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: attr['selected']
                          ? primaryColor
                          : Colors.black.withOpacity(0.3),
                    ),
                    padding: const EdgeInsets.all(2),
                    child: Icon(
                      Icons.check,
                      size: 14,
                      color: attr['selected'] ? Colors.white : Colors.white54,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showAddAttractionDialog(BuildContext context) {
    String newName = '';
    String newImg = '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Add New Attraction', 
            style: TextStyle(color: primaryColor, fontSize: 16, fontWeight: FontWeight.bold)
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(
                  hintText: 'Location Name',
                  isDense: true,
                ),
                onChanged: (val) => newName = val,
              ),
              const SizedBox(height: 15),
              TextField(
                decoration: const InputDecoration(
                  hintText: 'Image URL (https://...)',
                  isDense: true,
                ),
                onChanged: (val) => newImg = val,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                if (newName.trim().isNotEmpty && newImg.trim().isNotEmpty) {
                  setState(() {
                    _attractions.insert(0, {
                      'name': newName.trim(),
                      'img': newImg.trim(),
                      'selected': true,
                    });
                  });
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                elevation: 0,
              ),
              child: const Text('Add', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}
