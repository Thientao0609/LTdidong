import 'package:flutter/material.dart';
import 'services/next_trips_service.dart';

class NextTripDetailPage extends StatefulWidget {
  final dynamic tripId;

  const NextTripDetailPage({super.key, required this.tripId});

  @override
  State<NextTripDetailPage> createState() => _NextTripDetailPageState();
}

class _NextTripDetailPageState extends State<NextTripDetailPage> {
  Map<String, dynamic>? tripDetail;
  bool isLoading = true;
  String selectedDay = "Day 1";

  @override
  void initState() {
    super.initState();
    fetchTripDetail();
  }

  Future<void> fetchTripDetail() async {
    try {
      final data = await NextTripsService.getNextTripDetail(widget.tripId);
      setState(() {
        tripDetail = data;
        isLoading = false;
      });
    } catch (_) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (tripDetail == null) {
      return const Scaffold(
        body: Center(child: Text("Trip detail not found")),
      );
    }

    final summary = Map<String, dynamic>.from(tripDetail!["summary"] ?? {});
    final schedule = List<dynamic>.from(tripDetail!["schedule"] ?? []);
    final policies = List<dynamic>.from(tripDetail!["policies"] ?? []);

    final selectedSchedule = schedule.firstWhere(
      (item) => "Day ${item["day"]}" == selectedDay,
      orElse: () => schedule.isNotEmpty ? schedule.first : {},
    );

    final blocks = List<dynamic>.from(
      (selectedSchedule is Map ? selectedSchedule["timeBlocks"] : []) ?? [],
    );

    return Scaffold(
      backgroundColor: const Color(0xfff4f6fb),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Image.network(
                    tripDetail?["image"] ?? "",
                    height: 210,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 210,
                        width: double.infinity,
                        color: Colors.grey.shade300,
                        alignment: Alignment.center,
                        child: const Icon(Icons.broken_image, color: Colors.grey),
                      );
                    },
                  ),
                  Positioned(
                    top: 12,
                    left: 12,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.black),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                transform: Matrix4.translationValues(0, -18, 0),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22),
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
                          Text(
                            tripDetail!["title"] ?? "",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Text(
                                "\$${(tripDetail!["price"] as num).toStringAsFixed(2)}",
                                style: const TextStyle(
                                  color: Colors.teal,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(width: 8),
                              if (tripDetail!["oldPrice"] != null)
                                Text(
                                  "\$${(tripDetail!["oldPrice"] as num).toStringAsFixed(2)}",
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            tripDetail!["provider"] ?? "",
                            style: const TextStyle(color: Colors.teal),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    _card(
                      title: "Summary",
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _summaryRow("From", summary["from"] ?? ""),
                          _summaryRow("Duration", summary["duration"] ?? ""),
                          _summaryRow("Departure Date", summary["departureDate"] ?? ""),
                          _summaryRow("Departure Place", summary["departurePlace"] ?? ""),
                          _summaryRow("Destination", summary["destination"] ?? ""),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    _card(
                      title: "Schedule",
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: schedule.map((item) {
                              final label = "Day ${item["day"]}";
                              final active = selectedDay == label;

                              return Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: ChoiceChip(
                                  label: Text(label),
                                  selected: active,
                                  onSelected: (_) {
                                    setState(() {
                                      selectedDay = label;
                                    });
                                  },
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            selectedSchedule["title"] ?? "",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.teal,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ...blocks.map((block) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 70,
                                    child: Text(
                                      block["time"] ?? "",
                                      style: const TextStyle(
                                        color: Colors.teal,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          block["title"] ?? "",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(block["description"] ?? ""),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    _card(
                      title: "Policy",
                      child: Column(
                        children: policies.map((item) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(child: Text(item["label"] ?? "")),
                                Text(
                                  item["price"] == 0
                                      ? "Free"
                                      : "\$${(item["price"] as num).toStringAsFixed(2)}",
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {},
                        child: const Text(
                          "BOOK THIS TOUR",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _card({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
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
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}