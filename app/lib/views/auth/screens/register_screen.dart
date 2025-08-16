import 'package:flutter/material.dart';
import '../../registration/screens/registration_flow_screen.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Redirect to the new registration flow
    return const RegistrationFlowScreen();
  }
}