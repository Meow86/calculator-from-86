import 'package:calculator1/buttonvalue.dart';
import 'package:flutter/material.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
    String num1 = '';
    String operand = '';
    String num2 = '';
  @override
  Widget build(BuildContext context) {

    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                reverse: true,
                child: Container(
                  padding: EdgeInsets.all(15),
                  alignment: Alignment.bottomRight,
                  child: Text('$num1$operand$num2'.isEmpty?'0':'$num1$operand$num2', 
                  style: TextStyle(fontWeight: FontWeight(700), fontSize: 50), textAlign: TextAlign.end,)
                  
                ),
              ),
            ),
          //button
          Wrap(
            children: Btn.buttonValues.map((value) => SizedBox(
              width: value==Btn.n0?screenSize.width/2:(screenSize.width/4),
              height: screenSize.width/5,
              child: buildButton(value)
            )).toList(),
          )
          ]
        ),
      ),
    );
  }

Widget buildButton (value) {
  return SizedBox(

    child: Padding(
      padding: EdgeInsets.all(2),
      child: Material(
        color: ButtonColor(value),
        clipBehavior: Clip.hardEdge,
        shape: OutlineInputBorder( 
          borderRadius: BorderRadius.circular(7), 
          borderSide: BorderSide(color: const Color.fromARGB(255, 170, 170, 170))
        ),
        child: InkWell(
          onTap: () => onBtnTap(value),
          child: Center(
            child: Text(value, style: value==Btn.per
              ?TextStyle(fontSize: 39, fontWeight: FontWeight(880))
              :TextStyle(fontSize: 34, fontWeight: FontWeight(700)),
            )
          ),
        ),
      ),
    )
  );
}


void onBtnTap(String value) {

  if(num1=='infinity') num1 = '';
  if(num1=='NaN') num1 = '';

  if(value==Btn.del) {del(); return;}

  if(value==Btn.clr) {clr(); return;}

  if(value==Btn.per) {per(); return;}

  if(value==Btn.calculate) {calculate(); return;}

  allnums(value);
  
}



void calculate() {
  if(num1.isEmpty) return;
  if(operand.isEmpty) return;
  if(num2.isEmpty) return;

  final numb1 = double.parse(num1);
  final numb2 = double.parse(num2);

  dynamic res = 0.0;

  switch (operand) {
    case Btn.add:
      res = numb1 + numb2;
      break;
    case Btn.divide:
      switch(numb2) {
        case 0:
        switch(numb1){
          case 0:
          res='NaN';
          break;
          default: res='infinity';
        }
        break;
        default: res = numb1 / numb2;
      }
      break;
    case Btn.multiply:
      res = numb1 * numb2;
      break;
    case Btn.subtract:
      res = numb1 - numb2;
      break;
    
    default:
  }
  setState(() {
    num1='$res'; 
    if(num1.endsWith('.0')){num1=num1.substring(0, num1.length-2);} 
    operand='';
    num2='';
  });
  
}

void per(){
  if (num1.isNotEmpty&&operand.isNotEmpty&&num2.isNotEmpty){
    calculate();
  final num =double.parse(num1);
  setState(() {
    num1='${(num/100)}';
    operand = '';
    num2 = '';
  });
  }

  if (operand.isNotEmpty) return;
  final num =double.parse(num1);
  setState(() {
    num1='${(num/100)}';
    operand = '';
    num2 = '';
  });
}

void clr() {
  setState(() {
    num1='';
    operand='';
    num2='';
  });
}

void del() {
  if(num2.isNotEmpty){
    num2=num2.substring(0, num2.length-1);
  }else if(operand.isNotEmpty){
    operand='';
  }else if(num1.isNotEmpty){
    num1=num1.substring(0, num1.length-1);
  }
  setState(() {});
}

void allnums(String value){
  if(value != Btn.dot && int.tryParse(value)==null) {
    if(operand.isNotEmpty&&num2.isNotEmpty){
      calculate();
    }

    operand=value;
  }else if(num1.isEmpty||operand.isEmpty){
    if(value==Btn.dot && num1.contains(Btn.dot)){
      return;
    }
    if(value==Btn.dot&&(num1.isEmpty||num1==Btn.dot)){
      value = '0.';
    }
    if((num1=='0')&&value==Btn.n0){
      value = '';
    }
    num1 +=value;
  }else if(num2.isEmpty||operand.isNotEmpty){
    if(value==Btn.dot && num2.contains(Btn.dot)){
      return;
    }
    if(value==Btn.dot&&(num2.isEmpty||num2==Btn.dot)){
      value = '0.';
    }
    if((num2=='0')&&value==Btn.n0){
      value = '';
    }
    num2 +=value;
  }
  setState(() {});
}

Color ButtonColor (value) {
  return [Btn.del, Btn.clr].contains(value)
    ?const Color.fromARGB(255, 160, 160, 160)
    :[Btn.per, Btn.multiply, Btn.divide, Btn.add, Btn.subtract, Btn.calculate].contains(value)
    ?const Color.fromARGB(255, 54, 54, 54)
    :const Color.fromARGB(255, 24, 24, 24);
}
}

