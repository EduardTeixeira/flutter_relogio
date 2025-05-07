import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Input extends StatelessWidget {
  var ctrl = TextEditingController();

  Input({super.key, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: ctrl,
      keyboardType: TextInputType.number,
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 50),
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly,
      ],
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0), // Bordas arredondadas
          borderSide: BorderSide(
            color: Colors.blue, // Cor da borda
            width: 2.0, // Largura da borda
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: Colors.green, width: 2.0),
        ),
      ),
    );
  }
}
