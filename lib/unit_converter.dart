class UnitConverter {
  static double feetInchesToMeters(double feet, double inches) {
    if (feet < 0 || inches < 0) {
      return 0.0; // Or throw an ArgumentError
    }
    double totalInches = (feet * 12) + inches;
    return totalInches * 0.0254;
  }

  static double cmToMeters(double cm) {
    if (cm < 0) {
      return 0.0; // Or throw an ArgumentError
    }
    return cm / 100.0;
  }
}
