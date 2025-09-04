import 'package:expense_tracker/app_state.dart';
import 'package:expense_tracker/enums/index.dart';
import 'package:expense_tracker/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class BalanceInputScreen extends StatefulWidget {
  const BalanceInputScreen({super.key});

  @override
  State<BalanceInputScreen> createState() => _BalanceInputScreenState();
}

class _BalanceInputScreenState extends State<BalanceInputScreen> {
  final TextEditingController _balanceController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _balanceController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      final appState = Provider.of<ApplicationState>(context, listen: false);
      final balance = int.parse(_balanceController.text.replaceAll(" ", ""));

      // Set initial balance
      await appState.setBalance(balance);
      // Update onboarding status
      await appState.updateOnboardingStatus(OnboardingStatus.balanceSet);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Spacer(),
                const Text(
                  'What\'s your current balance?',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: const Text(
                    "enter how much money your saving right now, to start tracking your financial",
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.gray,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _balanceController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  inputFormatters: [
                    TextInputFormatter.withFunction((oldValue, newValue) {
                      // Remove any existing spaces
                      final text = newValue.text.replaceAll(' ', '');
                      // Add a space every 3 digits from the right
                      final buffer = StringBuffer();
                      for (int i = 0; i < text.length; i++) {
                        if (i > 0 && (text.length - i) % 3 == 0) {
                          buffer.write(' ');
                        }
                        buffer.write(text[i]);
                      }
                      return TextEditingValue(
                        text: buffer.toString(),
                        selection: TextSelection.collapsed(offset: buffer.length),
                      );
                    }),
                  ],
                  decoration: const InputDecoration(
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Center(
                          child: Text(
                            "Balance",
                            style: TextStyle(
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    suffixText: "DH",
                    hintText: 'Enter your current balance',
                    border: OutlineInputBorder(),
                    floatingLabelAlignment: FloatingLabelAlignment.center,
                    alignLabelWithHint: true,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your balance';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _handleSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.surface,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Continue',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
