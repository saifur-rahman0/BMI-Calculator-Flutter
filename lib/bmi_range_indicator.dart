import 'package:flutter/material.dart';

class BmiRangeIndicator extends StatelessWidget {
  final double bmiValue;

  const BmiRangeIndicator({Key? key, required this.bmiValue})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "BMI Categories:",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildRangeChip("Underweight", "< 18.5", bmiValue < 18.5, Colors.blue.shade300),
            _buildRangeChip("Healthy", "18.5-24.9", bmiValue >= 18.5 && bmiValue < 25, Colors.green.shade300),
            _buildRangeChip("Overweight", "25-29.9", bmiValue >= 25 && bmiValue < 30, Colors.orange.shade300),
            _buildRangeChip("Obese", ">= 30", bmiValue >= 30, Colors.red.shade300),
          ],
        ),
         const SizedBox(height: 10),
        // Simple line indicator (can be improved with CustomPainter for more complex visuals)
        Container(
          height: 10,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(
              colors: [Colors.blue.shade200, Colors.green.shade200, Colors.orange.shade200, Colors.red.shade200],
              stops: const [0.0, 0.4625, 0.625, 0.75], // Stops based on 18.5/40, 25/40, 30/40 (approx)
            ),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              double markerPosition = 0;
              // Normalize BMI to a 0-1 scale for positioning, capped at a max visual BMI of 40
              double normalizedBmi = (bmiValue.clamp(0, 40) / 40);
              markerPosition = normalizedBmi * constraints.maxWidth;

              // Ensure marker doesn't go out of bounds
              if (markerPosition < 0) 
                markerPosition = 0;
              if (markerPosition > constraints.maxWidth -5) 
                markerPosition = constraints.maxWidth -5; // 5 is approx width of marker
              
              return Stack(
                children: [
                  Positioned(
                    left: markerPosition,
                    child: Container(
                      width: 5,
                      height: 15,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text("0", style: TextStyle(fontSize: 10)),
            Text("18.5", style: TextStyle(fontSize: 10)),
            Text("25", style: TextStyle(fontSize: 10)),
            Text("30", style: TextStyle(fontSize: 10)),
            Text("40+", style: TextStyle(fontSize: 10)),
          ],
        )
      ],
    );
  }

  Widget _buildRangeChip(String category, String range, bool isActive, Color activeColor) {
    return Chip(
      label: Column(
        children: [
          Text(category, style: TextStyle(fontSize: 10, fontWeight: isActive? FontWeight.bold : FontWeight.normal)),
          Text(range, style: TextStyle(fontSize: 9, color: isActive? Colors.white: Colors.black54)),
        ],
      ),
      backgroundColor: isActive ? activeColor : Colors.grey.shade300,
      labelStyle: TextStyle(color: isActive ? Colors.white : Colors.black),
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
    );
  }
}
