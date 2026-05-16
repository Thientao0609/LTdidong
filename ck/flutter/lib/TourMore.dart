import 'package:flutter/material.dart';
import 'services/tour_more_service.dart';
import 'trip_detail_page.dart';


class TourMore extends StatefulWidget {
  const TourMore({super.key});

  @override
  State<TourMore> createState() => _TourMoreState();
}

class _TourMoreState extends State<TourMore> {
  List<Map<String, dynamic>> filteredTours = [];
  Map<String, dynamic>? banner;
  final TextEditingController _searchController = TextEditingController();

  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchTourMoreData();
  }

  Future<void> fetchTourMoreData({String query = ''}) async {
    try {
      final data = await TourMoreService.getTourMoreData(query: query);

      setState(() {
        banner = Map<String, dynamic>.from(data['banner'] ?? {});
        filteredTours = List<Map<String, dynamic>>.from(data['tours'] ?? []);
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  void _searchTours(String query) {
    fetchTourMoreData(query: query);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (errorMessage != null) {
      return Scaffold(
        body: Center(child: Text(errorMessage!)),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Stack(
              children: [
                Image.network(
                  banner?['image'] ?? '',
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: double.infinity,
                    height: 200,
                    color: Colors.grey[300],
                  ),
                ),
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.1),
                          Colors.black.withOpacity(0.6),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 30,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      banner?['title'] ?? '',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            blurRadius: 10,
                            color: Colors.black54,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: _searchTours,
                  decoration: InputDecoration(
                    hintText: 'Search tours...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              _searchController.clear();
                              _searchTours('');
                            },
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: filteredTours.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              TripDetailPage(tripId: filteredTours[index]['id']),
                        ),
                      );
                    },
                    child: TourCard(
                      tour: filteredTours[index],
                      onToggleFavorite: () async {
                        final id = filteredTours[index]['id'];
                        await TourMoreService.toggleFavorite(id);
                        setState(() {
                          filteredTours[index]['favorite'] =
                              !(filteredTours[index]['favorite'] ?? false);
                        });
                      },
                    ),
                  );
                },
              ),
            ),

          ],
        ),
      ),
    );
  }
}

class TourCard extends StatelessWidget {
  final Map<String, dynamic> tour;
  final VoidCallback onToggleFavorite;

  const TourCard({
    super.key,
    required this.tour,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    final hasRating = tour['rating'] != null;
    final ratingValue = hasRating ? (tour['rating'] as num).floor() : 0;

    return Container(
      height: 240,
      margin: const EdgeInsets.only(bottom: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              tour['image'],
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: Colors.grey[300],
                child: const Icon(Icons.broken_image,
                    size: 80, color: Colors.grey),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7)
                  ],
                  stops: const [0.3, 1.0],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${tour['from']} - ${tour['to']}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.calendar_today,
                              color: Colors.white70, size: 18),
                          const SizedBox(width: 6),
                          Text(
                            '${tour['days']} days',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 16),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            '\$${(tour['price'] as num).toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 16),
                          GestureDetector(
                            onTap: onToggleFavorite,
                            child: Icon(
                              tour['favorite']
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: tour['favorite']
                                  ? Colors.red
                                  : Colors.white,
                              size: 28,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  if (hasRating) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: List.generate(5, (i) {
                        return Icon(
                          i < ratingValue
                              ? Icons.star
                              : Icons.star_border,
                          color: Colors.amber,
                          size: 20,
                        );
                      }),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}