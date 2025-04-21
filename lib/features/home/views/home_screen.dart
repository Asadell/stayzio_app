import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stayzio_app/features/hotel/data/provider/hotel_provider.dart'; // Import the provider
import 'package:stayzio_app/routes/app_route.dart';

@RoutePage()
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<HotelProvider>().loadHotels();
      context.read<HotelProvider>().loadTop3PopularHotels();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Matt Kohler',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Text(
              'San Diego, CA',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundImage: const AssetImage('assets/images/john.png'),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
        ],
      ),
      body: Consumer<HotelProvider>(
        builder: (context, hotelProvider, child) {
          // Loading indicator while data is being fetched
          if (hotelProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Location selector
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.location_on, color: Colors.blue),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'You Can Change Your Location to',
                                style: TextStyle(fontSize: 12),
                              ),
                              Text(
                                'show nearby offers',
                                style:
                                    TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_right),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Popular section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Most Popular',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text('See All'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Popular hotels
                  SizedBox(
                    height: 220,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: hotelProvider.popularHotels.length,
                      itemBuilder: (context, index) {
                        final hotel = hotelProvider.popularHotels[index];
                        return GestureDetector(
                          onTap: () {
                            context.router
                                .push(HotelDetailRoute(hotelId: hotel.id!));
                          },
                          child: Container(
                            width: 160,
                            margin: const EdgeInsets.only(right: 12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade200),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(12),
                                      topRight: Radius.circular(12),
                                    ),
                                    child: Image.network(
                                      hotel.imageUrl ??
                                          'https://example.com/placeholder.jpg', // Use a URL or fallback image URL
                                      height: 120,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    )),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        hotel.name,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        hotel.location,
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[600]),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Rp ${hotel.pricePerNight ~/ 1000}rb/night',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12),
                                          ),
                                          Row(
                                            children: [
                                              const Icon(Icons.star,
                                                  color: Colors.amber,
                                                  size: 14),
                                              const SizedBox(width: 2),
                                              Text(
                                                '${hotel.rating}',
                                                style: const TextStyle(
                                                    fontSize: 12),
                                              ),
                                            ],
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
                      },
                    ),
                  ),

                  const SizedBox(height: 24),
                  Container(
                    margin: const EdgeInsets.only(top: 24, bottom: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Hotel Near You',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            TextButton(
                              onPressed: () {
                                context.router
                                    .push(const NearbyHotelMapRoute());
                              },
                              child: const Text('Open Map',
                                  style: TextStyle(color: Colors.blue)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () {
                            context.router.push(const NearbyHotelMapRoute());
                          },
                          child: Container(
                            height: 160,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 4,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  // Map image
                                  Image.asset(
                                    'assets/images/mapsnearme.png',
                                    fit: BoxFit.cover,
                                  ),

                                  // Gradient overlay to make text more readable if needed
                                  Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.center,
                                        colors: [
                                          Colors.black.withOpacity(0.3),
                                          Colors.transparent,
                                        ],
                                      ),
                                    ),
                                  ),

                                  // Hotel markers
                                  Positioned(
                                    top: 60,
                                    left: 80,
                                    child: Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: Colors.blue,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: Colors.white, width: 2),
                                      ),
                                      child: const Icon(
                                        Icons.hotel,
                                        size: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),

                                  // User location marker
                                  Positioned(
                                    top: 90,
                                    left: 150,
                                    child: Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: Colors.white, width: 2),
                                      ),
                                      child: const Icon(
                                        Icons.my_location,
                                        size: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),

                                  // Another hotel marker
                                  Positioned(
                                    top: 40,
                                    right: 70,
                                    child: Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: Colors.blue,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: Colors.white, width: 2),
                                      ),
                                      child: const Icon(
                                        Icons.hotel,
                                        size: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        // Nearest hotels preview (optional, include if you want to show 1-2 closest hotels)
                        if (hotelProvider.hotels.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          ...hotelProvider.hotels.take(2).map(
                                (hotel) => GestureDetector(
                                  onTap: () {
                                    // Navigate to hotel detail screen
                                    // If using auto_route:
                                    // context.router.push(HotelDetailRoute(hotelId: hotel.id!));
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(bottom: 12),
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                          color: Colors.grey.shade200),
                                    ),
                                    child: Row(
                                      children: [
                                        // Hotel image
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: hotel.imageUrl != null
                                              ? Image.network(
                                                  hotel.imageUrl!,
                                                  width: 60,
                                                  height: 60,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (context, error,
                                                      stackTrace) {
                                                    return Container(
                                                      width: 60,
                                                      height: 60,
                                                      color: Colors.grey[300],
                                                      child: const Icon(
                                                          Icons.hotel),
                                                    );
                                                  },
                                                )
                                              : Container(
                                                  width: 60,
                                                  height: 60,
                                                  color: Colors.grey[300],
                                                  child:
                                                      const Icon(Icons.hotel),
                                                ),
                                        ),
                                        const SizedBox(width: 12),

                                        // Hotel details
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      hotel.name,
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  if (hotel.rating != null)
                                                    Container(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 8,
                                                          vertical: 4),
                                                      decoration: BoxDecoration(
                                                        color: Colors.grey[200],
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          const Icon(Icons.star,
                                                              color:
                                                                  Colors.amber,
                                                              size: 14),
                                                          Text(
                                                            ' ${hotel.rating}',
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        12),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                ],
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                hotel.location,
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey[600],
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                'Rp ${hotel.pricePerNight ~/ 1000}rb/night',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.blue,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Recommended section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Recommended for you',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text('See All'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Recommended hotels list
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: hotelProvider.hotels.length,
                    itemBuilder: (context, index) {
                      final hotel = hotelProvider.hotels[index];
                      return GestureDetector(
                        onTap: () {
                          context.router
                              .push(HotelDetailRoute(hotelId: hotel.id!));
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  bottomLeft: Radius.circular(12),
                                ),
                                child: Image.network(
                                  hotel.imageUrl ??
                                      'https://example.com/placeholder.jpg', // Fallback image
                                  height: 120,
                                  width: 120, // Set a fixed width for the image
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Expanded(
                                // Ensure the text takes the remaining space
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        hotel.name,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                      Text(
                                        hotel.location,
                                        style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 12),
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Rp ${hotel.pricePerNight ~/ 1000}rb/night',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Row(
                                            children: [
                                              const Icon(Icons.star,
                                                  color: Colors.amber,
                                                  size: 16),
                                              Text('${hotel.rating}'),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
