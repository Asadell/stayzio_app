import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stayzio_app/features/hotel/data/model/hotel.dart';
import 'package:stayzio_app/features/hotel/data/model/hotel_facility.dart';
import 'package:stayzio_app/routes/app_route.dart';

@RoutePage()
class HotelDetailScreen extends StatelessWidget {
  final int hotelId;

  const HotelDetailScreen({
    super.key,
    @PathParam('hotelId') required this.hotelId,
  });

  @override
  Widget build(BuildContext context) {
    // Mock data for a hotel detail
    final hotel = Hotel(
      id: hotelId,
      name: 'The Aston Vill Hotel',
      location: 'Palm River, Michigan',
      pricePerNight: 120,
      rating: 4.7,
      description:
          'The ideal place for those looking for a luxurious and tranquil lake experience with stunning sea views...',
      imageUrl: 'assets/images/placeholder.png',
      facilities: [
        HotelFacility(hotelId: hotelId, facilityName: 'AC', facilityIcon: 'ac'),
        HotelFacility(
            hotelId: hotelId,
            facilityName: 'Restaurant',
            facilityIcon: 'restaurant'),
        HotelFacility(
            hotelId: hotelId,
            facilityName: 'Swimming Pool',
            facilityIcon: 'pool'),
        HotelFacility(
            hotelId: hotelId,
            facilityName: '24-Hours Front Desk',
            facilityIcon: 'desk'),
      ],
    );

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Detail',
                style: TextStyle(
                  color: Theme.of(context).primaryTextTheme.titleLarge?.color,
                ),
              ),
              background: Image.asset(
                hotel.imageUrl ?? 'assets/images/placeholder.jpg',
                fit: BoxFit.cover,
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => context.router.pop(),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () {},
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.local_hotel, color: Colors.blue),
                      const SizedBox(width: 8),
                      Text(
                        hotel.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.location_on,
                          size: 16, color: Colors.blue),
                      const SizedBox(width: 4),
                      Text(
                        hotel.location,
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      const Spacer(),
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text('${hotel.rating}'),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Hotel facilities
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Common Facilities',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text('See All'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Facility icons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: hotel.facilities?.map((facility) {
                          IconData iconData;
                          switch (facility.facilityIcon) {
                            case 'ac':
                              iconData = Icons.ac_unit;
                              break;
                            case 'restaurant':
                              iconData = Icons.restaurant;
                              break;
                            case 'pool':
                              iconData = Icons.pool;
                              break;
                            case 'desk':
                              iconData = Icons.support_agent;
                              break;
                            default:
                              iconData = Icons.hotel;
                          }

                          return Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.blue.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(iconData, color: Colors.blue),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                facility.facilityName,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          );
                        }).toList() ??
                        [],
                  ),

                  const SizedBox(height: 24),

                  // Description
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    hotel.description ?? 'No description available',
                    style: TextStyle(
                      color: Colors.grey[600],
                      height: 1.5,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                    ),
                    child: const Text('Read More'),
                  ),

                  const SizedBox(height: 16),

                  // Location
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Location',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text('Open Map'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.grey[200],
                    ),
                    child: Center(
                      child: Text(
                        'Map View',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Reviews section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Reviews',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text('See All'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Price
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Price'),
                          Text(
                            '\$${hotel.pricePerNight.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () {
                          context.router
                              .push(RequestToBookRoute(hotelId: hotel.id!));
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                          backgroundColor: Colors.blue,
                        ),
                        child: const Text(
                          'Booking Now',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
