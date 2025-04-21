import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:stayzio_app/features/auth/data/provider/auth_provider.dart';
import 'package:stayzio_app/features/booking/data/model/payment_card.dart';
import 'package:stayzio_app/features/booking/data/provider/payment_card_provider.dart';

@RoutePage()
class AddNewCardScreen extends StatefulWidget {
  const AddNewCardScreen({super.key});

  @override
  State<AddNewCardScreen> createState() => _AddNewCardScreenState();
}

class _AddNewCardScreenState extends State<AddNewCardScreen> {
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _holderNameController = TextEditingController();
  final TextEditingController _expiryController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String _displayCardNumber = '•••• •••• •••• ••••';
  String _displayHolderName = '';
  String _displayExpiry = '••/••';
  bool _isCardNumberFocused = false;

  @override
  void initState() {
    super.initState();
    // Pre-fill holder name with user's name
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userName = context.read<AuthProvider>().currentUser?.fullName ?? '';
      _holderNameController.text = userName;
      setState(() {
        _displayHolderName = userName;
      });
    });

    // Add listeners to update card preview
    _cardNumberController.addListener(_updateCardNumber);
    _holderNameController.addListener(_updateHolderName);
    _expiryController.addListener(_updateExpiry);
  }

  void _updateCardNumber() {
    final input = _cardNumberController.text;
    setState(() {
      if (input.isEmpty) {
        _displayCardNumber = '•••• •••• •••• ••••';
      } else {
        // Format with spaces every 4 digits
        final formattedNumber = input
            .replaceAll(' ', '')
            .split('')
            .asMap()
            .entries
            .fold<String>('', (prev, entry) {
          final char = entry.value;
          final index = entry.key;
          return prev + (index > 0 && index % 4 == 0 ? ' $char' : char);
        });
        _displayCardNumber = formattedNumber.padRight(19, '•');
      }
    });
  }

  void _updateHolderName() {
    setState(() {
      _displayHolderName = _holderNameController.text.isEmpty
          ? (context.read<AuthProvider>().currentUser?.fullName ?? '')
          : _holderNameController.text;
    });
  }

  void _updateExpiry() {
    setState(() {
      final input = _expiryController.text;
      if (input.isEmpty) {
        _displayExpiry = '••/••';
      } else {
        _displayExpiry = input;
      }
    });
  }

  @override
  void dispose() {
    _cardNumberController.removeListener(_updateCardNumber);
    _holderNameController.removeListener(_updateHolderName);
    _expiryController.removeListener(_updateExpiry);

    _cardNumberController.dispose();
    _holderNameController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  // Format card number with spaces
  String _formatCardNumber(String input) {
    input = input.replaceAll(' ', '');
    if (input.length <= 4) return input;

    final buffer = StringBuffer();
    for (int i = 0; i < input.length; i++) {
      if (i > 0 && i % 4 == 0) buffer.write(' ');
      buffer.write(input[i]);
    }
    return buffer.toString();
  }

  // Format expiry date with slash
  String _formatExpiryDate(String input) {
    input = input.replaceAll('/', '');
    if (input.length <= 2) return input;
    return '${input.substring(0, 2)}/${input.substring(2)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),

                  // App Bar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Back Button
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        padding: EdgeInsets.zero,
                        alignment: Alignment.centerLeft,
                        onPressed: () => context.router.pop(),
                      ),

                      const Text(
                        "Add New Card",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      // Menu Icon
                      IconButton(
                        icon: const Icon(Icons.more_vert),
                        onPressed: () {},
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Card Preview
                  Container(
                    height: 180,
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2B5FE0),
                      borderRadius: BorderRadius.circular(12),
                      image: const DecorationImage(
                        image: AssetImage('assets/images/card_bg.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 40,
                              height: 24,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "MasterCard",
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Text(
                          _displayCardNumber,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            letterSpacing: 1,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  context
                                      .watch<AuthProvider>()
                                      .currentUser!
                                      .fullName,
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.8),
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _displayHolderName,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Expires",
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.8),
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _displayExpiry,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Card Number Field
                  const Text(
                    "Card Number",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Focus(
                    onFocusChange: (hasFocus) {
                      setState(() {
                        _isCardNumberFocused = hasFocus;
                      });
                    },
                    child: TextFormField(
                      controller: _cardNumberController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(16),
                        TextInputFormatter.withFunction((oldValue, newValue) {
                          final text = _formatCardNumber(newValue.text);
                          return TextEditingValue(
                            text: text,
                            selection:
                                TextSelection.collapsed(offset: text.length),
                          );
                        }),
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter card number';
                        }
                        final cardNumber = value.replaceAll(' ', '');
                        if (cardNumber.length < 16) {
                          return 'Card number must be 16 digits';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: "Enter Card Number",
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                              color: const Color(0xFF2B5FE0), width: 1),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        suffixIcon: _isCardNumberFocused ||
                                _cardNumberController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  _cardNumberController.clear();
                                },
                              )
                            : null,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Card Holder Name
                  const Text(
                    "Card Holder Name",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _holderNameController,
                    textCapitalization: TextCapitalization.words,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter holder name';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: "Enter Holder Name",
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                            color: const Color(0xFF2B5FE0), width: 1),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Expiry Date and CVV
                  Row(
                    children: [
                      // Expiry Date
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Expired",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _expiryController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(4),
                                TextInputFormatter.withFunction(
                                    (oldValue, newValue) {
                                  final text = _formatExpiryDate(newValue.text);
                                  return TextEditingValue(
                                    text: text,
                                    selection: TextSelection.collapsed(
                                        offset: text.length),
                                  );
                                }),
                              ],
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Required';
                                }
                                if (value.replaceAll('/', '').length < 4) {
                                  return 'Invalid date';
                                }

                                // Get month and year
                                final parts = value.split('/');
                                if (parts.length != 2) return 'Invalid format';

                                final month = int.tryParse(parts[0]);
                                if (month == null || month < 1 || month > 12) {
                                  return 'Invalid month';
                                }

                                return null;
                              },
                              decoration: InputDecoration(
                                hintText: "MM/YY",
                                filled: true,
                                fillColor: Colors.grey[100],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                      color: const Color(0xFF2B5FE0), width: 1),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                                errorMaxLines: 2,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 16),

                      // CVV Code
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "CVV Code",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _cvvController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(3),
                              ],
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Required';
                                }
                                if (value.length < 3) {
                                  return 'Invalid CVV';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                hintText: "CVV",
                                filled: true,
                                fillColor: Colors.grey[100],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                      color: const Color(0xFF2B5FE0), width: 1),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                              ),
                              obscureText: true,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),

                  // Add Card Button
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 24),
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState?.validate() ?? false) {
                          // Read AuthProvider without triggering a rebuild
                          final provider = context.read<PaymentCardProvider>();
                          final userId =
                              context.read<AuthProvider>().currentUser!.id!;

                          final card = PaymentCard(
                            cardNumber: _cardNumberController.text
                                .replaceAll(' ', '')
                                .trim(),
                            cardHolderName: _holderNameController.text.trim(),
                            expiryDate: _expiryController.text.trim(),
                            cvv: _cvvController.text.trim(),
                            cardType: 'mastercard',
                            userId: userId,
                          );

                          // Call the addNewCard method from PaymentCardProvider
                          final success = await provider.addNewCard(card);

                          if (success) {
                            Fluttertoast.showToast(
                              msg: "✅ Card added successfully!",
                              backgroundColor: Colors.green,
                              textColor: Colors.white,
                              gravity: ToastGravity.TOP,
                            );

                            context.router
                                .pop(); // Go back to the previous screen
                          } else {
                            Fluttertoast.showToast(
                              msg: "❌ Failed to add card.",
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              gravity: ToastGravity.TOP,
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2B5FE0),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        "Add Card",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
