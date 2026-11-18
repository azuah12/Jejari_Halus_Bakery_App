
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/order_draft.dart';

class PaymentMethodsScreen extends StatefulWidget {
  final OrderDraft orderDraft;

  final void Function({
    required String paymentMethod,
    XFile? receipt,
  }) onContinue;

  const PaymentMethodsScreen({
    super.key,
    required this.orderDraft,
    required this.onContinue,
  });

  @override
  State<PaymentMethodsScreen> createState() =>
      _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState
    extends State<PaymentMethodsScreen> {
  static const Color rose = Color(0xFFD7375A);
  static const Color background = Color(0xFFFFF9F8);
  static const Color borderColor = Color(0xFFF0D9DD);
  static const Color green = Color(0xFF98CBAA);
  static const Color darkText = Color(0xFF765C62);

  String _selectedMethod = 'QR Payment';
  XFile? _receipt;
  int? _receiptSize;
  String? _errorMessage;
  bool _isPickingReceipt = false;

  final ImagePicker _picker = ImagePicker();

  bool get _isQrPayment => _selectedMethod == 'QR Payment';

  // Get pickup time or delivery address.
  String _getFulfilmentValue() {
    final method =
        widget.orderDraft.fulfilmentMethod.toLowerCase();

    if (method.contains('pickup')) {
      final date = widget.orderDraft.requiredDate;

      if (date == null) return 'To be confirmed';

      return TimeOfDay.fromDateTime(date).format(context);
    }

    return widget.orderDraft.deliveryAddress?.isNotEmpty == true
        ? widget.orderDraft.deliveryAddress!
        : 'To be confirmed';
  }

  // Get the appropriate fulfilment label.
  String _getFulfilmentLabel() {
    return widget.orderDraft.fulfilmentMethod
            .toLowerCase()
            .contains('pickup')
        ? 'Pickup Time'
        : 'Delivery Address';
  }

  // Format file size.
  String _formatFileSize(int bytes) {
    return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
  }

  // Select and validate payment receipt.
  Future<void> _pickReceipt() async {
    setState(() {
      _errorMessage = null;
      _isPickingReceipt = true;
    });

    try {
      final XFile? file = await _picker.pickImage(
        source: ImageSource.gallery,
      );

      if (!mounted || file == null) return;

      final extension =
          file.name.split('.').last.toLowerCase();

      if (!['jpg', 'jpeg', 'png'].contains(extension)) {
        setState(() {
          _receipt = null;
          _receiptSize = null;
          _errorMessage =
              'Only JPG and PNG images are allowed.';
        });
        return;
      }

      const maxSize = 5 * 1024 * 1024;
      final fileSize = await file.length();

      if (!mounted) return;

      if (fileSize > maxSize) {
        setState(() {
          _receipt = null;
          _receiptSize = null;
          _errorMessage =
              'File size must not exceed 5 MB.';
        });
        return;
      }

      setState(() {
        _receipt = file;
        _receiptSize = fileSize;
        _errorMessage = null;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _errorMessage =
            'Unable to select receipt. Please try again.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isPickingReceipt = false;
        });
      }
    }
  }

  // Remove selected receipt.
  void _removeReceipt() {
    setState(() {
      _receipt = null;
      _receiptSize = null;
      _errorMessage = null;
    });
  }

  // Continue to order review.
  void _reviewOrder() {
    if (_isQrPayment && _receipt == null) {
      setState(() {
        _errorMessage =
            'Please upload your payment receipt first.';
      });
      return;
    }

    widget.onContinue(
      paymentMethod: _selectedMethod,
      receipt: _receipt,
    );
  }

