class MealTypeMap {
  int mealType;
  MealTypeMap({required this.mealType});
  String getMealLabel() {
    switch (mealType) {
      case 1:
        return 'Bữa sáng';
      case 2:
        return 'Bữa trưa';
      default:
        return 'Bữa tối';
    }
  }
}
