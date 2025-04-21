import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:stayzio_app/routes/app_route.dart';

@RoutePage()
class YourCardScreen extends StatefulWidget {
  const YourCardScreen({super.key});

  @override
  State<YourCardScreen> createState() => _YourCardScreenState();
}

class _YourCardScreenState extends State<YourCardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF2B5FE0),
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          context.router.push(const AddNewCardRoute());
        },
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              // App Bar
              Row(
                children: [
                  // Back Button
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    padding: EdgeInsets.zero,
                    alignment: Alignment.centerLeft,
                    onPressed: () => context.router.pop(),
                  ),

                  const Expanded(
                    child: Center(
                      child: Text(
                        "Your Card",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  // Empty space to balance the back button
                  const SizedBox(width: 48),
                ],
              ),

              const SizedBox(height: 24),

              // Visa Card
              _buildCreditCard(
                cardType: "visa",
                cardNumber: "9055 3557 4453 4235",
                balance: 3242.23,
                expiryDate: "12/24",
                cardColor: const Color(0xFF2B5FE0),
                textColor: Colors.white,
              ),

              const SizedBox(height: 8),

              // Use as default payment method
              _buildDefaultPaymentMethod(),

              const SizedBox(height: 24),

              // Mastercard Card
              _buildCreditCard(
                cardType: "mastercard",
                cardNumber: "5094 2456 4790 9568",
                balance: 4570.80,
                expiryDate: "11/24",
                cardColor: const Color(0xFF1E1E1E),
                textColor: Colors.white,
              ),

              const SizedBox(height: 8),

              // Use as default payment method
              _buildDefaultPaymentMethod(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCreditCard({
    required String cardType,
    required String cardNumber,
    required double balance,
    required String expiryDate,
    required Color cardColor,
    required Color textColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Current Balance",
                    style: TextStyle(
                      color: textColor.withOpacity(0.8),
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "\$${balance.toStringAsFixed(2)}",
                    style: TextStyle(
                      color: textColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Image.asset(
                cardType == "visa"
                    ? 'assets/images/visa.png'
                    : 'assets/images/mastercard.png',
                height: 32,
                errorBuilder: (context, error, stackTrace) => Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    cardType.toUpperCase(),
                    style: TextStyle(
                      color: cardColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
          Text(
            cardNumber,
            style: TextStyle(
              color: textColor,
              fontSize: 16,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.bottomRight,
            child: Text(
              expiryDate,
              style: TextStyle(
                color: textColor,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultPaymentMethod() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: const Color(0xFF2B5FE0),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.check,
              color: Colors.white,
              size: 16,
            ),
          ),
          const SizedBox(width: 8),
          const Text(
            "Use as default payment method",
            style: TextStyle(
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
