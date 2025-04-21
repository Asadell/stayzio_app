import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:stayzio_app/features/booking/data/model/booking.dart';
import 'package:stayzio_app/features/hotel/data/model/hotel.dart';

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

  // Mock hotel data
  final List<Hotel> hotels = [
    Hotel(
      id: 1,
      name: 'The Aston Vill Hotel',
      location: 'Vaum Point, Michaloton',
      pricePerNight: 120.0,
      rating: 4.7,
      imageUrl: 'assets/images/hotel1.jpg',
    ),
    Hotel(
      id: 2,
      name: 'Mystic Palms',
      location: 'Palm Springs, CA',
      pricePerNight: 230.0,
      rating: 4.0,
      imageUrl: 'assets/images/hotel2.jpg',
    ),
    Hotel(
      id: 3,
      name: 'Elysian Suites',
      location: 'San Diego, CA',
      pricePerNight: 185.0,
      rating: 3.8,
      imageUrl: 'assets/images/hotel3.jpg',
    ),
  ];

  // Mock booking data
  final List<Booking> bookedBookings = [
    Booking(
      userId: 1,
      hotelId: 1,
      checkInDate: '12 Nov 2024',
      checkOutDate: '14 Nov 2024',
      guests: 2,
      totalPrice: 120.0,
      status: 'confirmed',
    ),
    Booking(
      userId: 1,
      hotelId: 2,
      checkInDate: '20 Nov 2024',
      checkOutDate: '25 Nov 2024',
      guests: 1,
      totalPrice: 230.0,
      status: 'confirmed',
    ),
    Booking(
      userId: 1,
      hotelId: 3,
      checkInDate: '10 Dec 2024',
      checkOutDate: '15 Dec 2024',
      guests: 3,
      totalPrice: 185.0,
      status: 'confirmed',
    ),
  ];

  final List<Booking> historyBookings = [
    Booking(
      userId: 1,
      hotelId: 3,
      checkInDate: '5 Oct 2024',
      checkOutDate: '8 Oct 2024',
      guests: 2,
      totalPrice: 185.0,
      status: 'completed',
    ),
  ];

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
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'My Booking',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
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
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPageIndex = index;
                  _tabController.animateTo(index);
                });
              },
              children: [
                // Booked Tab Content
                _buildBookingList(bookedBookings),

                // History Tab Content
                _buildBookingList(historyBookings),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingList(List<Booking> bookings) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        final booking = bookings[index];
        final hotel = hotels.firstWhere((h) => h.id == booking.hotelId);

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
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.asset(
                  hotel.imageUrl ?? 'assets/images/placeholder.jpg',
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 150,
                      width: double.infinity,
                      color: Colors.grey[300],
                      child:
                          const Icon(Icons.image, size: 50, color: Colors.grey),
                    );
                  },
                ),
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
                        Text(
                          hotel.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.star,
                                color: Colors.amber, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              '${hotel.rating}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
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
                        Text(
                          hotel.location,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
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
                        const Icon(Icons.person, size: 14, color: Colors.blue),
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
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
