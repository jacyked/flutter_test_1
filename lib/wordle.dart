import 'package:hive/hive.dart';

part 'wordle.g.dart';

@HiveType(typeId: 1)
class Wordle {
  Wordle({required this.word,});
  
  @HiveField(0)
  String word;
}
