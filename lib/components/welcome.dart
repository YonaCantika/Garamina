import 'package:flutter/material.dart';
import '../auth_state.dart';
import 'package:provider/provider.dart';

class WelcomeSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authState = Provider.of<AuthState>(context);

    return Container(
      color: Colors.blue,
      height: 100,
      padding: const EdgeInsets.all(16),
      child: Center(
        child: Text(
          authState.namaUser ?? '',
          style: const TextStyle(
            fontSize: 24,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
