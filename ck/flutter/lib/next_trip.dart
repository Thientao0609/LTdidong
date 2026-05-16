import 'package:flutter/material.dart';
import 'services/next_trips_service.dart';
import 'next_trip_detail_page.dart';
import 'payment.dart';

class NextTripsPage extends StatefulWidget {
  const NextTripsPage({super.key});

  @override
  State<NextTripsPage> createState() => _NextTripsPageState();
}

class _NextTripsPageState extends State<NextTripsPage> {
  List<dynamic> nextTrips = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchNextTrips();
  }

  Future<void> fetchNextTrips() async {
    try {
      final data = await NextTripsService.getNextTrips();
      setState(() {
        nextTrips = data;
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

    if (nextTrips.isEmpty) {
      return RefreshIndicator(
        onRefresh: fetchNextTrips,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: const [
            SizedBox(height: 80),
            Center(child: Text("No next trips")),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: fetchNextTrips,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: nextTrips.length,
        itemBuilder: (context, index) {
          final trip = Map<String, dynamic>.from(nextTrips[index]);

          return Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: _tripCard(context, trip),
          );
        },
      ),
    );
  }

  Widget _tripCard(BuildContext context, Map<String, dynamic> trip) {
    final List<dynamic> buttons = List<dynamic>.from(trip["buttons"] ?? []);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
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
          Stack(
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(18)),
                child: Image.network(
                  trip["image"] ?? "",
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 120,
                      width: double.infinity,
                      color: Colors.grey.shade300,
                      alignment: Alignment.center,
                      child: const Icon(Icons.broken_image, color: Colors.grey),
                    );
                  },
                ),
              ),
              if (trip["badge"] != null)
                Positioned(
                  left: 10,
                  top: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      trip["badge"].toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ),
              const Positioned(
                right: 10,
                top: 10,
                child: Icon(Icons.more_horiz, color: Colors.white),
              )
            ],
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
                      const SizedBox(height: 4),
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
                      const SizedBox(height: 3),
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
                      const SizedBox(height: 3),
                      Text(
                        trip["status"] ?? "",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: buttons.map((b) {
                          final buttonText = b.toString();

                          return OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xff19c2a4),
                              side: const BorderSide(
                                color: Color(0xff19c2a4),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 6,
                              ),
                            ),
                            onPressed: () {
                              if (buttonText == "Detail") {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => NextTripDetailPage(
                                      tripId: trip["id"],
                                    ),
                                  ),
                                );
                              } else if (buttonText == "Chat") {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Chat feature is coming soon"),
                                  ),
                                );
                              } else if (buttonText == "Pay") {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const PaymentPage(),
                                  ),
                                );
                              }
                            },
                            child: Text(buttonText),
                          );
                        }).toList(),
                      )
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