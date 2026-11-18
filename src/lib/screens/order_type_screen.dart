import 'package:flutter/material.dart';

import '../widgets/order_type_card.dart';

class OrderTypeScreen extends StatefulWidget {
  const OrderTypeScreen({super.key});

  @override
  State<OrderTypeScreen> createState() => _OrderTypeScreenState();
}

class _OrderTypeScreenState extends State<OrderTypeScreen> {
  static const Color background = Color(0xFFFFFAFA);
  static const Color rose = Color(0xFFD7375A);
  static const Color muted = Color(0xFF806D70);
  static const Color green = Color(0xFF98CEAA);

  // Immediate Order is selected by default.
  String selectedOrderType = 'immediate';

  void selectOrderType(String type) {
    setState(() {
      selectedOrderType = type;
    });
  }

  void continueOrder() {
    final message = selectedOrderType == 'immediate'
        ? 'Immediate Order selected'
        : 'Advance Preorder selected';

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,

      // STEP 5: Responsive mobile layout
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: SizedBox(
              width: double.infinity,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),

                      // Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'JEJARI HALUS · GUEST / 05',
                            style: TextStyle(
                              color: muted,
                              fontSize: 9,
                              letterSpacing: 0.5,
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.help_outline, color: rose),
                          ),
                        ],
                      ),

                      // Heading
                      const Text(
                        'How shall we make your day?',
                        style: TextStyle(
                          color: rose,
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 12),

                      const Text(
                        'Choose the right kind of sweet moment.',
                        style: TextStyle(color: muted, fontSize: 13),
                      ),

                      const SizedBox(height: 10),

                      // Immediate Order Card
                      OrderTypeCard(
                        title: 'Immediate Order',
                        description: 'For a little treat, a little sooner.',
                        icon: Icons.shopping_bag_outlined,
                        isSelected: selectedOrderType == 'immediate',
                        details: const [
                          'Currently available products only',
                          'Shop pickup only — no delivery',
                          'Select your pickup time at checkout',
                        ],
                        onTap: () {
                          selectOrderType('immediate');
                        },
                      ),

                      const SizedBox(height: 10),

                      // Advance Preorder Card
                      OrderTypeCard(
                        title: 'Advance Preorder',
                        description: 'Something special, planned with love.',
                        icon: Icons.calendar_month_outlined,
                        badge: 'Plan ahead',
                        isSelected: selectedOrderType == 'preorder',
                        details: const [
                          'Larger quantities, birthdays and events',
                          'Fulfilment at least TWO DAYS ahead',
                          'Shop pickup or eligible bakery delivery',
                        ],
                        footer: 'Earliest fulfilment: 2 days after ordering',
                        onTap: () {
                          selectOrderType('preorder');
                        },
                      ),

                      const SizedBox(height: 20),

                      // Continue Button
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: continueOrder,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: green,
                            foregroundColor: const Color(0xFF654A50),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: const Text(
                            'Continue',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
