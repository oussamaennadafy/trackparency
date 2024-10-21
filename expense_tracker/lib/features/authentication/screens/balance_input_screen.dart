import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:expense_tracker/app_state.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class BalanceInputScreen extends StatefulWidget {
  const BalanceInputScreen({super.key});

  @override
  BalanceInputScreenState createState() => BalanceInputScreenState();
}

class BalanceInputScreenState extends State<BalanceInputScreen> {
  final _controller = TextEditingController();
  final _formatter = NumberFormat("#,##0", "en_US");

  @override
  void initState() {
    super.initState();
    _controller.addListener(_formatCurrency);
  }

  void _formatCurrency() {
    if (_controller.text.isNotEmpty) {
      final rawValue = _controller.text.replaceAll(',', '');
      final number = int.tryParse(rawValue);
      if (number != null) {
        final formattedValue = _formatter.format(number);
        _controller.value = _controller.value.copyWith(
          text: formattedValue,
          selection: TextSelection.collapsed(offset: formattedValue.length),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'How much money do you have?',
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _controller,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly
                ],
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Current Balance',
                  prefixText: '\$',
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  final balance = int.tryParse(_controller.text.replaceAll(',', ''));
                  if (balance != null) {
                    context.read<ApplicationState>().setBalance(balance);
                    context.go('/');
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter a valid number')),
                    );
                  }
                },
                child: const Text('Continue'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.removeListener(_formatCurrency);
    _controller.dispose();
    super.dispose();
  }
}
