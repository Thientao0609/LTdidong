import 'package:flutter/material.dart';
import 'next_trip.dart';
import 'past_trip.dart';
import 'wish_list.dart';
import 'services/my_trips_service.dart';
import 'trip_detail_page.dart';

class MyTripsPage extends StatefulWidget {
  const MyTripsPage({super.key});

  @override
  State<MyTripsPage> createState() => _MyTripsPageState();
}

class _MyTripsPageState extends State<MyTripsPage> {
  String tab = "Current Trips";

  List<dynamic> currentTrips = [];
  bool isLoadingTrips = true;
  String? tripsError;

  @override
  void initState() {
    super.initState();
    fetchCurrentTrips();
  }

  Future<void> fetchCurrentTrips() async {
    try {
      final data = await MyTripsService.getCurrentTrips();
      setState(() {
        currentTrips = data;
        isLoadingTrips = false;
        tripsError = null;
      });
    } catch (e) {
      setState(() {
        isLoadingTrips = false;
        tripsError = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff4f6fb),
      body: Column(
        children: [
          /// ===== HEADER =====
          Stack(
            children: [
              Image.network(
                "https://res.cloudinary.com/dtcc4spyv/image/upload/v1776238139/banner_explore_lqmlpd.png",
                height: 160,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 160,
                    width: double.infinity,
                    color: Colors.grey.shade300,
                    alignment: Alignment.center,
                    child: const Icon(Icons.broken_image, color: Colors.grey),
                  );
                },
              ),
              Container(
                height: 160,
                color: Colors.black.withOpacity(.3),
              ),
              const Positioned(
                left: 20,
                bottom: 20,
                child: Text(
                  "My Trips",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          /// ===== TABS =====
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  _tab("Current Trips"),
                  _tab("Next Trips"),
                  _tab("Past Trips"),
                  _tab("Wish List"),
                ],
              ),
            ),
          ),

          /// ===== TAB CONTENT =====
          Expanded(
            child: _buildTabContent(),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _tab(String name) {
    final bool active = tab == name;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: GestureDetector(
        onTap: () {
          setState(() {
            tab = name;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: active ? Colors.teal : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            name,
            style: TextStyle(
              color: active ? Colors.white : Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    if (tab == "Next Trips") {
      return const NextTripsPage();
    }

    if (tab == "Past Trips") {
      return const PastTripsPage();
    }

    if (tab == "Wish List") {
      return const WishListPage();
    }

    if (isLoadingTrips) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (tripsError != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            tripsError!,
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    if (currentTrips.isEmpty) {
      return RefreshIndicator(
        onRefresh: fetchCurrentTrips,
        child: ListView(
          children: const [
            SizedBox(height: 120),
            Center(child: Text("No current trips")),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: fetchCurrentTrips,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: currentTrips.length,
        itemBuilder: (context, index) {
          final trip = Map<String, dynamic>.from(currentTrips[index]);

          return Padding(
            padding: const EdgeInsets.only(bottom: 18),
            child: _tripCard(trip),
          );
        },
      ),
    );
  }

  Widget _tripCard(Map<String, dynamic> trip) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
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
          /// IMAGE
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
            child: Stack(
              children: [
                Image.network(
                  trip["image"] ?? "",
                  height: 130,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 130,
                      width: double.infinity,
                      color: Colors.grey.shade300,
                      alignment: Alignment.center,
                      child: const Icon(Icons.broken_image, color: Colors.grey),
                    );
                  },
                ),
                Positioned(
                  right: 12,
                  bottom: 10,
                  child: CircleAvatar(
                    radius: 22,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(trip["avatar"] ?? ""),
                      onBackgroundImageError: (_, __) {},
                      child: (trip["avatar"] == null || trip["avatar"] == "")
                          ? const Icon(Icons.person)
                          : null,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.location_on,
                        size: 16, color: Colors.teal),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        trip["location"] ?? "",
                        style: const TextStyle(
                          color: Colors.teal,
                          fontSize: 13,
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  trip["title"] ?? "",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "${trip["date"] ?? ""} • ${trip["time"] ?? ""}",
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        final id = trip["id"];
                        if (id == null) return;

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TripDetailPage(tripId: id),
                          ),
                        );
                      },
                      child: const Text("Detail"),
                    ),
                    const SizedBox(width: 10),
                    OutlinedButton(
                      onPressed: () {},
                      child: const Text("Chat"),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}