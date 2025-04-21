import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:stayzio_app/features/hotel/data/provider/hotel_provider.dart';
import 'package:stayzio_app/features/utils/currency_utils.dart';
import 'package:stayzio_app/routes/app_route.dart';

@RoutePage()
class HotelDetailScreen extends StatefulWidget {
  final int hotelId;

  const HotelDetailScreen({
    super.key,
    @PathParam('hotelId') required this.hotelId,
  });

  @override
  State<HotelDetailScreen> createState() => _HotelDetailScreenState();
}

class _HotelDetailScreenState extends State<HotelDetailScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<HotelProvider>().getHotelById(widget.hotelId);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Mock data for a hotel detail

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
              background: Image.network(
                context.watch<HotelProvider>().selectedHotel!.imageUrl ??
                    'assets/images/placeholder.jpg',
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
                      Expanded(
                        child: Text(
                          context.watch<HotelProvider>().selectedHotel!.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
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
                        context.watch<HotelProvider>().selectedHotel!.location,
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      const Spacer(),
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text(
                          '${context.watch<HotelProvider>().selectedHotel!.rating}'),
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
                    children: context
                            .watch<HotelProvider>()
                            .selectedHotel!
                            .facilities
                            ?.map((facility) {
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
                    context.watch<HotelProvider>().selectedHotel!.description ??
                        'No description available',
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
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Price'),
                            Text(
                              '${formatRupiah(context.watch<HotelProvider>().selectedHotel!.pricePerNight)}/night',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          final hotelProvider = Provider.of<HotelProvider>(
                              context,
                              listen: false);
                          if (hotelProvider.selectedHotel != null) {
                            final hotelId = hotelProvider.selectedHotel!.id!;
                            context.router
                                .push(RequestToBookRoute(hotelId: hotelId));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text('Hotel data is not available')),
                            );
                          }
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
