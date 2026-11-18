class OrderDraft {
  final String customerName;
  final String customerPhone;
  final String orderType;
  final String fulfilmentMethod;
  final String? deliveryAddress;
  final DateTime? requiredDate;
  final double totalAmount;

  const OrderDraft({
    required this.customerName,
    required this.customerPhone,
    required this.orderType,
    required this.fulfilmentMethod,
    this.deliveryAddress,
    this.requiredDate,
    required this.totalAmount,
  });
}