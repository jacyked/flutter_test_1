import 'dart:ffi';
import 'dart:math';

import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:flutter_test_1/boxes.dart';
import 'package:flutter_test_1/wordle.dart';
import 'package:provider/provider.dart';

import 'package:hive_flutter/hive_flutter.dart';

void main() async{ 


  //runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Wordle Practice App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 19, 221, 204)),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current  = "";


  var currGuess = ["","","","",""];
  List pastGuesses = [[0]];

  void updateCurrGuess(index, text){
    print("Index: $index Text: $text");
    currGuess[index] = text;
    
  }

  void addGuess(){
    var toAdd = currGuess.join().toUpperCase();
    if(pastGuesses[0][0] == 0){
      pastGuesses[0] = toAdd;
    }
    else{
      pastGuesses.add(toAdd);
    }
    print(pastGuesses);
    notifyListeners();
  }

  Future<void> getWordle() async{
    var thisWordle = "";
    final String response = await rootBundle.loadString('assets/sample.json');
    final data = await json.decode(response);
    var intValue = Random().nextInt(2314);
    thisWordle = data[intValue];

    current = thisWordle;
  }

}



class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GuessCard(pastGuesses: appState.pastGuesses,),
            
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(child: 
                  TextField(
                    textInputAction: TextInputAction.next,
                    maxLength: 1,
                    onChanged: (text) {
                      appState.updateCurrGuess(0, text);
                    },
                    decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '',
                    counterText: '',
                    ),)
                  ),
                  SizedBox(width: 10),
                  Expanded(child: 
                  TextField(
                    textInputAction: TextInputAction.next,
                    maxLength: 1,
                    onChanged: (text) {
                      appState.updateCurrGuess(1, text);
                    },
                    decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '',
                    counterText: '',
                    ),)
                  ),
                  SizedBox(width: 10),
                  Expanded(child: 
                  TextField(
                    textInputAction: TextInputAction.next,
                    maxLength: 1,
                    onChanged: (text) {
                      appState.updateCurrGuess(2, text);
                    },
                    decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '',
                    counterText: '',
                    ),)
                  ),
                  SizedBox(width: 10),
                  Expanded(child: 
                  TextField(
                    textInputAction: TextInputAction.next,
                    maxLength: 1,
                    onChanged: (text) {
                      appState.updateCurrGuess(3, text);
                    },
                    decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '',
                    counterText: '',
                    ),)
                  ),
                  SizedBox(width: 10),
                  Expanded(child: 
                  TextField(
                    textInputAction: TextInputAction.done,
                    maxLength: 1,
                    onChanged: (text) {
                      appState.updateCurrGuess(4, text);
                    },
                    decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '',
                    counterText: '',
                    ),)
                  ),
                  
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                appState.addGuess();
              }, 
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}


class GuessCard extends StatelessWidget {
  const GuessCard({
    super.key,
    required this.pastGuesses,
  });

  final List pastGuesses;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); 
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    if(pastGuesses[0][0] == 0){
      return Container();
    }
    else{
      print(pastGuesses);
    return Expanded(
      child: ListView.builder(
        itemCount: pastGuesses.length,
        itemBuilder: (BuildContext ctxt, int index){
          return Row(children: [
            Card(
            color: theme.colorScheme.primary,
            child: Padding(
              padding: const EdgeInsets.all(20),
                child: Text(pastGuesses[index][0], style: style),
              ),
            ),
            Card(
            color: theme.colorScheme.primary,
            child: Padding(
              padding: const EdgeInsets.all(20),
                child: Text(pastGuesses[index][1], style: style),
              ),
            ),
            Card(
            color: theme.colorScheme.primary,
            child: Padding(
              padding: const EdgeInsets.all(20),
                child: Text(pastGuesses[index][2], style: style),
              ),
            ),
            Card(
            color: theme.colorScheme.primary,
            child: Padding(
              padding: const EdgeInsets.all(20),
                child: Text(pastGuesses[index][3], style: style),
              ),
            ),
            Card(
            color: theme.colorScheme.primary,
            child: Padding(
              padding: const EdgeInsets.all(20),
                child: Text(pastGuesses[index][4], style: style),
              ),
            ),
          ],);
        },
      ),
    );
    }
  }
}

class CurrentGuess extends StatelessWidget{
  const CurrentGuess({
    super.key,
    
  });

  

  @override
  Widget build(BuildContext context) {
    
    return Row(
      children: [
        TextField(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
        
      ],
    );
    
  }
}