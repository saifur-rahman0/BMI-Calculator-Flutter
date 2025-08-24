# BMI Calculator Flutter App

## Description
A simple and user-friendly Flutter application to calculate Body Mass Index (BMI). Users can input their height (in centimeters) and weight (in kilograms) to get their BMI score. The app also displays the BMI category (Underweight, Healthy, Overweight, Obese), visually indicates the BMI on a range slider, and provides an ideal weight range for the entered height.

## Features

*   **Splash Screen**: An initial screen displayed when the app starts.
*   **User-Friendly Input**: Clear input fields for height and weight (kg).
*   **BMI Calculation**: Accurately calculates BMI using the standard formula.
*   **BMI Category**: Displays the category based on the calculated BMI:
    *   Underweight: BMI < 18.5
    *   Healthy: 18.5 <= BMI < 25
    *   Overweight: 25 <= BMI < 30
    *   Obese: BMI >= 30
*   **Visual BMI Range Indicator**: A slider-like visual that shows where the user's BMI falls within the different categories.
*   **Ideal Weight Range**: Shows the healthy weight range for the user's height.
*   **Dynamic Background**: The background color of the results area subtly changes based on the BMI category.


## Getting Started

This project is a starting point for a Flutter application.

To get started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

1.  **Clone the repository:**
    ```bash
    git clone https://your-repository-url/bmi_calculator_flutter.git
    cd bmi_calculator_flutter
    ```
2.  **Install dependencies:**
    ```bash
    flutter pub get
    ```
3.  **Run the app:**
    ```bash
    flutter run
    ```

## Project Structure

Key files in the application:

*   `lib/main.dart`: The main entry point of the application, initializes the app and navigates to the splash screen.
*   `lib/splash_screen.dart`: Implements the splash screen UI and navigation logic.
*   `lib/bmi_calculator_screen.dart`: Contains the UI and logic for the main BMI calculation screen.
*   `lib/bmi_range_indicator.dart`: A separate widget to display the BMI range and the current BMI's position on it.

## Future Enhancements

*   BMI History: Store and display past BMI calculations.
*   Health Tips: Provide health tips based on the BMI category.
*   Unit Preference: Allow users to choose between metric (kg/cm) and imperial (lbs/ft-in) units.
*   Theme Customization: Offer different themes or dark mode.
