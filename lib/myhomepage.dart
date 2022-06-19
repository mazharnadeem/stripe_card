import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_json_view/flutter_json_view.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}
var data;

class _MyHomePageState extends State<MyHomePage> {
  // const MyHomePage({Key? key}) : super(key: key);
  var paymentData;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            ElevatedButton(
              onPressed: () async {
                await makePayment();
              },
              child: Text('Pay with Stripe'),
            ),
            ElevatedButton(
              onPressed: ()  {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(data.toString())));
              },
              child: Text('Check Value'),
            ),
            // Text(data.toString()),
            Expanded(child: Container(
                child: JsonView.map(data))),
          ],
        ),
      ),
    );
  }

  makePayment() async{
    try{
      paymentData=await createPayment('5','USD');
      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
            paymentIntentClientSecret: paymentData['client_secret'],
            googlePay: true,
            applePay: true,
            style: ThemeMode.dark,
            merchantCountryCode: 'US',
            merchantDisplayName: 'Mazhar Nadeem'
          ));
      displayPaymentSheet();

    }catch(e){
      print('Make Payment Exception = ${e.toString()}');
    }
  }

  displayPaymentSheet() async{
    try{
      await Stripe.instance.presentPaymentSheet(
        parameters: PresentPaymentSheetParameters(clientSecret: paymentData['client_secret'],
        confirmPayment: true)
      );
      setState(() {
        paymentData=null;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Paid Successfully')));

    } on StripeException catch(e){
      print('Stripe Exception = $e');
      showDialog(context: context, builder: (_)=>AlertDialog(
        content: Text('Cancelled'),
      ));
    }

  }

  createPayment(String amount, String currency) async {
    try{
      var body={
        'amount': calculateAmount(amount),
        'currency':currency,
        'payment_method_types[]': 'card'
      };
      var response=await http.post(Uri.parse('https://api.stripe.com/v1/payment_intents'),
          body: body,
          headers: {
            'Authorization' :'Bearer sk_test_51L97r12345jA0fCP7bsOmGFo4H2jZlN5OBEPRxTZGRgcg4P1qUthOe3Uj1avbfEkJJU8O4xHyJaXPMxJxBwIx7obiYtqn00jc9Jhlyh',
            'Content-Type' : 'application/x-www-form-urlencoded'
          }
      );
      data=jsonDecode(response.body.toString());
      return data;

    }catch(e){
      print('Exception = ${e.toString()}}');
    }




  }

  calculateAmount(String amount) {
    var price=int.parse(amount)*100;
    return price.toString();
  }
}
