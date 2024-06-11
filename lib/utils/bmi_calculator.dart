import 'dart:math';

class BmiCalculator {
  BmiCalculator();

  getBmi(double height, double weight) {
    return num.parse((weight / pow((height / 100), 2)).toStringAsFixed(1));
  }

  getClassification(double bmi) {
    if (bmi < 16) {
      return 'Severe Thinness';
    } else if (16 <= bmi && bmi < 17) {
      return 'Moderate Thinness';
    } else if (17 <= bmi && bmi < 18.5) {
      return 'Mild Thinness';
    } else if (18.5 <= bmi && bmi < 25) {
      return 'Normal';
    } else if (25 <= bmi && bmi < 30) {
      return 'Overweight';
    } else if (30 <= bmi && bmi < 35) {
      return 'Obese Class 1';
    } else if (35 <= bmi && bmi < 40) {
      return 'Obese Class 2';
    } else {
      return 'Obese Class 3';
    }
  }
}
