import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stayzio_app/features/auth/data/provider/auth_provider.dart';
import 'package:stayzio_app/features/booking/data/provider/payment_card_provider.dart';
import 'package:stayzio_app/features/utils/currency_utils.dart';
import 'package:stayzio_app/routes/app_route.dart';

@RoutePage()
class YourCardScreen extends StatefulWidget {
  const YourCardScreen({super.key});

  @override
  State<YourCardScreen> createState() => _YourCardScreenState();
}

class _YourCardScreenState extends State<YourCardScreen> {
  // Konstanta warna yang digunakan di beberapa tempat
  static const Color primaryBlue = Color(0xFF2B5FE0);
  static const Color cardBlack = Color(0xFF1E1E1E);

  @override
  void initState() {
    super.initState();

    // Perbaikan: Hindari context.watch di initState
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId =
          Provider.of<AuthProvider>(context, listen: false).currentUser?.id;
      if (userId != null) {
        context.read<PaymentCardProvider>().loadUserCards(userId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userId = authProvider.currentUser?.id;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryBlue,
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

              // Card list dengan Consumer
              Expanded(
                child: Consumer<PaymentCardProvider>(
                  builder: (context, cardProvider, _) {
                    // State Loading
                    if (cardProvider.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    // State Empty
                    if (cardProvider.cards.isEmpty) {
                      return const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.credit_card_off,
                                size: 64, color: Colors.grey),
                            SizedBox(height: 16),
                            Text(
                              "You don't have any cards yet",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "Add a card by clicking the + button",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      );
                    }

                    // State Success: Menampilkan daftar kartu
                    return ListView.builder(
                      itemCount: cardProvider.cards.length,
                      itemBuilder: (context, index) {
                        final card = cardProvider.cards[index];
                        // Konversi isDefault ke boolean jika perlu
                        bool isDefaultCard = false;
                        // Jika isDefault bertipe int
                        isDefaultCard = card.isDefault > 0;

                        return Column(
                          children: [
                            _buildCreditCard(
                              cardType: card.cardType,
                              cardNumber: card.cardNumber,
                              balance: card.currentBalance ?? 0,
                              expiryDate: card.expiryDate,
                              cardColor: card.cardType == 'visa'
                                  ? primaryBlue
                                  : cardBlack,
                              textColor: Colors.white,
                            ),
                            const SizedBox(height: 8),

                            // Default payment checkbox
                            _buildDefaultPaymentMethod(
                                isDefault: isDefaultCard,
                                onChanged: (value) {
                                  if (value == true &&
                                      userId != null &&
                                      card.id != null) {
                                    // Sesuaikan dengan method di provider
                                    cardProvider.setDefaultCard(
                                        userId, card.id!);
                                  }
                                }),

                            const SizedBox(height: 24),

                            // Tambahan: Space untuk item terakhir
                            if (index == cardProvider.cards.length - 1)
                              const SizedBox(height: 80),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
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
                    formatRupiah(balance),
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

  Widget _buildDefaultPaymentMethod({
    bool isDefault = false,
    ValueChanged<bool?>? onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: Row(
        children: [
          // Gunakan widget langsung seperti di kode asli
          InkWell(
            onTap: () => onChanged?.call(!isDefault),
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: isDefault ? primaryBlue : Colors.transparent,
                border:
                    isDefault ? null : Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(12),
              ),
              child: isDefault
                  ? const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 16,
                    )
                  : null,
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
