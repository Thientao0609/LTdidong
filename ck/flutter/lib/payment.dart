import 'package:flutter/material.dart';
import 'services/payment_service.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  int _currentStep = 0; // 0 for Payment Method, 1 for Preview
  late Future<Map<String, dynamic>> _checkoutDataFuture;
  
  final _nameController = TextEditingController();
  final _numberController = TextEditingController();
  final _expController = TextEditingController();
  final _cvvController = TextEditingController();
  
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _checkoutDataFuture = PaymentService.getCheckoutPreview();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _numberController.dispose();
    _expController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_nameController.text.isEmpty || _numberController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in card details')),
      );
      return;
    }
    setState(() {
      _currentStep = 1;
    });
  }

  void _processPayment() async {
    setState(() => _isProcessing = true);
    try {
      await PaymentService.processPayment({
        'cardName': _nameController.text,
        'cardNumber': _numberController.text,
        'expDate': _expController.text,
        'cvv': _cvvController.text,
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Payment processed successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context); // Go back after success
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceAll('Exception: ', '')),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () {
            if (_currentStep == 1) {
              setState(() => _currentStep = 0);
            } else {
              Navigator.pop(context);
            }
          },
        ),
        title: const Text(
          'Payment',
          style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildStepper(),
            const SizedBox(height: 30),
            Expanded(
              child: _currentStep == 0 ? _buildPaymentMethod() : _buildPreviewCheckout(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepper() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF00D1B2),
                border: Border.all(color: const Color(0xFFE0F7F4), width: 4),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Payment Method',
              style: TextStyle(
                fontSize: 10,
                color: _currentStep == 0 ? const Color(0xFF00D1B2) : Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Container(
          width: 80,
          height: 1,
          color: _currentStep == 1 ? const Color(0xFF00D1B2) : Colors.grey[300],
          margin: const EdgeInsets.only(bottom: 16),
        ),
        Column(
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentStep == 1 ? const Color(0xFF00D1B2) : Colors.grey[300],
                border: _currentStep == 1 ? Border.all(color: const Color(0xFFE0F7F4), width: 4) : null,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Preview & Check out',
              style: TextStyle(
                fontSize: 10,
                color: _currentStep == 1 ? const Color(0xFF00D1B2) : Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPaymentMethod() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.credit_card, color: Colors.black54),
              SizedBox(width: 8),
              Text(
                'Card Information',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 30),
          _buildTextField('Card Holder\'s Name', 'Card Holder\'s Name', _nameController),
          const SizedBox(height: 24),
          _buildTextField('Card Number', '0000 0000 0000 0000', _numberController, TextInputType.number),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(child: _buildTextField('Expiration Date', 'mm/yy', _expController)),
              const SizedBox(width: 24),
              Expanded(child: _buildTextField('CVV', '000', _cvvController, TextInputType.number)),
            ],
          ),
          const SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _nextStep,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00D1B2),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('NEXT', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, String hint, TextEditingController controller, [TextInputType? type]) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        TextField(
          controller: controller,
          keyboardType: type,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[400]),
            enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFFEAEAEA))),
            focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF00D1B2))),
          ),
        ),
      ],
    );
  }

  Widget _buildPreviewCheckout() {
    return FutureBuilder<Map<String, dynamic>>(
      future: _checkoutDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: Color(0xFF00D1B2)));
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final data = snapshot.data!;
        final attractions = List<String>.from(data['attractions'] ?? []);

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Card
              SizedBox(
                height: 180,
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 160,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          image: NetworkImage(data['image'] ?? 'https://via.placeholder.com/600'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 30,
                      left: 16,
                      child: Row(
                        children: [
                          const Icon(Icons.location_on, color: Colors.white, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            data['location'] ?? '',
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      right: 16,
                      bottom: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: CircleAvatar(
                          radius: 26,
                          backgroundImage: NetworkImage(data['guideAvatar'] ?? 'https://via.placeholder.com/100'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              
              // Details
              _buildDetailRow('Date', data['date']),
              _buildDetailRow('Time', data['time']),
              _buildDetailRow('Guide', data['guideName'], valueColor: const Color(0xFF00D1B2)),
              _buildDetailRow('Number of Travelers', data['travelers']?.toString()),
              
              const SizedBox(height: 12),
              const Text('Attractions', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: attractions.map((attr) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.location_on, size: 14, color: Color(0xFF00D1B2)),
                        const SizedBox(width: 4),
                        Text(attr, style: const TextStyle(fontSize: 12)),
                      ],
                    ),
                  );
                }).toList(),
              ),
              
              const SizedBox(height: 24),
              
              // Total box
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[200]!),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Text('\$${data['total']}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF00D1B2))),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('50% payment', style: TextStyle(color: Colors.grey)),
                        Text('\$${data['upfrontPayment']}', style: const TextStyle(color: Color(0xFF00D1B2))),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text('(You just need to pay upfront 50%)', style: TextStyle(fontSize: 11, color: Colors.grey)),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isProcessing ? null : _processPayment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00D1B2),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: _isProcessing 
                      ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text('CHECK OUT', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String? value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
          Text(value ?? '', style: TextStyle(color: valueColor ?? Colors.black54)),
        ],
      ),
    );
  }
}
