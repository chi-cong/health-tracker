import 'package:flutter/material.dart';

class TipList extends StatelessWidget {
  const TipList({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: <Widget>[
        ExpansionTile(
          title: Text('Underweight child (above 2 years old)'),
          children: [
            Text(
                '**DO** \n *Include more starchy carbohydrates such as potatoes, bread or rice in meals\n *Increase their calorie intake with healthy fats – add grated cheese to meals and make porridge with milk\n *Give them high-calorie drinks in between meals, such as milkshakes or smoothies\n *Encourage a healthy attitude to eating – include them in the food preparation and try to eat together\n *Have snacks available if they get hungry between meals – try yoghurts, breadsticks and small sandwiches\n *Help them get enough vitamins by giving children aged from 6 months old to 5 years old vitamin A, C and D drops every day\n *Introduce new foods gradually and in small portions – if they\'re a fussy eater this will help them get used to new foods \n **DON\'T** \n *Do not rely on unhealthy food for weight gain – swap cakes and crisps for a banana or cheese on crackers \n *Do not give them drinks and snacks before eating – they might be too full to eat and will miss out on essential nutrients\n *Try not to get frustrated if they do not eat everything on their plate – it might turn mealtimes into a negative experience\n *Do not stop them exercising – physical activity will help them develop stronger bones and muscles')
          ],
        )
      ],
    );
  }
}
