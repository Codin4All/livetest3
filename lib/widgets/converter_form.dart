import 'package:flutter/material.dart';

class ConverterForm extends StatefulWidget {
  const ConverterForm({super.key});

  @override
  State<ConverterForm> createState() => _ConverterFormState();
}

class _ConverterFormState extends State<ConverterForm> {
  final TextEditingController controller = TextEditingController();

  String selectedType = 'CF';

  String result = '';
  String? errorMessage;

  void calculateTemperature() {
    String input = controller.text.trim();

    if (input.isEmpty) {
      setState(() {
        errorMessage = 'Please enter temperature';
        result = '';
      });
      return;
    }

    double? temperature = double.tryParse(input);

    if (temperature == null || !temperature.isFinite) {
      setState(() {
        errorMessage = 'Please enter a valid number';
        result = '';
      });
      return;
    }

    double convertedTemperature;

    if (selectedType == 'CF') {
      convertedTemperature = (temperature * 9 / 5) + 32;
    } else {
      convertedTemperature = (temperature - 32) * 5 / 9;
    }

    setState(() {
      errorMessage = null;
      result = convertedTemperature.toStringAsFixed(2);
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 100),

        // Input and Dropdown Row
        Row(
          children: [
            // Temperature Input
            Expanded(
              child: TextField(
                controller: controller,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                  signed: true,
                ),
                decoration: const InputDecoration(
                  hintText: '0.0',
                  border: UnderlineInputBorder(),
                  contentPadding: EdgeInsets.all(12),
                ),
              ),
            ),

            const SizedBox(width: 15),

            // Dropdown
            Expanded(
              child: DropdownButtonFormField<String>(
                value: selectedType,

                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  contentPadding: EdgeInsets.all(12),
                ),

                items: const [
                  DropdownMenuItem(value: 'CF', child: Text('Fahrenheit')),

                  DropdownMenuItem(value: 'FC', child: Text('Celsius')),
                ],

                onChanged: (value) {
                  setState(() {
                    selectedType = value!;
                    result = '';
                    errorMessage = null;
                  });
                },
              ),
            ),
          ],
        ),

        const SizedBox(height: 50),

        // Error Message
        if (errorMessage != null)
          Text(
            errorMessage!,
            style: const TextStyle(color: Colors.red, fontSize: 14),
          ),

        // Convert Button
        SizedBox(
          width: double.infinity,
          height: 55,

          child: ElevatedButton(
            onPressed: calculateTemperature,

            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00A6C8),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),

            child: const Text(
              'Convert',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ),

        const SizedBox(height: 35),

        // Result
        if (result.isNotEmpty)
          Column(
            children: [
              const Text(
                'Result',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 10),

              Text(
                '$result ${selectedType == 'CF' ? '°F' : '°C'}',
                style: const TextStyle(
                  fontSize: 30,
                  color: Color(0xFF00A6C8),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
      ],
    );
  }
}
