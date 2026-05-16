import 'package:flutter/material.dart';

class WishListPage extends StatelessWidget {
  const WishListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [

        WishCard(
          image: "assets/MelbourneSydney.png",
          title: "Melbourne - Sydney",
          date: "Jan 30, 2020",
          days: "3 days",
          price: "\$600.00",
          liked: true,
        ),

        SizedBox(height: 20),

        WishCard(
          image: "assets/HanoiHaLongBay.png",
          title: "Hanoi - Ha Long Bay",
          date: "Jan 30, 2020",
          days: "3 days",
          price: "\$300.00",
          liked: false,
        ),
      ],
    );
  }
}

class WishCard extends StatelessWidget {
  final String image;
  final String title;
  final String date;
  final String days;
  final String price;
  final bool liked;

  const WishCard({
    super.key,
    required this.image,
    required this.title,
    required this.date,
    required this.days,
    required this.price,
    required this.liked,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.08),
            blurRadius: 10,
          )
        ],
      ),
      child: Column(
        children: [

          /// IMAGE
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(18),
            ),
            child: Stack(
              children: [

                Image.asset(
                  image,
                  height: 170,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),

                /// bookmark
                Positioned(
                  right: 12,
                  top: 12,
                  child: Icon(
                    Icons.bookmark,
                    color: Colors.white,
                  ),
                ),

                /// rating
                Positioned(
                  left: 12,
                  bottom: 10,
                  child: Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 18),
                      const Icon(Icons.star, color: Colors.amber, size: 18),
                      const Icon(Icons.star, color: Colors.amber, size: 18),
                      const Icon(Icons.star, color: Colors.amber, size: 18),
                      const Icon(Icons.star, color: Colors.amber, size: 18),
                      const SizedBox(width: 6),
                      const Text(
                        "1247 likes",
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),

          /// INFO
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [

                /// LEFT
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 6),

                      Row(
                        children: [
                          const Icon(Icons.calendar_today,
                              size: 14, color: Colors.grey),
                          const SizedBox(width: 6),
                          Text(date),
                        ],
                      ),

                      const SizedBox(height: 4),

                      Row(
                        children: [
                          const Icon(Icons.access_time,
                              size: 14, color: Colors.grey),
                          const SizedBox(width: 6),
                          Text(days),
                        ],
                      ),
                    ],
                  ),
                ),

                /// RIGHT
                Column(
                  children: [

                    Icon(
                      liked
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: Colors.teal,
                    ),

                    const SizedBox(height: 20),

                    Text(
                      price,
                      style: const TextStyle(
                        color: Colors.teal,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
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