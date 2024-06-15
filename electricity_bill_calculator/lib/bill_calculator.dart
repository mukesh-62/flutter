// lib/bill_calculator.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(BillCalculatorApp());

class BillCalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Electricity Bill Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BillCalculatorScreen(),
    );
  }
}

class BillCalculatorScreen extends StatefulWidget {
  @override
  _BillCalculatorScreenState createState() => _BillCalculatorScreenState();
}

class _BillCalculatorScreenState extends State<BillCalculatorScreen> {
  TextEditingController _usageController = TextEditingController();
  double _billAmount = 0.0;
  List<String> _previousBills = [];

  @override
  void initState() {
    super.initState();
    _loadPreviousBills();
  }

  _loadPreviousBills() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _previousBills = (prefs.getStringList('previousBills') ?? []);
    });
  }

  _saveBill(double bill) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _previousBills.add(bill.toStringAsFixed(2));
      prefs.setStringList('previousBills', _previousBills);
    });
  }

  _calculateBill() {
    double usage = double.tryParse(_usageController.text) ?? 0.0;
    double rate = 0.15; // Example rate per kWh
    double bill = usage * rate;
    setState(() {
      _billAmount = bill;
    });
    _saveBill(bill);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Electricity Bill Calculator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _usageController,
              decoration: InputDecoration(
                labelText: 'Enter electricity usage (kWh)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _calculateBill,
              child: Text('Calculate Bill'),
            ),
            SizedBox(height: 16.0),
            Text(
              'Bill Amount: \$${_billAmount.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 24.0),
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: _previousBills.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('Bill: \$${_previousBills[index]}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
