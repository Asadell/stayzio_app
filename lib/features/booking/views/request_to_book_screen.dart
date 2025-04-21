import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:stayzio_app/features/hotel/data/model/hotel.dart';
import 'package:stayzio_app/features/hotel/data/provider/hotel_provider.dart';
import 'package:stayzio_app/features/utils/currency_utils.dart';
import 'package:stayzio_app/routes/app_route.dart';

@RoutePage()
class RequestToBookScreen extends StatefulWidget {
  final int hotelId;

  const RequestToBookScreen({
    super.key,
    @PathParam('hotelId') required this.hotelId,
  });

  @override
  State<RequestToBookScreen> createState() => _RequestToBookScreenState();
}

class _RequestToBookScreenState extends State<RequestToBookScreen> {
  DateTime checkInDate = DateTime.now().add(const Duration(days: 7));
  DateTime checkOutDate = DateTime.now().add(const Duration(days: 9));
  int guests = 1;
  String paymentMethod = 'FastPayz';

  @override
  Widget build(BuildContext context) {
    // Calculate total payment
    final int nights = checkOutDate.difference(checkInDate).inDays;
    final hotel = context.watch<HotelProvider>().selectedHotel;
    final double pricePerNight = hotel?.pricePerNight ?? 0;
    final double totalPrice = pricePerNight * nights;
    const double cleaningFee = 5.0;
    const double serviceFee = 5.0;
    final double totalPayment = totalPrice + cleaningFee + serviceFee;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Request to book'),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Date',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      // Memunculkan dialog kalender untuk memilih tanggal check-in
                      final selectedDate = await showDatePicker(
                        context: context,
                        initialDate: checkInDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (selectedDate != null && selectedDate != checkInDate) {
                        setState(() {
                          checkInDate = selectedDate;
                          // Resetkan check-out jika check-in lebih baru
                          if (checkOutDate.isBefore(checkInDate)) {
                            checkOutDate =
                                checkInDate.add(const Duration(days: 2));
                          }
                        });
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Check - In',
                            style: TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.calendar_today, size: 16),
                              const SizedBox(width: 8),
                              Text(
                                '${checkInDate.day} ${_getMonthName(checkInDate.month)}, ${checkInDate.year}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      // Memunculkan dialog kalender untuk memilih tanggal check-out
                      final selectedDate = await showDatePicker(
                        context: context,
                        initialDate: checkOutDate,
                        firstDate: checkInDate.add(const Duration(days: 1)),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (selectedDate != null &&
                          selectedDate != checkOutDate) {
                        setState(() {
                          checkOutDate = selectedDate;
                        });
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Check - Out',
                            style: TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.calendar_today, size: 16),
                              const SizedBox(width: 8),
                              Text(
                                '${checkOutDate.day} ${_getMonthName(checkOutDate.month)}, ${checkOutDate.year}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Guest',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        if (guests > 1) {
                          setState(() {
                            guests--;
                          });
                        }
                      },
                      icon: const Icon(Icons.remove_circle_outline),
                      color: Colors.blue,
                    ),
                    Text(
                      '$guests',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          guests++;
                        });
                      },
                      icon: const Icon(Icons.add_circle_outline),
                      color: Colors.blue,
                    ),
                  ],
                ),
              ],
            ),
            // const SizedBox(height: 24),
            // const Text(
            //   'Pay With',
            //   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            // ),
            // const SizedBox(height: 12),
            // Container(
            //   padding: const EdgeInsets.all(12),
            //   decoration: BoxDecoration(
            //     border: Border.all(color: Colors.grey.shade300),
            //     borderRadius: BorderRadius.circular(8),
            //   ),
            //   child: Row(
            //     children: [
            //       const Icon(Icons.payment),
            //       const SizedBox(width: 12),
            //       Expanded(
            //         child: Column(
            //           crossAxisAlignment: CrossAxisAlignment.start,
            //           children: [
            //             const Text(
            //               'FastPayz',
            //               style: TextStyle(fontWeight: FontWeight.bold),
            //             ),
            //             Text(
            //               '****4520',
            //               style:
            //                   TextStyle(color: Colors.grey[600], fontSize: 12),
            //             ),
            //           ],
            //         ),
            //       ),
            //       TextButton(
            //         onPressed: () {},
            //         child: const Text('Edit'),
            //       ),
            //     ],
            //   ),
            // ),
            const SizedBox(height: 24),
            const Text(
              'Payment Details',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total: $nights Night',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                Text(
                  formatRupiah(totalPrice),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Cleaning Fee',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                Text(
                  formatRupiah(cleaningFee * 1000),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Service Fee',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                Text(
                  formatRupiah(serviceFee * 1000),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total Payment:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  formatRupiah(totalPayment),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  context.router.push(CheckoutRoute(
                    hotelId: widget.hotelId,
                    checkInDate: checkInDate,
                    checkOutDate: checkOutDate,
                    guests: guests,
                    totalPayment: totalPayment,
                  ));
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Checkout',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[month - 1];
  }
}
