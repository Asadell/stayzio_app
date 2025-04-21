import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:stayzio_app/features/auth/data/provider/auth_provider.dart';
import 'package:stayzio_app/features/booking/data/model/booking.dart';
import 'package:stayzio_app/features/booking/data/model/payment_card.dart';
import 'package:stayzio_app/features/booking/data/provider/booking_provider.dart';
import 'package:stayzio_app/features/booking/data/provider/payment_card_provider.dart';
import 'package:stayzio_app/features/hotel/data/model/hotel.dart';
import 'package:stayzio_app/features/hotel/data/provider/hotel_provider.dart';
import 'package:stayzio_app/features/utils/currency_utils.dart';
import 'package:stayzio_app/features/utils/format_date_utils.dart';
import 'package:stayzio_app/features/utils/get_month_name_utils.dart';
import 'package:stayzio_app/routes/app_route.dart';

@RoutePage()
class CheckoutScreen extends StatefulWidget {
  final int hotelId;
  final DateTime checkInDate;
  final DateTime checkOutDate;
  final int guests;
  final double totalPayment;

  const CheckoutScreen({
    super.key,
    @PathParam('hotelId') required this.hotelId,
    required this.checkInDate,
    required this.checkOutDate,
    required this.guests,
    required this.totalPayment,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  // Mock payment cards
  final List<PaymentCard> paymentCards = [
    PaymentCard(
      id: 1,
      userId: 1,
      cardNumber: '5412 7534 9801 2345',
      cardHolderName: 'Matt Kohler',
      expiryDate: '12/26',
      cardType: 'mastercard',
      isDefault: 1,
    ),
    PaymentCard(
      id: 2,
      userId: 1,
      cardNumber: '4123 5678 9012 3456',
      cardHolderName: 'Matt Kohler',
      expiryDate: '09/27',
      cardType: 'visa',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    String selectedCard = 'mastercard'; // 'mastercard' or 'visa'
    final formattedCheckIn =
        '${widget.checkInDate.day} ${getMonthName(widget.checkInDate.month)} ${widget.checkInDate.year}';
    final formattedCheckOut =
        '${widget.checkOutDate.day} ${getMonthName(widget.checkOutDate.month)} ${widget.checkOutDate.year}';

    // Calculate total price
    final totalPrice = widget.totalPayment;
    final adminFee = 2500;
    final totalAmount = totalPrice + adminFee;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hotel info
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        context
                                .watch<HotelProvider>()
                                .selectedHotel!
                                .imageUrl ??
                            'assets/images/placeholder.png',
                        height: 80,
                        width: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.star,
                                  color: Colors.amber, size: 16),
                              const SizedBox(width: 4),
                              Text(
                                  '${context.watch<HotelProvider>().selectedHotel!.rating}'),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            context.watch<HotelProvider>().selectedHotel!.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            context
                                .watch<HotelProvider>()
                                .selectedHotel!
                                .location,
                            style: TextStyle(
                                color: Colors.grey[600], fontSize: 12),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${formatRupiah(context.watch<HotelProvider>().selectedHotel!.pricePerNight)}/night',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              const Text(
                'Your Booking',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // Booking details
              Row(
                children: [
                  const Icon(Icons.calendar_today,
                      size: 20, color: Colors.blue),
                  const SizedBox(width: 8),
                  const Text(
                    'Dates',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  Text(
                      '${formatDate(widget.checkInDate)} - ${formatDate(widget.checkOutDate)}'),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.person, size: 20, color: Colors.blue),
                  const SizedBox(width: 8),
                  const Text(
                    'Guest',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  Text('${widget.guests} Guest(s) (1 Room)'),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.hotel, size: 20, color: Colors.blue),
                  const SizedBox(width: 8),
                  const Text(
                    'Room type',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  Text('Standard Room'),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.phone, size: 20, color: Colors.blue),
                  const SizedBox(width: 8),
                  const Text(
                    'Phone',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  const Text('0214345646'),
                ],
              ),

              const SizedBox(height: 24),
              const Text(
                'Price Details',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // Price breakdown
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Price'),
                  Text(formatRupiah(totalPrice)),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Admin fee'),
                  Text(formatRupiah(adminFee.toDouble())),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total price'),
                  Text(formatRupiah(totalAmount)),
                ],
              ),

              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    _showPaymentCardSelection(context);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Select Card',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  int? selectedCardId; // Tambahkan variabel untuk menyimpan kartu yang dipilih

  void _showPaymentCardSelection(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            // Dapatkan daftar kartu dari provider
            final cards = context.watch<PaymentCardProvider>().cards;

            return Container(
              padding: const EdgeInsets.all(24.0),
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.75,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Payment Method',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),

                  Expanded(
                    child: cards.isEmpty
                        ? const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.credit_card_off,
                                    size: 64, color: Colors.grey),
                                SizedBox(height: 16),
                                Text(
                                  "You don't have any cards yet",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  "Add a card to continue with booking",
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            itemCount: cards.length +
                                1, // +1 for "Add new card" option
                            itemBuilder: (context, index) {
                              // Add new card option at the end
                              if (index == cards.length) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 16.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                      context.router
                                          .push(const AddNewCardRoute());
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.grey.shade300),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            height: 40,
                                            width: 40,
                                            decoration: BoxDecoration(
                                              color:
                                                  Colors.blue.withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: const Icon(Icons.add,
                                                color: Colors.blue),
                                          ),
                                          const SizedBox(width: 16),
                                          const Text(
                                            'Add Debit Card',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }

                              // Card options
                              final card = cards[index];
                              return Padding(
                                padding: const EdgeInsets.only(top: 16.0),
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedCardId = card.id;
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: selectedCardId == card.id
                                            ? Colors.blue
                                            : Colors.grey.shade300,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          card.cardType == 'visa'
                                              ? 'assets/images/visa.png'
                                              : 'assets/images/mastercard.png',
                                          height: 40,
                                          width: 40,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return Container(
                                              height: 40,
                                              width: 40,
                                              color: Colors.grey[300],
                                              child: Icon(Icons.credit_card,
                                                  color: card.cardType == 'visa'
                                                      ? Colors.blue
                                                      : Colors.deepOrange),
                                            );
                                          },
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                card.cardType == 'visa'
                                                    ? 'VISA'
                                                    : 'MASTERCARD',
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                card.cardNumber,
                                                style: TextStyle(
                                                    color: Colors.grey[600],
                                                    fontSize: 12),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Radio<int?>(
                                          value: card.id,
                                          groupValue: selectedCardId,
                                          onChanged: (value) {
                                            setState(() {
                                              selectedCardId = value;
                                            });
                                          },
                                          activeColor: Colors.blue,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),

                  // Confirm button
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: cards.isEmpty
                            ? () {
                                Navigator.pop(context);
                                context.router.push(const AddNewCardRoute());
                              }
                            : selectedCardId != null
                                ? () {
                                    Navigator.pop(context);
                                    // Process payment with selected card
                                    _processPayment(context);
                                  }
                                : null,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          disabledBackgroundColor: Colors.grey.shade300,
                        ),
                        child: Text(
                          cards.isEmpty ? 'Add New Card' : 'Confirm and Pay',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _processPayment(BuildContext context) {
    // Akses Provider yang dibutuhkan
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final bookingProvider =
        Provider.of<BookingProvider>(context, listen: false);
    final hotelProvider = Provider.of<HotelProvider>(context, listen: false);

    // Validasi data user
    final userId = authProvider.currentUser?.id;
    if (userId == null) {
      Fluttertoast.showToast(
        msg: "Please login to continue",
        backgroundColor: Colors.redAccent,
        textColor: Colors.white,
        gravity: ToastGravity.TOP,
      );
      return;
    }

    // Validasi hotel data
    final hotel = hotelProvider.selectedHotel;
    if (hotel == null || hotel.id == null) {
      Fluttertoast.showToast(
        msg: "Hotel information is missing",
        backgroundColor: Colors.redAccent,
        textColor: Colors.white,
        gravity: ToastGravity.TOP,
      );
      return;
    }

    // Tampilkan dialog loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Processing payment...'),
            ],
          ),
        );
      },
    );

    // Hitung admin fee dan total
    const adminFee = 2500.0;
    final totalPrice = widget.totalPayment;
    final totalAmount = totalPrice + adminFee;

    // Buat booking object
    final booking = Booking(
      userId: userId,
      hotelId: hotel.id!,
      checkInDate:
          widget.checkInDate.toString().split(' ')[0], // Format YYYY-MM-DD
      checkOutDate:
          widget.checkOutDate.toString().split(' ')[0], // Format YYYY-MM-DD
      guests: widget.guests,
      roomType: 'Standard Room', // Sesuaikan dengan pilihan user jika ada
      totalPrice: totalAmount,
      adminFee: adminFee,
      status: 'confirmed', // Set status awal
      paymentMethodId: selectedCardId, // Card ID yang sudah dipilih
      createdAt: DateTime.now().toString(),
    );

    // Proses booking menggunakan provider
    bookingProvider.createBooking(booking).then((success) {
      Navigator.pop(context); // Tutup dialog loading

      if (success) {
        // Booking berhasil - tampilkan notifikasi sukses
        Fluttertoast.showToast(
          msg: "Booking confirmed successfully!",
          backgroundColor: Colors.green,
          textColor: Colors.white,
          gravity: ToastGravity.TOP,
        );

        // Tampilkan dialog sukses
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Booking Successful'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check_circle, color: Colors.green, size: 48),
                const SizedBox(height: 16),
                const Text('Your booking has been confirmed!'),
                const SizedBox(height: 8),
                Text('Hotel: ${hotel.name}'),
                Text('Check-in: ${formatDate(widget.checkInDate)}'),
                Text('Check-out: ${formatDate(widget.checkOutDate)}'),
                Text('Total amount: ${formatRupiah(totalAmount)}'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  // Navigate back to home
                  context.router.push(const MainRoute());
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } else {
        // Booking gagal - tampilkan notifikasi error
        Fluttertoast.showToast(
          msg: "Failed to confirm booking. Please try again.",
          backgroundColor: Colors.redAccent,
          textColor: Colors.white,
          gravity: ToastGravity.TOP,
        );
      }
    }).catchError((error) {
      Navigator.pop(context); // Tutup dialog loading
      Fluttertoast.showToast(
        msg: "An error occurred: ${error.toString()}",
        backgroundColor: Colors.redAccent,
        textColor: Colors.white,
        gravity: ToastGravity.TOP,
      );
    });
  }
}
