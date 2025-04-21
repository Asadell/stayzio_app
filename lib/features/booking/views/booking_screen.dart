import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stayzio_app/features/booking/data/model/booking.dart';
import 'package:stayzio_app/features/booking/data/provider/booking_provider.dart';
import 'package:stayzio_app/features/hotel/data/model/hotel.dart';
import 'package:stayzio_app/features/hotel/data/provider/hotel_provider.dart';

@RoutePage()
class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final PageController _pageController = PageController();
  int _currentPageIndex = 0;
  String searchQuery = "";

  // Easter egg variable
  int _logoTapCount = 0;
  bool _showEasterEgg = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {
          _currentPageIndex = _tabController.index;
        });
        _pageController.animateToPage(
          _tabController.index,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });

    // Load bookings when screen initializes
    Future.microtask(() {
      // Assuming user ID 1 for now - in a real app you'd get this from auth
      final userId = 1;
      final bookingProvider =
          Provider.of<BookingProvider>(context, listen: false);
      bookingProvider.loadBookingsByStatus(userId);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _triggerEasterEgg() {
    _logoTapCount++;
    if (_logoTapCount >= 3) {
      setState(() {
        _showEasterEgg = true;
      });

      // Hide easter egg after 3 seconds
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            _showEasterEgg = false;
            _logoTapCount = 0;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: GestureDetector(
          onTap: _triggerEasterEgg,
          child: const Text(
            'My Booking',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Easter Egg
          if (_showEasterEgg)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.blue.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.celebration, color: Colors.amber),
                  const SizedBox(width: 8),
                  const Text(
                    "Selamat! Tim Stayzio telah menemukan Easter Egg! 🎉",
                    style: TextStyle(color: Colors.blue),
                  ),
                ],
              ),
            ),

          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search...',
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  suffixIcon: const Icon(Icons.tune, color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
              ),
            ),
          ),

          // Custom Tab Bar
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            padding: const EdgeInsets.all(4),
            height: 50,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(30),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey[400],
              labelStyle: const TextStyle(fontWeight: FontWeight.w600),
              unselectedLabelStyle:
                  const TextStyle(fontWeight: FontWeight.normal),
              labelPadding: const EdgeInsets.symmetric(horizontal: 8),
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              tabs: [
                Tab(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    alignment: Alignment.center,
                    child: const Text('Booked'),
                  ),
                ),
                Tab(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    alignment: Alignment.center,
                    child: const Text('History'),
                  ),
                ),
              ],
            ),
          ),

          // Page View for tab content
          Expanded(
            child: Consumer<BookingProvider>(
              builder: (context, bookingProvider, child) {
                if (bookingProvider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                // Filter bookings based on search query if needed
                final activeBookings = searchQuery.isEmpty
                    ? bookingProvider.activeBookings
                    : bookingProvider.activeBookings.where((booking) {
                        // Get the hotel to search through hotel details too
                        final hotelProvider =
                            Provider.of<HotelProvider>(context, listen: false);
                        final hotel = hotelProvider.hotels.firstWhere(
                            (h) => h.id == booking.hotelId,
                            orElse: () => Hotel(
                                name: "Unknown",
                                location: "Unknown",
                                pricePerNight: 0));

                        return hotel.name
                                .toLowerCase()
                                .contains(searchQuery.toLowerCase()) ||
                            hotel.location
                                .toLowerCase()
                                .contains(searchQuery.toLowerCase()) ||
                            booking.checkInDate
                                .toLowerCase()
                                .contains(searchQuery.toLowerCase()) ||
                            booking.checkOutDate
                                .toLowerCase()
                                .contains(searchQuery.toLowerCase());
                      }).toList();

                final historyBookings = searchQuery.isEmpty
                    ? bookingProvider.historyBookings
                    : bookingProvider.historyBookings.where((booking) {
                        // Get the hotel to search through hotel details too
                        final hotelProvider =
                            Provider.of<HotelProvider>(context, listen: false);
                        final hotel = hotelProvider.hotels.firstWhere(
                            (h) => h.id == booking.hotelId,
                            orElse: () => Hotel(
                                name: "Unknown",
                                location: "Unknown",
                                pricePerNight: 0));

                        return hotel.name
                                .toLowerCase()
                                .contains(searchQuery.toLowerCase()) ||
                            hotel.location
                                .toLowerCase()
                                .contains(searchQuery.toLowerCase()) ||
                            booking.checkInDate
                                .toLowerCase()
                                .contains(searchQuery.toLowerCase()) ||
                            booking.checkOutDate
                                .toLowerCase()
                                .contains(searchQuery.toLowerCase());
                      }).toList();

                return PageView(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPageIndex = index;
                      _tabController.animateTo(index);
                    });
                  },
                  children: [
                    // Booked Tab Content
                    activeBookings.isEmpty
                        ? _buildEmptyState("You don't have any active bookings")
                        : _buildBookingList(activeBookings),

                    // History Tab Content
                    historyBookings.isEmpty
                        ? _buildEmptyState("Your booking history is empty")
                        : _buildBookingList(historyBookings),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.hotel_outlined,
            size: 80,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              // Navigate to explore hotels screen
              // context.router.push(const ExploreRoute());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text("Find a Hotel"),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingList(List<Booking> bookings) {
    return Consumer<HotelProvider>(builder: (context, hotelProvider, child) {
      return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: bookings.length,
        itemBuilder: (context, index) {
          final booking = bookings[index];

          // Find the hotel from hotel provider using hotelId
          final hotel = hotelProvider.hotels.firstWhere(
              (h) => h.id == booking.hotelId,
              orElse: () => Hotel(
                  name: "Unknown Hotel",
                  location: "Location unavailable",
                  pricePerNight: 0.0));

          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hotel Image
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(16)),
                      child: hotel.imageUrl != null
                          ? Image.network(
                              hotel.imageUrl!,
                              height: 150,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  height: 150,
                                  width: double.infinity,
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.image,
                                      size: 50, color: Colors.grey),
                                );
                              },
                            )
                          : Container(
                              height: 150,
                              width: double.infinity,
                              color: Colors.grey[300],
                              child: const Icon(Icons.hotel,
                                  size: 50, color: Colors.grey),
                            ),
                    ),

                    // Status badge
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: _getStatusColor(booking.status),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          _capitalizeFirstLetter(booking.status),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),

                    // Easter Egg - Hidden message in random bookings
                    if (index == 0 && _showEasterEgg)
                      Positioned(
                        bottom: 12,
                        left: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            "🎁 You found a hidden message!",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),

                // Hotel Info
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Hotel Name and Rating
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              hotel.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (hotel.rating != null)
                            Row(
                              children: [
                                const Icon(Icons.star,
                                    color: Colors.amber, size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  '${hotel.rating}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                        ],
                      ),

                      const SizedBox(height: 4),

                      // Location
                      Row(
                        children: [
                          Icon(Icons.location_on,
                              size: 14, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              hotel.location,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      // Price
                      Text(
                        '\$${hotel.pricePerNight.toStringAsFixed(0)}/night',
                        style: const TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const Divider(height: 24),

                      // Booking Details
                      Row(
                        children: [
                          const Icon(Icons.calendar_today,
                              size: 14, color: Colors.blue),
                          const SizedBox(width: 8),
                          const Text(
                            'Dates',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '${booking.checkInDate} - ${booking.checkOutDate}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      // Guests
                      Row(
                        children: [
                          const Icon(Icons.person,
                              size: 14, color: Colors.blue),
                          const SizedBox(width: 8),
                          const Text(
                            'Guest',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '${booking.guests} Guests (1 Room)',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),

                      // Action buttons based on status
                      const SizedBox(height: 16),
                      _buildActionButtons(booking),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );
    });
  }

  Widget _buildActionButtons(Booking booking) {
    // Show different actions based on booking status
    if (booking.status == 'completed') {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          OutlinedButton.icon(
            onPressed: () {
              // Handle review action
            },
            icon: const Icon(Icons.star_border),
            label: const Text('Write a Review'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.blue,
              side: const BorderSide(color: Colors.blue),
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {
              // Handle booking again action
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Book Again'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      );
    } else if (booking.status == 'confirmed') {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          OutlinedButton.icon(
            onPressed: () {
              // Handle reschedule action
            },
            icon: const Icon(Icons.event),
            label: const Text('Reschedule'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.blue,
              side: const BorderSide(color: Colors.blue),
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {
              // Handle view details action
            },
            icon: const Icon(Icons.visibility),
            label: const Text('View Details'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      );
    } else if (booking.status == 'pending') {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          OutlinedButton.icon(
            onPressed: () {
              // Handle cancel action
            },
            icon: const Icon(Icons.close),
            label: const Text('Cancel'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.red,
              side: const BorderSide(color: Colors.red),
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {
              // Handle payment action
            },
            icon: const Icon(Icons.payment),
            label: const Text('Complete Payment'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      );
    } else {
      // cancelled or others
      return ElevatedButton.icon(
        onPressed: () {
          // Handle general action
        },
        icon: const Icon(Icons.hotel),
        label: const Text('Find Similar Hotels'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 40),
        ),
      );
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      case 'completed':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  String _capitalizeFirstLetter(String text) {
    if (text.isEmpty) return '';
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }
}
