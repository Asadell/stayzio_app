import 'dart:async';
import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:stayzio_app/features/hotel/data/model/hotel.dart';
import 'package:stayzio_app/features/hotel/data/provider/hotel_provider.dart';
import 'package:stayzio_app/features/utils/currency_utils.dart';

@RoutePage()
class NearbyHotelMapScreen extends StatefulWidget {
  const NearbyHotelMapScreen({super.key});

  @override
  State<NearbyHotelMapScreen> createState() => _NearbyHotelMapScreenState();
}

class _NearbyHotelMapScreenState extends State<NearbyHotelMapScreen>
    with SingleTickerProviderStateMixin {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  // Default location (can be adjusted to your preferred starting point)
  double latitude = -7.2804494;
  double longitude = 112.7947228;

  MapType mapType = MapType.normal;
  Position? devicePosition;
  String searchQuery = "";

  // Selected hotel details
  bool showHotelDetails = false;
  Hotel? selectedHotel;

  // Markers set
  Set<Marker> _markers = {};

  // Easter egg variables
  bool _easterEggActivated = false;
  late AnimationController _easterEggAnimController;
  final List<String> _easterEggMessages = [
    "Liburan santai... 😎",
    "Tempat baru menunggu!",
    "Stayzio selalu ada untuk Anda",
    "Penginapan terbaik di kota!",
    "Jangan lupa rating kami ya! ⭐",
  ];
  int _easterEggTapCount = 0;

  // Page controller for hotel slider
  final PageController _pageController = PageController(viewportFraction: 0.85);

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
    // Load hotels from provider
    Future.microtask(() {
      context.read<HotelProvider>().loadHotels();
      _initializeMarkers();
    });

    // Setup easter egg animation
    _easterEggAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    _easterEggAnimController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _requestLocationPermission() async {
    await Geolocator.requestPermission();
    getCurrentPosition();
  }

  void _initializeMarkers() {
    final hotelProvider = Provider.of<HotelProvider>(context, listen: false);

    setState(() {
      _markers = hotelProvider.hotels.map((hotel) {
        return Marker(
          markerId: MarkerId(hotel.id.toString()),
          position:
              LatLng(hotel.latitude ?? latitude, hotel.longitude ?? longitude),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
          infoWindow:
              InfoWindow(title: hotel.name, snippet: '${hotel.rating} ★'),
          onTap: () {
            _selectHotel(hotel);
            // Find index of the selected hotel in the list
            final index = hotelProvider.hotels.indexOf(hotel);
            if (index != -1) {
              _pageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            }
          },
        );
      }).toSet();
    });
  }

  void _selectHotel(Hotel hotel) {
    setState(() {
      selectedHotel = hotel;
      showHotelDetails = true;
    });

    _animateToPosition(
        hotel.latitude ?? latitude, hotel.longitude ?? longitude);
  }

  void _triggerEasterEgg() {
    _easterEggTapCount++;

    if (_easterEggTapCount >= 5) {
      setState(() {
        _easterEggActivated = true;
      });
      _easterEggAnimController.forward(from: 0.0);

      // Automatically hide easter egg after 3 seconds
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            _easterEggActivated = false;
          });
          _easterEggTapCount = 0;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<HotelProvider>(
        builder: (context, hotelProvider, child) {
          if (hotelProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Stack(
            children: [
              // Google Map
              _buildGoogleMap(),

              // App Bar
              _buildAppBar(),

              // Search Bar
              _buildSearchBar(),

              // Hotel Slider
              _buildHotelSlider(hotelProvider),

              // Easter Egg Animation
              if (_easterEggActivated) _buildEasterEgg(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildGoogleMap() {
    return GoogleMap(
      mapType: mapType,
      initialCameraPosition: CameraPosition(
        target: LatLng(latitude, longitude),
        zoom: 14,
      ),
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      },
      markers: _markers,
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      compassEnabled: false,
    );
  }

  Widget _buildAppBar() {
    return Positioned(
      top: 40,
      left: 10,
      right: 10,
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          Expanded(
            child: Center(
              child: GestureDetector(
                onTap: _triggerEasterEgg,
                child: const Text(
                  "Nearby Hotel",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.more_horiz),
              onPressed: () {
                _showMapTypeMenu();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Positioned(
      top: 90,
      left: 16,
      right: 16,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              spreadRadius: 1,
            ),
          ],
        ),
        child: TextField(
          decoration: InputDecoration(
            hintText: 'Search...',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: IconButton(
              icon: const Icon(Icons.tune),
              onPressed: () {
                // Show filters
              },
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 15),
          ),
          onChanged: (value) {
            setState(() {
              searchQuery = value;
            });
          },
        ),
      ),
    );
  }

  Widget _buildHotelSlider(HotelProvider hotelProvider) {
    return Positioned(
      bottom: 20,
      left: 0,
      right: 0,
      height: 180,
      child: PageView.builder(
        controller: _pageController,
        itemCount: hotelProvider.hotels.length,
        onPageChanged: (index) {
          final hotel = hotelProvider.hotels[index];
          _selectHotel(hotel);
        },
        itemBuilder: (context, index) {
          final hotel = hotelProvider.hotels[index];

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Hotel Info Section
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        // Hotel Image
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: hotel.imageUrl != null
                              ? Image.network(
                                  hotel.imageUrl!,
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: 80,
                                      height: 80,
                                      color: Colors.grey[300],
                                      child:
                                          const Icon(Icons.image_not_supported),
                                    );
                                  },
                                )
                              : Container(
                                  width: 80,
                                  height: 80,
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.hotel),
                                ),
                        ),
                        const SizedBox(width: 12),
                        // Hotel Details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                  Row(
                                    children: [
                                      const Icon(Icons.star,
                                          color: Colors.amber, size: 16),
                                      Text(
                                        " ${hotel.rating}",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.location_on,
                                      size: 14, color: Colors.grey),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      hotel.location,
                                      style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 12),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "${formatRupiah(hotel.pricePerNight)}/night",
                                style: const TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Booking Now Button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // Handle booking action
                          _showBookingConfirmation(hotel);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text(
                          "Booking Now",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),

                  // Chat Button
                  TextButton.icon(
                    onPressed: () {
                      // Handle chat action
                    },
                    icon: const Icon(Icons.chat_bubble_outline, size: 16),
                    label: const Text("Chat with Agent"),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showMapTypeMenu() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.map),
                title: const Text('Normal'),
                onTap: () {
                  setState(() {
                    mapType = MapType.normal;
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.satellite),
                title: const Text('Satellite'),
                onTap: () {
                  setState(() {
                    mapType = MapType.satellite;
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.terrain),
                title: const Text('Terrain'),
                onTap: () {
                  setState(() {
                    mapType = MapType.terrain;
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.view_compact),
                title: const Text('Hybrid'),
                onTap: () {
                  setState(() {
                    mapType = MapType.hybrid;
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<Position?> getCurrentPosition() async {
    Position? currentPosition;

    try {
      currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        devicePosition = currentPosition;
        latitude = currentPosition!.latitude;
        longitude = currentPosition.longitude;
      });

      _animateToPosition(currentPosition.latitude, currentPosition.longitude);
    } catch (e) {
      print("Error getting location: $e");
    }

    return currentPosition;
  }

  Future<void> _animateToPosition(double lat, double lng) async {
    final GoogleMapController controller = await _controller.future;
    final CameraPosition newPosition = CameraPosition(
      target: LatLng(lat, lng),
      zoom: 15,
    );
    controller.animateCamera(CameraUpdate.newCameraPosition(newPosition));
  }

  Widget _buildEasterEgg() {
    // Easter egg animation that appears when user taps "Nearby Hotel" text 5 times
    final randomMessage =
        _easterEggMessages[Random().nextInt(_easterEggMessages.length)];

    return AnimatedBuilder(
        animation: _easterEggAnimController,
        builder: (context, child) {
          return Positioned(
            top: 140,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TweenAnimationBuilder(
                      tween: Tween<double>(begin: 0, end: 2 * pi),
                      duration: const Duration(seconds: 2),
                      builder: (_, double value, __) {
                        return Transform.rotate(
                          angle: value,
                          child: const Icon(
                            Icons.hotel,
                            color: Colors.white,
                            size: 24,
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 12),
                    Text(
                      randomMessage,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  void _showBookingConfirmation(Hotel hotel) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Booking"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Are you sure you want to book ${hotel.name}?"),
            const SizedBox(height: 8),
            Text("${formatRupiah(hotel.pricePerNight)}/night",
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            // Easter egg secret code that appears in the booking dialog
            Text(
              "Booking code: STAY${Random().nextInt(1000)}X",
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
            Text(
              "Psst! Type 'STAYCATION2025' for 10% off! 🤫",
              style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 10,
                  fontStyle: FontStyle.italic),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Show success message
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content:
                      Text("Booking successful! Check your email for details."),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text("Confirm"),
          ),
        ],
      ),
    );
  }
}
