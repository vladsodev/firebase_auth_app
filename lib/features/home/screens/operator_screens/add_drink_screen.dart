import 'package:firebase_auth_app/features/auth/controller/auth_controller.dart';
import 'package:firebase_auth_app/models/drink.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

class AddDrinkScreen extends ConsumerStatefulWidget {
  const AddDrinkScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddDrinkScreenState();
}

class _AddDrinkScreenState extends ConsumerState<AddDrinkScreen> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String description = '';
  double price = 0.0;
  bool cold = false;
  bool milky = false;
  bool sweet = false;
  bool sour = false;
  int strength = 1;

  void addDrink(Drink drink) {
    final user = ref.read(userProvider)!;
    ref.read(authControllerProvider.notifier).addNewDrink(user.uid, drink);
  }

  Future<void> _addDrink() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final drinkData = {
        'id': 000,
        'name': name,
        'description': description,
        'price': price,
        'cold': cold,
        'milky': milky,
        'sweet': sweet,
        'sour': sour,
        'strength': strength,
      };

      addDrink(Drink.fromMap(drinkData));
      
      // Вернуться назад после добавления
      Routemaster.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Drink'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Name'),
                onSaved: (value) {
                  name = value!;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Description'),
                onSaved: (value) {
                  description = value!;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                onSaved: (value) {
                  price = double.parse(value!);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a price';
                  }
                  return null;
                },
              ),
              SwitchListTile(
                title: const Text('Cold'),
                value: cold,
                onChanged: (value) {
                  setState(() {
                    cold = value;
                  });
                },
              ),
              SwitchListTile(
                title: const Text('Milky'),
                value: milky,
                onChanged: (value) {
                  setState(() {
                    milky = value;
                  });
                },
              ),
              SwitchListTile(
                title: const Text('Sweet'),
                value: sweet,
                onChanged: (value) {
                  setState(() {
                    sweet = value;
                  });
                },
              ),
              SwitchListTile(
                title: const Text('Sour'),
                value: sour,
                onChanged: (value) {
                  setState(() {
                    sour = value;
                  });
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Strength'),
                keyboardType: TextInputType.number,
                onSaved: (value) {
                  strength = int.parse(value!);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a strength value';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addDrink,
                child: const Text('Add Drink'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
