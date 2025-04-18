import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:productly/core/constants/app_constants.dart';
import 'package:productly/core/storage/local_storage.dart';
import 'package:productly/core/widgets/app_button.dart';
import 'package:productly/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:productly/features/cart/presentation/bloc/cart_event.dart';
import 'package:productly/features/cart/presentation/bloc/cart_state.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _isSubmitting = false;
  double _cartTotal = 0.0;
  List<Map<String, dynamic>> _cartItems = [];

  @override
  void initState() {
    super.initState();
    _loadCartData();
  }

  Future<void> _loadCartData() async {
    setState(() {
      _isSubmitting = true;
    });

    final cartItems = await LocalStorage.getCart();
    double total = 0.0;
    for (var item in cartItems) {
      total += (item['price'] as double) * (item['quantity'] as int);
    }

    setState(() {
      _cartItems = cartItems;
      _cartTotal = total;
      _isSubmitting = false;
    });
  }

  void _submitOrder() async {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      setState(() {
        _isSubmitting = true;
      });

      // Simulate order processing delay
      await Future.delayed(const Duration(seconds: 2));

      // Get form data
      final formData = _formKey.currentState!.value;
      
      // Clear cart after successful order
      await LocalStorage.clearCart();

      setState(() {
        _isSubmitting = false;
      });

      if (mounted) {
        // Show success message and navigate to home
        _showOrderSuccessDialog(formData);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all required fields'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showOrderSuccessDialog(Map<String, dynamic> formData) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Order Placed Successfully!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Thank you for your order!'),
            const SizedBox(height: 16),
            Text('Order Total: \$${_cartTotal.toStringAsFixed(2)}'),
            const SizedBox(height: 8),
            Text('Shipping Address: ${formData['address']}, ${formData['city']}, ${formData['zipCode']}'),
            const SizedBox(height: 8),
            Text('Payment Method: ${formData['paymentMethod']}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Reset cart state
              context.read<CartBloc>().add(const CartLoaded());
              
              // Navigate back to home
              context.go(AppConstants.homeRoute);
            },
            child: const Text('Continue Shopping'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: _isSubmitting && _cartItems.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : _cartItems.isEmpty
              ? _buildEmptyCart(theme)
              : _buildCheckoutForm(theme),
    );
  }

  Widget _buildEmptyCart(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 80,
            color: theme.colorScheme.primary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'Your cart is empty',
            style: theme.textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Add items to your cart before checkout',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          AppButton(
            text: 'Browse Products',
            onPressed: () => context.go(AppConstants.homeRoute),
            icon: Icons.shopping_bag_outlined,
          ),
        ],
      ),
    );
  }

  Widget _buildCheckoutForm(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Order Summary
          Text(
            'Order Summary',
            style: theme.textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          
          // Cart Items Summary
          Card(
            margin: const EdgeInsets.only(bottom: 24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var item in _cartItems)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 3,
                            child: Text(
                              item['title'] as String,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              '${item['quantity']} x',
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              '\$${(item['price'] as double).toStringAsFixed(2)}',
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                    ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total:',
                        style: theme.textTheme.titleMedium,
                      ),
                      Text(
                        '\$${_cartTotal.toStringAsFixed(2)}',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          // Checkout Form
          Text(
            'Shipping Information',
            style: theme.textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          
          FormBuilder(
            key: _formKey,
            autovalidateMode: AutovalidateMode.disabled,
            child: Column(
              children: [
                // Full Name
                FormBuilderTextField(
                  name: 'fullName',
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                    prefixIcon: const Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
                    ),
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    FormBuilderValidators.minLength(3),
                  ]),
                ),
                const SizedBox(height: 16),
                
                // Email
                FormBuilderTextField(
                  name: 'email',
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: const Icon(Icons.email),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
                    ),
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    FormBuilderValidators.email(),
                  ]),
                ),
                const SizedBox(height: 16),
                
                // Phone
                FormBuilderTextField(
                  name: 'phone',
                  decoration: InputDecoration(
                    labelText: 'Phone',
                    prefixIcon: const Icon(Icons.phone),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
                    ),
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    FormBuilderValidators.numeric(),
                  ]),
                ),
                const SizedBox(height: 16),
                
                // Address
                FormBuilderTextField(
                  name: 'address',
                  decoration: InputDecoration(
                    labelText: 'Address',
                    prefixIcon: const Icon(Icons.home),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
                    ),
                  ),
                  validator: FormBuilderValidators.required(),
                ),
                const SizedBox(height: 16),
                
                // City & Zip Code (Row)
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: FormBuilderTextField(
                        name: 'city',
                        decoration: InputDecoration(
                          labelText: 'City',
                          prefixIcon: const Icon(Icons.location_city),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
                          ),
                        ),
                        validator: FormBuilderValidators.required(),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: FormBuilderTextField(
                        name: 'zipCode',
                        decoration: InputDecoration(
                          labelText: 'Zip Code',
                          prefixIcon: const Icon(Icons.map),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
                          ),
                        ),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                          FormBuilderValidators.numeric(),
                        ]),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                
                // Payment Method
                Text(
                  'Payment Method',
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                
                FormBuilderRadioGroup(
                  name: 'paymentMethod',
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                  ),
                  initialValue: 'Credit Card',
                  options: const [
                    FormBuilderFieldOption(
                      value: 'Credit Card',
                      child: Text('Credit Card'),
                    ),
                    FormBuilderFieldOption(
                      value: 'PayPal',
                      child: Text('PayPal'),
                    ),
                    FormBuilderFieldOption(
                      value: 'Apple Pay',
                      child: Text('Apple Pay'),
                    ),
                  ],
                  validator: FormBuilderValidators.required(),
                ),
                const SizedBox(height: 32),
                
                // Place Order Button
                AppButton(
                  text: _isSubmitting ? 'Processing...' : 'Place Order',
                  onPressed: _isSubmitting ? () {} : _submitOrder,
                  isLoading: _isSubmitting,
                  isFullWidth: true,
                  icon: Icons.shopping_cart_checkout,
                ),
                
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 