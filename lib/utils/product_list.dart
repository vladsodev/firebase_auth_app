import 'package:firebase_auth_app/services/database.dart';

final products = [
  {
    'id': 1,
    'name': 'Latte',
    'description': 'Coffee with milk. Life is simple!',
    'price': 150.0,
    'cold': false,
    'milky': true,
    'sweet': false,
    'sour': false,
    'strength': 1
  },
  {
    'id': 2,
    'name': 'Cappuccino',
    'description': 'Like a latte, but with more coffee!',
    'price': 130.0,
    'cold': false,
    'milky': true,
    'sweet': false,
    'sour': false,
    'strength': 2
  },
  {
    'id': 3,
    'name': 'Americano',
    'description': 'Coffee without milk.',
    'price': 100.0,
    'cold': false,
    'milky': false,
    'sweet': false,
    'sour': false,
    'strength': 3
  },
  {
    'id': 4,
    'name': 'Espresso',
    'description': 'Extra shot of coffee right in your heart.',
    'price': 70.0,
    'cold': false,
    'milky': false,
    'sweet': false,
    'sour': true,
    'strength': 4
  },
  {
    'id': 5,
    'name': 'Raf',
    'description': 'Like a latte, but with cream and vanilla sugar!',
    'price': 160.0,
    'cold': false,
    'milky': true,
    'sweet': true,
    'sour': false,
    'strength': 1
  },
  {
    'id': 6,
    'name': 'Flat White',
    'description': 'We need more caffeine! And a syrup, of course.',
    'price': 150.0,
    'cold': false,
    'milky': true,
    'sweet': true,
    'sour': true,
    'strength': 3
  },
  {
    'id': 7,
    'name': 'Black Tea',
    'description': 'Not a coffee. Just a cup of tea.',
    'price': 90.0,
    'cold': false,
    'milky': false,
    'sweet': false,
    'sour': false,
    'strength': 0
  },
  {
    'id': 8,
    'name': 'Cream Latte',
    'description': 'The softest texture and a syrup, yummy!',
    'price': 150.0,
    'cold': false,
    'milky': true,
    'sweet': true,
    'sour': false,
    'strength': 1
  },
  {
    'id': 9,
    'name': 'Green Tea',
    'description': 'Just a cup of green tea.',
    'price': 90.0,
    'cold': false,
    'milky': false,
    'sweet': false,
    'sour': true,
    'strength': 0
  },
  {
    'id': 10,
    'name': 'Ice Green Tea',
    'description': 'Just a cup of iced green tea.',
    'price': 100.0,
    'cold': true,
    'milky': false,
    'sweet': false,
    'sour': true,
    'strength': 0
  },
  {
    'id': 11,
    'name': 'Ice Black Tea',
    'description': 'Not a coffee. Just a cup of iced black tea.',
    'price': 100.0,
    'cold': true,
    'milky': false,
    'sweet': false,
    'sour': false,
    'strength': 0
  },
  {
    'id': 12,
    'name': 'Ice Latte',
    'description': 'Ice latte and chill',
    'price': 150.0,
    'cold': true,
    'milky': true,
    'sweet': false,
    'sour': false,
    'strength': 1
  },
  {
    'id': 12,
    'name': 'Ice Raf',
    'description': 'Ice raf and chill',
    'price': 160.0,
    'cold': true,
    'milky': true,
    'sweet': true,
    'sour': false,
    'strength': 1
  },
  {
    'id': 13,
    'name': 'Ice Cappuccino',
    'description': 'Like a ice latte, but with more coffee!',
    'price': 130.0,
    'cold': true,
    'milky': true,
    'sweet': false,
    'sour': false,
    'strength': 2
  },
  {
    'id': 14,
    'name': 'Orange Bumble',
    'description': 'Orange juice, ice and a shot of espresso. Perfect for a summer day!',
    'price': 160.0,
    'cold': true,
    'milky': false,
    'sweet': true,
    'sour': true,
    'strength': 1
  },
  {
    'id': 15,
    'name': 'Cherry Bumble',
    'description': 'Cherry juice, ice and a shot of espresso. Perfect for a summer day!',
    'price': 160.0,
    'cold': true,
    'milky': false,
    'sweet': true,
    'sour': true,
    'strength': 1
  },
];


void pipiska() async {

  for (var drink in products) {

    await DatabaseService().drinks.doc(drink['id'].toString()).set(
      {
        'id': drink['id'],
        'name': drink['name'],
        'description': drink['description'],
        'price': drink['price'],
        'cold': drink['cold'],
        'milky': drink['milky'],
        'sweet': drink['sweet'],
        'sour': drink['sour'],
        'strength': drink['strength'],
      },
    );
  }


}