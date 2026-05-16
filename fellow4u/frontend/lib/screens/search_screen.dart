import 'package:flutter/material.dart';
import '../core/constants.dart';
import 'guide_detail.dart';
import 'tour_detail.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _hasSearched = false; // Phân biệt giữa trang chưa tìm và đã tìm

  void _performSearch(String query) {
    if (query.trim().isNotEmpty) {
      setState(() {
        _hasSearched = true;
      });
    } else {
      setState(() {
        _hasSearched = false;
      });
    }
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _hasSearched = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Thanh tìm kiếm trên cùng (Header)
            _buildSearchBar(),

            // 2. Nội dung bên dưới (thay đổi tùy theo state _hasSearched)
            Expanded(
              child: _hasSearched
                  ? _buildSearchResults()
                  : _buildPopularDestinations(),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // 1. HEADER & SEARCH BAR
  // ==========================================
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          // Nút Close (X)
          IconButton(
            icon: const Icon(Icons.close, color: textColor),
            onPressed: () => Navigator.pop(context),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 15),

          // Ô nhập liệu tìm kiếm
          Expanded(
            child: Container(
              height: 45,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: TextField(
                controller: _searchController,
                onSubmitted: _performSearch,
                autofocus: true, // Tự động mở bàn phím khi vào trang
                decoration: InputDecoration(
                  hintText: 'Where you want to explore',
                  hintStyle: const TextStyle(color: hintColor, fontSize: 14),
                  border: InputBorder.none,
                  // Hiện nút (X) nhỏ để xóa khi đã có chữ
                  suffixIcon: _hasSearched
                      ? IconButton(
                          icon: const Icon(
                            Icons.cancel,
                            color: Colors.grey,
                            size: 20,
                          ),
                          onPressed: _clearSearch,
                        )
                      : null,
                ),
              ),
            ),
          ),

          // Nút Filter (chỉ hiện khi đã search ra kết quả)
          if (_hasSearched) ...[
            const SizedBox(width: 10),
            IconButton(
              icon: const Icon(Icons.tune, color: textColor),
              onPressed: _showFilterBottomSheet, // Mở Popup Lọc
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ],
      ),
    );
  }

  // ==========================================
  // 2. TRẠNG THÁI: CHƯA TÌM KIẾM (GỢI Ý)
  // ==========================================
  Widget _buildPopularDestinations() {
    final List<String> popularPlaces = [
      'Danang, Vietnam',
      'Ho Chi Minh, Vietnam',
      'Venice, Italy',
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Popular destinations',
            style: TextStyle(color: hintColor, fontSize: 13),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.separated(
              itemCount: popularPlaces.length,
              separatorBuilder: (context, index) => const SizedBox(height: 15),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    _searchController.text = popularPlaces[index];
                    _performSearch(popularPlaces[index]);
                  },
                  child: Text(
                    popularPlaces[index],
                    style: const TextStyle(
                      color: textColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
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

  // ==========================================
  // 3. TRẠNG THÁI: KẾT QUẢ TÌM KIẾM
  // ==========================================
  Widget _buildSearchResults() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Phần Guides
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Guides in Danang',
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
          _buildGuideGrid(),

          const SizedBox(height: 30),

          // Phần Tours
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Tours in Danang',
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
          _buildTourList(),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  // Lưới danh sách Guide (2 cột)
  Widget _buildGuideGrid() {
    final guides = [
      {
        'name': 'Tuan Tran',
        'img':
            'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format&fit=crop&q=80&w=300',
      },
      {
        'name': 'Linh Hana',
        'img':
            'https://images.unsplash.com/photo-1517841905240-472988babdf9?auto=format&fit=crop&q=80&w=300',
      },
      {
        'name': 'Kevin Smith',
        'img':
            'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&q=80&w=300',
      },
      {
        'name': 'Mai Anh',
        'img':
            'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&q=80&w=300',
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(), // Không cho cuộn độc lập
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        childAspectRatio: 0.8, // Chỉnh tỷ lệ để ảnh vừa vặn không bị cắt chữ
      ),
      itemCount: guides.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GuideDetailScreen(
                  name: guides[index]['name']!,
                  location: 'Danang, Vietnam',
                  avatar: guides[index]['img']!,
                ),
              ),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    guides[index]['img']!,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                guides[index]['name']!,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              Row(
                children: const [
                  Icon(Icons.location_on, size: 12, color: primaryColor),
                  Text(
                    'Danang, Vietnam',
                    style: TextStyle(fontSize: 11, color: primaryColor),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // Danh sách Tours cuộn dọc
  Widget _buildTourList() {
    return Column(
      children: [
        _buildTourCard(
          'Da Nang - Ba Na - Hoi An',
          '\$400.00',
          'https://images.unsplash.com/photo-1559592413-7cec4d0cae2b?auto=format&fit=crop&q=80&w=600',
        ),
        const SizedBox(height: 15),
        _buildTourCard(
          'Melbourne - Sydney',
          '\$600.00',
          'https://images.unsplash.com/photo-1514395462725-fb4566210144?auto=format&fit=crop&q=80&w=600',
        ),
        const SizedBox(height: 15),
        _buildTourCard(
          'Hanoi - Ha Long Bay',
          '\$300.00',
          'https://images.unsplash.com/photo-1528127269322-539801943592?auto=format&fit=crop&q=80&w=600',
        ),
      ],
    );
  }

  Widget _buildTourCard(String title, String price, String imgUrl) {
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Icon(
                        Icons.favorite_border,
                        color: primaryColor,
                        size: 20,
                      ),
                      const SizedBox(height: 5),
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
      ),
    );
  }

  // ==========================================
  // 4. BOTTOM SHEET: BỘ LỌC (FILTER)
  // ==========================================
  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Cho phép bottom sheet bung cao hơn
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return const FilterBottomSheet();
      },
    );
  }
}

// Widget Tách rời cho Filter Bottom Sheet để code đỡ rối
class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  int _tabIndex = 0; // 0: Guides, 1: Tours
  List<String> _selectedLanguages = ['Vietnamese']; // Mặc định chọn Tiếng Việt

  final List<String> _languages = [
    'Vietnamese',
    'English',
    'Korean',
    'Spanish',
    'French',
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Padding để tránh bị che bởi bàn phím nếu có
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: 20,
        left: 20,
        right: 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Tự động co giãn theo nội dung
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: X và chữ Filters
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const Expanded(
                child: Center(
                  child: Text(
                    'Filters',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(width: 24), // Cân bằng không gian với icon Close
            ],
          ),
          const SizedBox(height: 25),

          // Nút Toggle (Guides / Tours)
          Container(
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                Expanded(child: _buildToggleButton(0, 'Guides')),
                Expanded(child: _buildToggleButton(1, 'Tours')),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Date Filter
          const Text(
            "Date",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          TextField(
            decoration: const InputDecoration(
              hintText: 'mm/dd/yy',
              hintStyle: TextStyle(color: hintColor),
              prefixIcon: Icon(
                Icons.calendar_today,
                color: hintColor,
                size: 18,
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: primaryColor),
              ),
            ),
          ),
          const SizedBox(height: 25),

          // Guide's Language
          const Text(
            "Guide's Language",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: _languages.map((lang) {
              final isSelected = _selectedLanguages.contains(lang);
              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      _selectedLanguages.remove(lang);
                    } else {
                      _selectedLanguages.add(lang);
                    }
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? primaryColor : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected ? primaryColor : Colors.grey.shade300,
                    ),
                  ),
                  child: Text(
                    lang,
                    style: TextStyle(
                      color: isSelected ? Colors.white : textColor,
                      fontSize: 12,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 25),

          // Fee
          const Text(
            "Fee",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          Row(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 10),
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: const Center(
                  child: Text('\$', style: TextStyle(color: hintColor)),
                ),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Fee',
                    hintStyle: TextStyle(color: hintColor),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: primaryColor),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              const Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text(
                  '(\$/hour)',
                  style: TextStyle(color: hintColor, fontSize: 14),
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),

          // Nút Apply
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'APPLY FILTERS',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildToggleButton(int index, String title) {
    bool isActive = _tabIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _tabIndex = index),
      child: Container(
        decoration: BoxDecoration(
          color: isActive ? primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: isActive ? Colors.white : textColor,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
