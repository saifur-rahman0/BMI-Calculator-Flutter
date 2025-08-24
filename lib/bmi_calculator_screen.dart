import 'package:flutter/material.dart';
import 'package:bmi_calculator_flutter/bmi_range_indicator.dart';
import 'package:bmi_calculator_flutter/unit_converter.dart'; // Import the new converter

enum HeightUnit { feetInches, cm }

class BMICalculatorScreen extends StatefulWidget {
  const BMICalculatorScreen({super.key});

  @override
  State<BMICalculatorScreen> createState() => _BMICalculatorScreenState();
}

class _BMICalculatorScreenState extends State<BMICalculatorScreen> {
  final _formKey = GlobalKey<FormState>();
  final ScrollController _scrollController = ScrollController();
  var wtController = TextEditingController();
  var inchController = TextEditingController();
  var feetController = TextEditingController();
  var cmController = TextEditingController(); // New controller for CM

  String result = "";
  Color bgColor = Colors.indigo.shade100;
  String resultMessage = "";
  double bmiValue = 0.0;
  double minIdealWeight = 0.0;
  double maxIdealWeight = 0.0;
  String idealWeightMessage = "";

  HeightUnit _selectedHeightUnit = HeightUnit.feetInches; // State for selected unit

  @override
  void dispose() {
    _scrollController.dispose();
    wtController.dispose();
    inchController.dispose();
    feetController.dispose();
    cmController.dispose(); // Dispose new controller
    super.dispose();
  }

  void _calculateBMI() {
    if (_formKey.currentState!.validate()) {
      var weight = double.tryParse(wtController.text);
      double totalMeter = 0;

      if (_selectedHeightUnit == HeightUnit.feetInches) {
        var feet = double.tryParse(feetController.text);
        var inch = double.tryParse(inchController.text);
        if (feet != null && inch != null) {
          totalMeter = UnitConverter.feetInchesToMeters(feet, inch);
        }
      } else {
        var cm = double.tryParse(cmController.text);
        if (cm != null) {
          totalMeter = UnitConverter.cmToMeters(cm);
        }
      }

      if (weight != null && totalMeter > 0) {
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

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_scrollController.hasClients) {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOut,
            );
          }
        });
      } else {
        setState(() {
          resultMessage = "Height and Weight must be greater than 0.";
          result = "";
          bmiValue = 0.0;
          idealWeightMessage = "";
          minIdealWeight = 0.0;
          maxIdealWeight = 0.0;
          bgColor = Colors.grey.shade300;
        });
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

  Widget _buildHeightInputFields() {
    return AnimatedCrossFade(
      duration: const Duration(milliseconds: 300),
      firstChild: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: feetController,
              decoration: InputDecoration(
                labelText: "Height (feet)",
                hintText: "Enter feet",
                prefixIcon: const Icon(Icons.height),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: Colors.indigo.shade700, width: 2.0),
                ),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (_selectedHeightUnit == HeightUnit.feetInches) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter feet';
                  }
                  if (double.tryParse(value) == null || double.parse(value) < 0) {
                    return 'Please enter a valid value for feet';
                  }
                }
                return null;
              },
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextFormField(
              controller: inchController,
              decoration: InputDecoration(
                labelText: "Height (inches)",
                hintText: "Enter inches",
                prefixIcon: const Icon(Icons.unfold_more),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: Colors.indigo.shade700, width: 2.0),
                ),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (_selectedHeightUnit == HeightUnit.feetInches) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter inches';
                  }
                  final inches = double.tryParse(value);
                  if (inches == null || inches < 0 || inches >= 12) {
                    return 'Enter 0-11.99';
                  }
                }
                return null;
              },
            ),
          ),
        ],
      ),
      secondChild: TextFormField(
        controller: cmController,
        decoration: InputDecoration(
          labelText: "Height (cm)",
          hintText: "Enter your height in centimeters",
          prefixIcon: const Icon(Icons.height),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: Colors.indigo.shade700, width: 2.0),
          ),
        ),
        keyboardType: TextInputType.number,
        validator: (value) {
          if (_selectedHeightUnit == HeightUnit.cm) {
            if (value == null || value.isEmpty) {
              return 'Please enter your height in cm';
            }
            if (double.tryParse(value) == null || double.parse(value) <= 0) {
              return 'Please enter a valid height';
            }
          }
          return null;
        },
      ),
      crossFadeState: _selectedHeightUnit == HeightUnit.feetInches
          ? CrossFadeState.showFirst
          : CrossFadeState.showSecond,
      layoutBuilder: (topChild, topChildKey, bottomChild, bottomChildKey) {
        return Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Positioned(
              key: bottomChildKey,
              child: bottomChild,
            ),
            Positioned(
              key: topChildKey,
              child: topChild,
            ),
          ],
        );
      },
    );
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
            controller: _scrollController,
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
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: wtController,
                        decoration: InputDecoration(
                          labelText: "Weight (kg)",
                          hintText: "Enter your weight in kilograms",
                          prefixIcon: const Icon(Icons.fitness_center),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(color: Colors.indigo.shade700, width: 2.0),
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
                      ToggleButtons(
                        isSelected: [
                          _selectedHeightUnit == HeightUnit.feetInches,
                          _selectedHeightUnit == HeightUnit.cm,
                        ],
                        onPressed: (index) {
                          setState(() {
                            _selectedHeightUnit = index == 0 ? HeightUnit.feetInches : HeightUnit.cm;
                            // Clear fields when switching to prevent validation errors on hidden fields
                            if (_selectedHeightUnit == HeightUnit.feetInches) {
                              cmController.clear();
                            } else {
                              feetController.clear();
                              inchController.clear();
                            }
                             _formKey.currentState?.reset(); // Reset form to clear validation messages
                          });
                        },
                        borderRadius: BorderRadius.circular(10.0),
                        selectedColor: Colors.white,
                        color: Colors.indigo.shade700,
                        fillColor: Colors.indigo.shade400,
                        selectedBorderColor: Colors.indigo.shade700,
                        borderColor: Colors.indigo.shade200,

                        children: const [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text('Feet/Inches'),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text('Centimeters'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _buildHeightInputFields(),
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
                      AnimatedOpacity(
                        opacity: resultMessage.isNotEmpty ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 500),
                        child: Column(
                          children: [
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
                            if (resultMessage.isNotEmpty) const SizedBox(height: 10),
                            if (result.isNotEmpty)
                              Text(
                                result,
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey.shade700,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            if (result.isNotEmpty) const SizedBox(height: 15),
                            if (bmiValue > 0 && result.isNotEmpty)
                              BmiRangeIndicator(bmiValue: bmiValue),
                            if (bmiValue > 0 && result.isNotEmpty) const SizedBox(height: 15),
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
