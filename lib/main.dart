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


  runApp(MyApp());
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
  var index = 0;
  var currGuess = ["","","","",""];
  List pastGuesses = [[0]];
  var wordList = [];
  var guessed = 0;
  var buttonText = "Submit";
  

  void updateCurrGuess(index, text){
    print("Index: $index Text: $text");
    currGuess[index] = text;
    
  }

  void addGuess(){
    var toAdd = currGuess.join().toLowerCase();
    print("Guess: $toAdd Word: $current");
    if(wordList.isEmpty){
      loadWordles();
    }
    if(!wordList.contains(toAdd)){
      print("Not found");
      //Error message
      return;
    }
    toAdd = toAdd.toUpperCase();
    if(pastGuesses[0][0] == 0){
      pastGuesses[0] = toAdd;
    }
    else{
      pastGuesses.add(toAdd);
    }
    print(pastGuesses);
    if(toAdd == current){
      guessed = 1;
      buttonText = "Next";
    }
    notifyListeners();
  }

  void getNext() {
    guessed = 0;
    buttonText = "Submit";
    currGuess = ["","","","",""];
    pastGuesses = [[0]];
    getWordle();

  }

  Future<void> loadWordles() async{
    final String response = await rootBundle.loadString('assets/wordle.json');
    final data = await json.decode(response);
    wordList = data;

  }

  Future<void> getWordle() async{
    if(wordList.isEmpty){
      await loadWordles();
    }
    var intValue = Random().nextInt(wordList.length - 1);
    current = wordList[intValue].toUpperCase();
    print("Word: $current");
    notifyListeners();
  }

  void start(){
    index = 1;
    notifyListeners();
  }

}


class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var wordle = "";
  var index = 0;
  

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    index = appState.index;

    Widget page;

    switch (index) {
      case 0:
        page = StartPage();
        break;
      case 1:
        page = GeneratorPage();
        break;
      default:
        throw UnimplementedError('no widget for $index');
    }
    return Scaffold(
      body: 
          Container(
              child: page,
            ),
          
        );
  }
}

class StartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
              onPressed: () {
                appState.getWordle();
                appState.start();
              }, 
              child: Text('Start'),
            ),
            
        ],
      )
    );
  }

}

class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var wordle = appState.current;



    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SafeArea(child: Text("Reload")),
          GuessCard(pastGuesses: appState.pastGuesses,
          wordle: appState.current,),
          SafeArea(
            child: Column(children: [ 
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
              Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ElevatedButton(
                    onPressed: () {
                      if(appState.guessed == 1){appState.getNext();}else{appState.addGuess();}
                    }, 
                    child: Text(appState.buttonText),
                  ),
                ),
                ],),
          ), 
              
        ]),
    );
  }
}


class GuessCard extends StatelessWidget {
  const GuessCard({
    super.key,
    required this.pastGuesses,
    required this.wordle,
  });

  final List pastGuesses;
  final String wordle;
  



  @override
  Widget build(BuildContext context) {
    final List<String> wordleArr = wordle.split("");
    final theme = Theme.of(context); 
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    if(pastGuesses[0][0] == 0){
      return Container();
    }
    else{
      print(pastGuesses);

    Color getColour(String thisGuess, int index){
      print("Word: $wordleArr");
      print("Get Colour for $index slot: $thisGuess");
      
      if(wordleArr[index] == thisGuess){
        return theme.colorScheme.primary;
      }
      if(wordleArr.contains(thisGuess)){
        return theme.colorScheme.error;
      }
      else{
        return theme.colorScheme.outline;
      }
    }

    return Expanded(
      child: ListView.builder(
        itemCount: pastGuesses.length,
        itemBuilder: (BuildContext ctxt, int index){
          return Row(children: [
            Expanded(child: Card(
            color: getColour(pastGuesses[index][0], 0),
            child: Padding(
              padding: const EdgeInsets.all(10),
                child: Text(pastGuesses[index][0], textAlign: TextAlign.center, style: style),
              ),
            ),),Expanded(child: Card(
            color: getColour(pastGuesses[index][1], 1),
            child: Padding(
              padding: const EdgeInsets.all(10),
                child: Text(pastGuesses[index][1], textAlign: TextAlign.center, style: style),
              ),
            ),),Expanded(child: Card(
            color: getColour(pastGuesses[index][2], 2),
            child: Padding(
              padding: const EdgeInsets.all(10),
                child: Text(pastGuesses[index][2], textAlign: TextAlign.center, style: style),
              ),
            ),),Expanded(child: Card(
            color: getColour(pastGuesses[index][3], 3),
            child: Padding(
              padding: const EdgeInsets.all(10),
                child: Text(pastGuesses[index][3], textAlign: TextAlign.center, style: style),
              ),
            ), ),Expanded(child: Card(
            color: getColour(pastGuesses[index][4], 4),
            child: Padding(
              padding: const EdgeInsets.all(10),
                child: Text(pastGuesses[index][4], textAlign: TextAlign.center, style: style),
              ),
            ),),
            
            
            
            
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