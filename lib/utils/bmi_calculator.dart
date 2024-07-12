import 'dart:math';

class BmiCalculator {
  BmiCalculator();

  getBmi(double height, double weight) {
    return num.parse((weight / pow((height / 100), 2)).toStringAsFixed(1));
  }

  getClassification(double bmi, String? bodyType) {
    if (bodyType != null && bodyType == 'asian') {
      if (bmi < 18.5) {
        return 'Gầy';
      } else if (18.5 <= bmi && bmi < 23) {
        return 'Cân đối';
      } else if (23 <= bmi && bmi < 25) {
        return 'Thừa cân';
      } else if (25 <= bmi && bmi < 30) {
        return 'Béo phì mức 1';
      } else if (30 <= bmi) {
        return 'Béo phì mức 2';
      }
    } else {
      if (bmi < 16) {
        return 'Rất gầy';
      } else if (16 <= bmi && bmi < 17) {
        return 'Khá gầy';
      } else if (17 <= bmi && bmi < 18.5) {
        return 'Gầy';
      } else if (18.5 <= bmi && bmi < 25) {
        return 'Cân đối';
      } else if (25 <= bmi && bmi < 30) {
        return 'Thừa cân';
      } else if (30 <= bmi && bmi < 35) {
        return 'Béo phì mức 1';
      } else if (35 <= bmi && bmi < 40) {
        return 'Béo phì mức 2';
      } else {
        return 'Béo phì mức 3';
      }
    }
    return 'Không xác định';
  }
}
