import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'notes_state.dart';

class NotesCubit extends Cubit<NotesState> {
  NotesCubit() : super(NotesInitial());

  static NotesCubit get(context) => BlocProvider.of(context);

  int curntindex = 0;
  void changeSCreen(index){
    curntindex = index;
        emit(changeSCreenState());
  }

  Database? database;

  void createDataBase()  {
    openDatabase(
    'notes.db',
    version: 1,
    onCreate: (database, version) async {
      await database.execute(
      'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT ,status TEXT)'
      ).then((value) {
        print('Table Created');
      },).catchError((Error){
        print('1');
        print(Error.toString());
      });
      
    },
    onOpen: (database) {
      getDataBase(database);
      print('DataBase Opend');
    },
   ).then((value){
     database = value;
     emit(createDataBasestate());
   });
  }

Future<void> insertToDataBase({
  required String title,
  required String date,
  required String time,
}) async {
  await database!.transaction((txn) async {
    txn.rawInsert('INSERT INTO tasks(title, date, time ,status) VALUES("$title", "$date","$time","new")').then((value){
      print('$value inserted sucessfuly');
      emit(insertToDataBasestate());

       getDataBase(database);
    }).catchError((Error){
      print('2');
        print(Error.toString());
    });
    return null;
});
}
List<Map> tasks =[];
List<Map> done =[];
List<Map> archived =[];

void getDataBase( database) {
  tasks =[];
  done= [];
  archived = [];
  emit(getDataBaseloding());
     database!.rawQuery('SELECT * FROM tasks').then((value){
      value.forEach((element){
        if(element['status'] == 'new')
        tasks.add(element);
        else if(element['status'] == 'done')
        done.add(element);
        else archived.add(element);
      });
      emit(getDataBasestate());
     });
}


bool isbottomshetshown = false;
IconData fabeicon = Icons.edit;
void ChangeBottomsheetShown({
  required bool isshow,
  required IconData icon,
}){
  fabeicon=icon;
  isbottomshetshown= isshow;
  emit(ChangeBottomsheetShownstate());
}



 void updateDataBase({
  required String status,
  required int id,
 })async{
  database!.rawUpdate(
    'UPDATE tasks SET status = ? WHERE id = ?',
    ['$status', id]
    ).then((value){
      getDataBase(database);
      print('33333333333');
      emit(updateDataBasestate());
    }).catchError((Error){
      print('555555');
      print(Error.toString());
    });
}


void deletDataBase({
  required int id,
 })async{
  database!.rawDelete(
    'DELETE FROM tasks WHERE id = ?', [id]
    ).then((value){
      print('llllllllllllllllllllll');
      getDataBase(database);
      emit(deletDataBasestate());
    }).catchError((Error){
      print('555555');
      print(Error.toString());
    });
}



}
