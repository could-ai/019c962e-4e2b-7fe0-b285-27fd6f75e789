import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';

class PricingDialog extends StatelessWidget {
  const PricingDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF121212),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.white.withOpacity(0.1)),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 900, maxHeight: 600),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Select a Plan',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'One-time payment. Own the code forever.',
                style: TextStyle(color: Colors.grey[400]),
              ),
              const SizedBox(height: 32),
              Expanded(
                child: SingleChildScrollView(
                  child: Wrap(
                    spacing: 24,
                    runSpacing: 24,
                    alignment: WrapAlignment.center,
                    children: [
                      _PricingCard(
                        title: 'Basic',
                        price: '\$49',
                        features: const [
                          'Core Python Script',
                          'Standard Requirements',
                          'Basic README',
                        ],
                        color: Colors.blue,
                        onSelect: () => _handlePayment(context, 'basic'),
                      ),
                      _PricingCard(
                        title: 'Pro',
                        price: '\$199',
                        features: const [
                          'Advanced Logic',
                          'Detailed Documentation',
                          'Example Usage',
                          'Error Handling',
                        ],
                        color: const Color(0xFF00E5FF),
                        isPopular: true,
                        onSelect: () => _handlePayment(context, 'pro'),
                      ),
                      _PricingCard(
                        title: 'Enterprise',
                        price: '\$499',
                        features: const [
                          'Custom Architecture',
                          'Integration Support',
                          'Commercial License',
                          'Priority Generation',
                        ],
                        color: Colors.purple,
                        onSelect: () => _handlePayment(context, 'enterprise'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handlePayment(BuildContext context, String planId) {
    // In a real app, this would redirect to Stripe
    // For this demo, we simulate a successful payment
    Navigator.of(context).pop();
    context.read<AppState>().processPayment(planId);
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Payment Successful! Generating agent...'),
        backgroundColor: Colors.green,
      ),
    );
    
    // Auto-start generation after payment
    Future.delayed(const Duration(milliseconds: 500), () {
      if (context.mounted) {
        context.read<AppState>().generateAgent();
      }
    });
  }
}

class _PricingCard extends StatelessWidget {
  final String title;
  final String price;
  final List<String> features;
  final Color color;
  final bool isPopular;
  final VoidCallback onSelect;

  const _PricingCard({
    required this.title,
    required this.price,
    required this.features,
    required this.color,
    this.isPopular = false,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isPopular ? color : Colors.white.withOpacity(0.1),
          width: isPopular ? 2 : 1,
        ),
        boxShadow: isPopular
            ? [BoxShadow(color: color.withOpacity(0.2), blurRadius: 20)]
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isPopular)
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'MOST POPULAR',
                style: TextStyle(
                  color: color,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            price,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          ...features.map((f) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Icon(Icons.check, color: color, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        f,
                        style: TextStyle(color: Colors.grey[400], fontSize: 14),
                      ),
                    ),
                  ],
                ),
              )),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onSelect,
              style: ElevatedButton.styleFrom(
                backgroundColor: isPopular ? color : Colors.white.withOpacity(0.1),
                foregroundColor: isPopular ? Colors.black : Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Select Plan'),
            ),
          ),
        ],
      ),
    );
  }
}
