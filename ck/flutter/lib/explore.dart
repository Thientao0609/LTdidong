import 'dart:async';
import 'package:flutter/material.dart';
import 'services/explore_service.dart';
import 'TourMore.dart';
import 'trip_detail_page.dart';
import 'item_detail_page.dart';



class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final PageController _pageController = PageController();
  final TextEditingController _searchController = TextEditingController();

  int _currentBanner = 0;
  Timer? _timer;

  List<dynamic> banners = [];

  List<dynamic> journeys = [];
  List<dynamic> guides = [];
  List<dynamic> experiences = [];
  List<dynamic> tours = [];
  List<dynamic> news = [];

  List<dynamic> allJourneys = [];
  List<dynamic> allGuides = [];
  List<dynamic> allExperiences = [];
  List<dynamic> allTours = [];
  List<dynamic> allNews = [];

  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchExploreData();
  }

  Future<void> fetchExploreData() async {
    try {
      final data = await ExploreService.getExploreData();

      final loadedBanners = List<dynamic>.from(data['banners'] ?? []);
      final loadedJourneys = List<dynamic>.from(data['journeys'] ?? []);
      final loadedGuides = List<dynamic>.from(data['guides'] ?? []);
      final loadedExperiences = List<dynamic>.from(data['experiences'] ?? []);
      final loadedTours = List<dynamic>.from(data['tours'] ?? []);
      final loadedNews = List<dynamic>.from(data['news'] ?? []);

      setState(() {
        banners = loadedBanners;

        allJourneys = loadedJourneys;
        allGuides = loadedGuides;
        allExperiences = loadedExperiences;
        allTours = loadedTours;
        allNews = loadedNews;

        journeys = loadedJourneys;
        guides = loadedGuides;
        experiences = loadedExperiences;
        tours = loadedTours;
        news = loadedNews;

        isLoading = false;
      });

      if (banners.isNotEmpty) {
        _autoSlide();
      }
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  void _onSearchChanged(String query) {
    final q = query.trim().toLowerCase();

    setState(() {
      if (q.isEmpty) {
        journeys = List<dynamic>.from(allJourneys);
        guides = List<dynamic>.from(allGuides);
        experiences = List<dynamic>.from(allExperiences);
        tours = List<dynamic>.from(allTours);
        news = List<dynamic>.from(allNews);
        return;
      }

      journeys = allJourneys.where((item) {
        final map = Map<String, dynamic>.from(item);
        final title = (map['title'] ?? '').toString().toLowerCase();
        return title.contains(q);
      }).toList();

      guides = allGuides.where((item) {
        final map = Map<String, dynamic>.from(item);
        final name = (map['name'] ?? '').toString().toLowerCase();
        final role = (map['role'] ?? '').toString().toLowerCase();
        return name.contains(q) || role.contains(q);
      }).toList();

      experiences = allExperiences.where((item) {
        final map = Map<String, dynamic>.from(item);
        final title = (map['title'] ?? '').toString().toLowerCase();
        final name = (map['name'] ?? '').toString().toLowerCase();
        final location = (map['location'] ?? '').toString().toLowerCase();
        return title.contains(q) || name.contains(q) || location.contains(q);
      }).toList();

      tours = allTours.where((item) {
        final map = Map<String, dynamic>.from(item);
        final title = (map['title'] ?? '').toString().toLowerCase();
        final date = (map['date'] ?? '').toString().toLowerCase();
        final days = (map['days'] ?? '').toString().toLowerCase();
        return title.contains(q) || date.contains(q) || days.contains(q);
      }).toList();

      news = allNews.where((item) {
        final map = Map<String, dynamic>.from(item);
        final title = (map['title'] ?? '').toString().toLowerCase();
        final date = (map['date'] ?? '').toString().toLowerCase();
        return title.contains(q) || date.contains(q);
      }).toList();
    });
  }

  void _autoSlide() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (_pageController.hasClients && banners.isNotEmpty) {
        setState(() {
          _currentBanner = (_currentBanner + 1) % banners.length;
        });

        _pageController.animateToPage(
          _currentBanner,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Widget _netImage(
    String url, {
    double? height,
    double? width,
    BoxFit fit = BoxFit.cover,
  }) {
    return Image.network(
      url,
      height: height,
      width: width,
      fit: fit,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          height: height,
          width: width,
          color: Colors.grey.shade200,
          alignment: Alignment.center,
          child: const CircularProgressIndicator(strokeWidth: 2),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return Container(
          height: height,
          width: width,
          color: Colors.grey.shade300,
          alignment: Alignment.center,
          child: const Icon(Icons.broken_image, color: Colors.grey),
        );
      },
    );
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
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              errorMessage!,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xfff4f6fb),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: fetchExploreData,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    _banner(),
                    Positioned(
                      left: 16,
                      right: 16,
                      bottom: -26,
                      child: _searchBar(),
                    ),
                  ],
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 40)),
              SliverToBoxAdapter(child: _sectionTitle("Top Journeys")),
              SliverToBoxAdapter(child: _topJourneys()),
              SliverToBoxAdapter(child: _sectionTitle("Best Guides")),
              SliverToBoxAdapter(child: _guides()),
              SliverToBoxAdapter(child: _sectionTitle("Top Experiences")),
              SliverToBoxAdapter(child: _experiences()),
              SliverToBoxAdapter(child: _sectionTitle("Featured Tours")),
              SliverToBoxAdapter(child: _tours()),
              SliverToBoxAdapter(child: _sectionTitle("Travel News")),
              SliverToBoxAdapter(child: _news()),
              const SliverToBoxAdapter(child: SizedBox(height: 30)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _banner() {
    if (banners.isEmpty) {
      return Container(
        height: 230,
        color: Colors.grey.shade300,
        alignment: Alignment.center,
        child: const Text("No banners"),
      );
    }

    return SizedBox(
      height: 230,
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: banners.length,
            onPageChanged: (i) {
              setState(() {
                _currentBanner = i;
              });
            },
            itemBuilder: (_, index) {
              final banner = banners[index];
              final imageUrl = banner is Map ? (banner["image"] ?? "") : "";

              return _netImage(
                imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 230,
              );
            },
          ),
          Container(color: Colors.black.withOpacity(0.3)),
          const Positioned(
            left: 16,
            bottom: 70,
            child: Text(
              "Explore",
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Positioned(
            right: 16,
            top: 20,
            child: Text(
              "Da Nang",
              style: TextStyle(color: Colors.white),
            ),
          ),
          const Positioned(
            right: 16,
            top: 40,
            child: Row(
              children: [
                Icon(Icons.cloud, color: Colors.white),
                SizedBox(width: 6),
                Text(
                  "26°C",
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 10,
            right: 16,
            child: Row(
              children: List.generate(
                banners.length,
                (i) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: _currentBanner == i ? 18 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _searchBar() {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.1),
            blurRadius: 10,
          )
        ],
      ),
      child: TextField(
        controller: _searchController,
        onChanged: _onSearchChanged,
        decoration: InputDecoration(
          icon: const Icon(Icons.search, color: Colors.grey),
          hintText: "Hi, where do you want to explore?",
          hintStyle: const TextStyle(color: Colors.grey),
          border: InputBorder.none,
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.close, color: Colors.grey),
                  onPressed: () {
                    _searchController.clear();
                    _onSearchChanged('');
                  },
                )
              : null,
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          GestureDetector(
            onTap: text == "Best Guides" ? null : () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TourMore()),
              );
            },
            child: Text(
              "SEE MORE",
              style: TextStyle(
                color: text == "Best Guides" ? Colors.grey : Colors.teal,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _topJourneys() {
    if (journeys.isEmpty) {
      return const SizedBox(
        height: 80,
        child: Center(child: Text("No journeys")),
      );
    }

    return SizedBox(
      height: 240,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: journeys.length,
        itemBuilder: (_, i) {
          final item = Map<String, dynamic>.from(journeys[i]);

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TripDetailPage(tripId: item["id"]),
                ),
              );
            },
            child: Container(
              width: 210,
              margin: const EdgeInsets.only(right: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: i == 0 ? Border.all(color: Colors.blue, width: 2) : null,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.08),
                    blurRadius: 10,
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(18)),
                  child: Stack(
                    children: [
                      _netImage(
                        item["image"] ?? "",
                        height: 120,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                      const Positioned(
                        right: 10,
                        top: 10,
                        child: Icon(
                          Icons.bookmark_border,
                          color: Colors.white,
                        ),
                      ),
                      Positioned(
                        left: 10,
                        bottom: 8,
                        child: Row(
                          children: const [
                            Icon(Icons.star, color: Colors.amber, size: 16),
                            Icon(Icons.star, color: Colors.amber, size: 16),
                            Icon(Icons.star, color: Colors.amber, size: 16),
                            Icon(Icons.star, color: Colors.amber, size: 16),
                            Icon(Icons.star, color: Colors.amber, size: 16),
                            SizedBox(width: 6),
                            Text(
                              "1247 likes",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item["title"] ?? "",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today,
                              size: 14, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            item["date"] ?? "",
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.access_time,
                              size: 14, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            item["days"] ?? "",
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        (item["price"] ?? "").toString(),
                        style: const TextStyle(
                          color: Colors.teal,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },

      ),
    );
  }

  Widget _guides() {
    if (guides.isEmpty) {
      return const SizedBox(
        height: 80,
        child: Center(child: Text("No guides")),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: guides.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 18,
          crossAxisSpacing: 14,
          childAspectRatio: 1.1,
        ),
        itemBuilder: (_, i) {
          final g = Map<String, dynamic>.from(guides[i]);

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ItemDetailPage(
                    title: g["name"] ?? "",
                    image: g["image"] ?? "",
                    subtitle: g["role"],
                  ),
                ),
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: _netImage(
                    g["image"] ?? "",
                    height: 130,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  g["name"] ?? "",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: const [
                    Icon(Icons.star, color: Colors.amber, size: 16),
                    Icon(Icons.star, color: Colors.amber, size: 16),
                    Icon(Icons.star, color: Colors.amber, size: 16),
                    Icon(Icons.star, color: Colors.amber, size: 16),
                    Icon(Icons.star, color: Colors.amber, size: 16),
                    SizedBox(width: 4),
                    Text(
                      "127 Reviews",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    )
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.location_on, color: Colors.teal, size: 16),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        g["role"] ?? "",
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.teal,
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _experiences() {
    if (experiences.isEmpty) {
      return const SizedBox(
        height: 80,
        child: Center(child: Text("No experiences")),
      );
    }

    return SizedBox(
      height: 250,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: experiences.length,
        itemBuilder: (_, i) {
          final e = Map<String, dynamic>.from(experiences[i]);

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ItemDetailPage(
                    title: e["title"] ?? "",
                    image: e["image"] ?? "",
                    subtitle: e["location"],
                  ),
                ),
              );
            },
            child: Container(
              width: 210,
              margin: const EdgeInsets.only(right: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: _netImage(
                          e["image"] ?? "",
                          height: 150,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        bottom: -25,
                        left: 16,
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 28,
                              backgroundColor: Colors.white,
                              child: CircleAvatar(
                                radius: 25,
                                backgroundImage:
                                    NetworkImage(e["avatar"] ?? ""),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.teal,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                e["name"] ?? "",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 35),
                  Text(
                    e["title"] ?? "",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.location_on,
                          size: 16, color: Colors.teal),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          e["location"] ?? "",
                          style: const TextStyle(
                            color: Colors.teal,
                            fontSize: 13,
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _tours() {
    if (tours.isEmpty) {
      return const SizedBox(
        height: 80,
        child: Center(child: Text("No tours")),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: tours.asMap().entries.map((entry) {
          final i = entry.key;
          final tour = Map<String, dynamic>.from(entry.value);

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TripDetailPage(tripId: tour["id"]),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 18),

            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: i == 0 ? Border.all(color: Colors.blue, width: 2) : null,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.08),
                  blurRadius: 10,
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(18)),
                  child: Stack(
                    children: [
                      _netImage(
                        tour["image"] ?? "",
                        height: 170,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                      Positioned(
                        right: 10,
                        top: 10,
                        child: GestureDetector(
                          onTap: () async {
                            final id = tour["id"];
                            if (id != null) {
                              try {
                                await ExploreService.toggleSaveTour(id);
                              } catch (_) {}
                            }

                            setState(() {
                              final current = tours[i]["saved"] ?? false;
                              tours[i]["saved"] = !current;
                            });
                          },
                          child: Icon(
                            (tours[i]["saved"] ?? false)
                                ? Icons.bookmark
                                : Icons.bookmark_border,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 10,
                        bottom: 8,
                        child: Row(
                          children: const [
                            Icon(Icons.star, color: Colors.amber, size: 16),
                            Icon(Icons.star, color: Colors.amber, size: 16),
                            Icon(Icons.star, color: Colors.amber, size: 16),
                            Icon(Icons.star, color: Colors.amber, size: 16),
                            Icon(Icons.star, color: Colors.amber, size: 16),
                            SizedBox(width: 6),
                            Text(
                              "1247 likes",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    tour["title"] ?? "",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    final id = tour["id"];
                                    if (id != null) {
                                      try {
                                        await ExploreService.toggleLikeTour(id);
                                      } catch (_) {}
                                    }

                                    setState(() {
                                      final current = tours[i]["liked"] ?? false;
                                      tours[i]["liked"] = !current;
                                    });
                                  },
                                  child: Icon(
                                    (tours[i]["liked"] ?? false)
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: Colors.teal,
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const Icon(Icons.calendar_today,
                                    size: 14, color: Colors.grey),
                                const SizedBox(width: 6),
                                Text(
                                  tour["date"] ?? "",
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.access_time,
                                    size: 14, color: Colors.grey),
                                const SizedBox(width: 6),
                                Text((tour["days"] ?? "").toString()),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Text(
                        (tour["price"] ?? "").toString(),
                        style: const TextStyle(
                          color: Colors.teal,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      }).toList(),

      ),
    );
  }

  Widget _news() {
    if (news.isEmpty) {
      return const SizedBox(
        height: 80,
        child: Center(child: Text("No news")),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: news.map((item) {
          final n = Map<String, dynamic>.from(item);

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ItemDetailPage(
                    title: n["title"] ?? "",
                    image: n["image"] ?? "",
                    subtitle: n["date"],
                  ),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                Text(
                  n["title"] ?? "",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  n["date"] ?? "",
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: _netImage(
                    n["image"] ?? "",
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                )
              ],
            ),
          ),
        );
      }).toList(),

      ),
    );
  }
}