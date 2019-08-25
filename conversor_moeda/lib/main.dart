import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request = "https://api.hgbrasil.com/finance?format=json&key=60df17606";

void main() async {
  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(
      hintColor: Colors.amber,
      primaryColor: Colors.white,
//      inputDecorationTheme: InputDecorationTheme(
//          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white))
//      )
    ),
  ));
}

Future<Map> getData() async {
  http.Response response = await http.get(request);
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  double dolar;
  double euro;

  final TextEditingController realController =  TextEditingController();
  final TextEditingController dolarController =  TextEditingController();
  final TextEditingController euroController =  TextEditingController();

  void _realChanged(String input) {
    if(input.isEmpty) {
      _clearAll();
      return;
    }

    double inReal = double.parse(input);
    dolarController.text = (inReal / this.dolar).toStringAsFixed(2);
    euroController.text = (inReal / this.euro / this.euro).toStringAsFixed(2);
  }

  void _dolarChanged(String input) {
    if(input.isEmpty) {
      _clearAll();
      return;
    }

    double inDolar = double.parse(input);
    realController.text = (inDolar * this.dolar).toStringAsFixed(2);
    euroController.text = (inDolar * this.dolar / this.euro).toStringAsFixed(2);
  }

  void _euroChanged(String input) {
    if(input.isEmpty) {
      _clearAll();
      return;
    }

    double inEuro = double.parse(input);
    realController.text = (inEuro * this.euro).toStringAsFixed(2);
    dolarController.text = (inEuro * this.euro / this.dolar).toStringAsFixed(2);
  }

  void _clearAll(){
    realController.text = "";
    dolarController.text = "";
    euroController.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("\$ Conversor \$"),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
       body: FutureBuilder<Map>(
         future: getData(),
         builder: (context, snapshot) {
            switch(snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(
                  child: Text(
                      "Carregando Dados...",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.amber,
                      fontSize: 25
                    ),
                  ),
                );
              default:
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      "Erro ao carregar Dados :(",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.amber,
                          fontSize: 25
                      ),
                    ),
                  );
                } else {
                  dolar = snapshot.data["results"]["currencies"]["USD"]["buy"];
                  euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];

                  return SingleChildScrollView(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Icon(Icons.monetization_on, size: 150, color: Colors.amber,),
                        buildTextField("Reais", "R\$", realController, _realChanged),
                        Divider(),
                        buildTextField("Dólares", "US\$", dolarController, _dolarChanged),
                        Divider(),
                        buildTextField("Euros", "€", euroController, _euroChanged),
                      ],
                    ),
                  );
                }
            }
         }),
   );
  }
}

Widget buildTextField(String label, String prefix, TextEditingController controller, Function func) {
  return TextField(
    controller: controller,
    onChanged: func,
    keyboardType: TextInputType.numberWithOptions(decimal: true),
    decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.amber),
        enabledBorder: OutlineInputBorder(borderSide: BorderSide( color:Colors.amber)),
        border: OutlineInputBorder(borderSide: BorderSide( color:Colors.amber),) ,
        prefixText: prefix
    ),
    style: TextStyle(
        color: Colors.amber, fontSize: 25
    ),
  );
}