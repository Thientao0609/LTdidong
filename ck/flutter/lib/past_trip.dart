import 'package:flutter/material.dart';
import 'services/past_trips_service.dart';

class PastTripsPage extends StatefulWidget {
  const PastTripsPage({super.key});

  @override
  State<PastTripsPage> createState() => _PastTripsPageState();
}

class _PastTripsPageState extends State<PastTripsPage> {
  List<dynamic> pastTrips = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchPastTrips();
  }

  Future<void> fetchPastTrips() async {
    try {
      final data = await PastTripsService.getPastTrips();
      setState(() {
        pastTrips = data;
        isLoading = false;
        errorMessage = null;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            errorMessage!,
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    if (pastTrips.isEmpty) {
      return RefreshIndicator(
        onRefresh: fetchPastTrips,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: const [
            SizedBox(height: 80),
            Center(child: Text("No past trips")),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: fetchPastTrips,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: pastTrips.length,
        itemBuilder: (context, index) {
          final trip = Map<String, dynamic>.from(pastTrips[index]);

          return Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: PastTripCard(trip: trip),
          );
        },
      ),
    );
  }
}

class PastTripCard extends StatelessWidget {
  final Map<String, dynamic> trip;

  const PastTripCard({
    super.key,
    required this.trip,
  });

  @override
  Widget build(BuildContext context) {
    final highlight = trip["highlight"] == true;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: highlight ? Border.all(color: Colors.blue, width: 2) : null,
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.06),
            blurRadius: 10,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(18),
            ),
            child: Image.network(
              trip["image"] ?? "",
              height: 135,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 135,
                  width: double.infinity,
                  color: Colors.grey.shade300,
                  alignment: Alignment.center,
                  child: const Icon(Icons.broken_image, color: Colors.grey),
                );
              },
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
                          const Icon(Icons.location_on,
                              size: 16, color: Color(0xff19c2a4)),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              trip["location"] ?? "",
                              style: const TextStyle(
                                color: Color(0xff19c2a4),
                                fontSize: 12,
                              ),
                            ),
                          ),
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
                      Row(
                        children: [
                          const Icon(Icons.calendar_today,
                              size: 14, color: Colors.grey),
                          const SizedBox(width: 6),
                          Text(
                            trip["date"] ?? "",
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
                          Text(
                            trip["time"] ?? "",
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.person,
                              size: 14, color: Colors.grey),
                          const SizedBox(width: 6),
                          Text(
                            trip["guide"] ?? "",
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xff19c2a4),
                      width: 3,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 24,
                    backgroundImage: NetworkImage(trip["avatar"] ?? ""),
                    onBackgroundImageError: (_, __) {},
                    child: (trip["avatar"] == null || trip["avatar"] == "")
                        ? const Icon(Icons.person)
                        : null,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}