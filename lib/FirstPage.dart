import 'package:flutter/material.dart';

class FirstPage extends StatelessWidget {
  const FirstPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.network(
            'https://www.incharge.org/wp-content/uploads/2015/06/Cutting-Expenses.gif',
            fit: BoxFit.cover,
            width: MediaQuery.of(context).size.width * 1.4,
            height: double.infinity,
          ),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: FloatingActionButton(
              backgroundColor: const Color.fromARGB(255, 66, 191, 196),
              tooltip: 'Navigate to Home',
              onPressed: () {
                Navigator.pushNamed(context, '/Home');
              },
              child: const Icon(Icons.home, color: Colors.white, size: 28),
            ),
          ),
        ],
      ),
    );
  }
}