  // Display payment help.
  void _showHelp() {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Payment Help'),
        content: const Text(
          'Choose QR Payment to pay using the bakery QR code '
          'and upload your receipt. Alternatively, choose '
          'Cash on Delivery to pay when your order is delivered.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Got it',
              style: TextStyle(color: rose),
            ),
          ),
        ],
      ),
    );
  }

  // Payment selection tab.
  Widget _buildMethodTab(String title) {
    final isSelected = _selectedMethod == title;

    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedMethod = title;
            _errorMessage = null;
          });
        },
        borderRadius: BorderRadius.circular(30),
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 8,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFFFFE9ED)
                : Colors.white,
            border: Border.all(
              color: isSelected ? rose : borderColor,
              width: isSelected ? 1.5 : 1,
            ),
            borderRadius: BorderRadius.circular(30),
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: isSelected ? rose : darkText,
              fontWeight:
                  isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  // Individual order detail.
  Widget _buildDetailItem(String label, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: darkText,
            ),
          ),
        ],
      ),
    );
  }

  // Order summary card.
  Widget _buildOrderSummary() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: rose.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.receipt_long_outlined,
                color: rose,
                size: 19,
              ),
              SizedBox(width: 8),
              Text(
                'Order Summary',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: darkText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailItem(
                'Order Type',
                widget.orderDraft.orderType,
              ),
              const SizedBox(width: 16),
              _buildDetailItem(
                _getFulfilmentLabel(),
                _getFulfilmentValue(),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailItem(
                'Customer Name',
                widget.orderDraft.customerName,
              ),
              const SizedBox(width: 16),
              _buildDetailItem(
                'Guest Contact',
                widget.orderDraft.customerPhone,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // QR payment card.
  Widget _buildQrCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: rose.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'QR Payment',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: darkText,
                ),
              ),
              const Icon(
                Icons.qr_code_2,
                color: rose,
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 132,
                height: 132,
                decoration: BoxDecoration(
                  color: background,
                  border: Border.all(color: borderColor),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.qr_code_2,
                      size: 82,
                      color: darkText,
                    ),
                    Text(
                      'DEMO · DO NOT PAY',
                      style: TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                        color: darkText,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Text(
                  '1. Scan the bakery QR code.\n\n'
                  '2. Pay the exact order amount.\n\n'
                  '3. Upload your payment receipt.',
                  style: TextStyle(
                    fontSize: 11,
                    height: 1.5,
                    color: darkText,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF0F2),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Amount to pay',
                  style: TextStyle(
                    fontSize: 12,
                    color: darkText,
                  ),
                ),
                Text(
                  'RM${widget.orderDraft.totalAmount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                    color: rose,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Receipt upload card.
  Widget _buildReceiptCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: rose.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Payment Receipt',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: darkText,
                ),
              ),
              Text(
                'JPG / PNG · Max 5 MB',
                style: TextStyle(
                  fontSize: 9,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: background,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: borderColor),
            ),
            child: Row(
              children: [
                Icon(
                  _receipt == null
                      ? Icons.cloud_upload_outlined
                      : Icons.image_outlined,
                  color: rose,
                  size: 30,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _receipt?.name ?? 'No receipt selected',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: darkText,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        _receipt == null
                            ? 'Upload your payment receipt here.'
                            : '${_formatFileSize(_receiptSize ?? 0)} · Ready for upload',
                        style: TextStyle(
                          fontSize: 9,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                if (_receipt != null)
                  IconButton(
                    onPressed: _removeReceipt,
                    tooltip: 'Remove receipt',
                    icon: const Icon(
                      Icons.close,
                      color: rose,
                      size: 20,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed:
                  _isPickingReceipt ? null : _pickReceipt,
              icon: Icon(
                _receipt == null
                    ? Icons.upload_file
                    : Icons.refresh,
                size: 18,
              ),
              label: Text(
                _isPickingReceipt
                    ? 'Selecting receipt...'
                    : _receipt == null
                        ? 'Choose Receipt'
                        : 'Replace Receipt',
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: rose,
                side: const BorderSide(color: rose),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          if (_receipt != null) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 11,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFFFE9ED),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    size: 14,
                    color: rose,
                  ),
                  SizedBox(width: 6),
                  Text(
                    'Selected · Upload pending',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: rose,
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (_errorMessage != null) ...[
            const SizedBox(height: 10),
            Text(
              _errorMessage!,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 11,
              ),
            ),
          ],
        ],
      ),
    );
  }

  // Cash on Delivery card.
  Widget _buildCashPaymentCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: rose.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.payments_outlined,
                color: rose,
                size: 22,
              ),
              SizedBox(width: 9),
              Text(
                'Cash on Delivery',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: darkText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF0F2),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total to pay',
                  style: TextStyle(
                    fontSize: 12,
                    color: darkText,
                  ),
                ),
                Text(
                  'RM${widget.orderDraft.totalAmount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                    color: rose,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Please prepare the exact amount. '
            'Payment will be collected upon delivery.',
            style: TextStyle(
              fontSize: 12,
              height: 1.6,
              color: darkText,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'No receipt upload is required.',
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Page header.
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.maybePop(context),
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      size: 19,
                    ),
                    color: darkText,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Text(
                      'Payment, with care',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: rose,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: _showHelp,
                    icon: const Icon(
                      Icons.help_outline,
                      color: rose,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              // Payment method selection.
              Row(
                children: [
                  _buildMethodTab('QR Payment'),
                  const SizedBox(width: 10),
                  _buildMethodTab('Cash on Delivery'),
                ],
              ),

              const SizedBox(height: 18),

              // Order summary.
              _buildOrderSummary(),

              const SizedBox(height: 18),

              // Selected payment method content.
              if (_isQrPayment) ...[
                _buildQrCard(),
                const SizedBox(height: 16),
                _buildReceiptCard(),
              ] else
                _buildCashPaymentCard(),
            ],
          ),
        ),
      ),

      // Fixed bottom button.
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 16),
          child: SizedBox(
            height: 52,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _reviewOrder,
              style: ElevatedButton.styleFrom(
                backgroundColor: green,
                foregroundColor: darkText,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                'Review Order',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
