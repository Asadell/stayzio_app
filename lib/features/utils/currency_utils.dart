/// Utilities for currency formatting
String formatRupiah(double amount) {
  return 'Rp ${amount.toStringAsFixed(0) // Remove decimals
      .replaceAllMapped(
        RegExp(r'(\d)(?=(\d{3})+$)'),
        (match) => '${match[1]}.',
      )}';
}
