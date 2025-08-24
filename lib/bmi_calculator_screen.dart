import 'package:flutter/material.dart';
import 'package:bmi_calculator_flutter/bmi_range_indicator.dart'; // Import the separated widget

class BMICalculatorScreen extends StatefulWidget {
  const BMICalculatorScreen({super.key});

  @override
  State<BMICalculatorScreen> createState() => _BMICalculatorScreenState();
}

class _BMICalculatorScreenState extends State<BMICalculatorScreen> {
  final _formKey = GlobalKey<FormState>();
  var wtController = TextEditingController();
  var inchController = TextEditingController();
  var feetController = TextEditingController();
  String result = "";
  Color bgColor = Colors.indigo.shade100; // Softer initial color
  String resultMessage = "";
  double bmiValue = 0.0;
  double minIdealWeight = 0.0;
  double maxIdealWeight = 0.0;
  String idealWeightMessage = "";

  void _calculateBMI() {
    if (_formKey.currentState!.validate()) {
      var weight = double.tryParse(wtController.text);
      var feet = double.tryParse(feetController.text);
      var inch = double.tryParse(inchController.text);

      if (weight != null && feet != null && inch != null) {
        var totalInch = (feet * 12) + inch;
        var totalMeter = totalInch * 0.0254; // Direct conversion to meters

        if (totalMeter > 0) {
          bmiValue = weight / (totalMeter * totalMeter);
          String msg = "";
          Color tempBgColor = bgColor;

          if (bmiValue >= 30) {
            msg = "You are Obese";
            tempBgColor = Colors.red.shade300;
          } else if (bmiValue >= 25) {
            msg = "You are Overweight";
            tempBgColor = Colors.orange.shade300;
          } else if (bmiValue >= 18.5) {
            msg = "You are Healthy";
            tempBgColor = Colors.green.shade300;
          } else {
            msg = "You are Underweight";
            tempBgColor = Colors.blue.shade300;
          }

          minIdealWeight = 18.5 * (totalMeter * totalMeter);
          maxIdealWeight = 24.9 * (totalMeter * totalMeter);
          idealWeightMessage =
              "For your height, a healthy weight range is ${minIdealWeight.toStringAsFixed(1)} kg - ${maxIdealWeight.toStringAsFixed(1)} kg.";

          setState(() {
            resultMessage = msg;
            result = "Your BMI is ${bmiValue.toStringAsFixed(2)}";
            bgColor = tempBgColor;
            this.minIdealWeight = minIdealWeight;
            this.maxIdealWeight = maxIdealWeight;
            this.idealWeightMessage = idealWeightMessage;
          });
        } else {
          setState(() {
            resultMessage = "Height must be greater than 0.";
            result = "";
            bmiValue = 0.0;
            idealWeightMessage = "";
            minIdealWeight = 0.0;
            maxIdealWeight = 0.0;
            bgColor = Colors.grey.shade300;
          });
        }
      }
    } else {
      setState(() {
        resultMessage = "Please fill all fields correctly.";
        result = "";
        bmiValue = 0.0;
        idealWeightMessage = "";
        minIdealWeight = 0.0;
        maxIdealWeight = 0.0;
        bgColor = Colors.grey.shade300;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("BMI Calculator"),
        backgroundColor: Colors.indigo,
        elevation: 0,
      ),
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        color: bgColor,
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Card(
              elevation: 8.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Calculate Your BMI",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo.shade700,
                        ),
                      ),
                      const SizedBox(height: 30),
                      TextFormField(
                        controller: wtController,
                        decoration: InputDecoration(
                          labelText: "Weight (kg)",
                          hintText: "Enter your weight in kilograms",
                          prefixIcon: const Icon(Icons.fitness_center),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your weight';
                          }
                          if (double.tryParse(value) == null ||
                              double.parse(value) <= 0) {
                            return 'Please enter a valid weight';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: feetController,
                        decoration: InputDecoration(
                          labelText: "Height (feet)",
                          hintText: "Enter feet",
                          prefixIcon: const Icon(Icons.height),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter feet';
                          }
                          if (double.tryParse(value) == null ||
                              double.parse(value) < 0) {
                            return 'Please enter a valid value for feet';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: inchController,
                        decoration: InputDecoration(
                          labelText: "Height (inches)",
                          hintText: "Enter inches",
                          prefixIcon: const Icon(Icons.unfold_more),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter inches';
                          }
                          final inches = double.tryParse(value);
                          if (inches == null || inches < 0 || inches >= 12) {
                            return 'Enter a value between 0 and 11.99';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: _calculateBMI,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 15),
                          textStyle: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: const Text("CALCULATE", style: TextStyle(color: Colors.white)),
                      ),
                      const SizedBox(height: 30),
                      if (resultMessage.isNotEmpty)
                        Text(
                          resultMessage,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.indigo.shade900,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      const SizedBox(height: 10),
                      if (result.isNotEmpty)
                        Text(
                          result,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey.shade700,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      const SizedBox(height: 15),
                      if (bmiValue > 0 && result.isNotEmpty)
                        BmiRangeIndicator(bmiValue: bmiValue),
                      const SizedBox(height: 15),
                      if (idealWeightMessage.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            idealWeightMessage,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.indigo.shade700,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
