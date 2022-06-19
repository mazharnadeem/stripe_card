import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:stripe_test/myhomepage.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey="pk_test_51L97rjA0fCP7bsOm1234564vGTFlIIogI0xngjJU1BquRXwDjEBsdqOrznbY576UiPcrDigpLpRbnPfR9FgEMEkacXxTcn005ZKRIPGy";

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stripe',
      theme: ThemeData(

      ),
      themeMode: ThemeMode.light,
      home: MyHomePage(),
    );
  }
}

