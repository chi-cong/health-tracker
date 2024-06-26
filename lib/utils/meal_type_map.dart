class MealTypeMap {
  int mealType;
  MealTypeMap({required this.mealType});
  String getMealLabel() {
    switch (mealType) {
      case 1:
        return 'Breakfast';

      case 2:
        return 'Launch';
      default:
        return 'Dinner';
    }
  }
}
