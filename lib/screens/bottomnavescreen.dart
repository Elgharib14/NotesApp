import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:notsapp/cubit/notes_cubit.dart';
import 'package:notsapp/cubit/notes_state.dart';
import 'package:notsapp/screens/archivedscreen.dart';
import 'package:notsapp/screens/donescreen.dart';
import 'package:notsapp/screens/taskscreen.dart';

class BottomNavBar extends StatelessWidget {

var Scaffoldkey = GlobalKey<ScaffoldState>();
var Formkey = GlobalKey<FormState>();


var titlecontroller = TextEditingController();
var timecontroller = TextEditingController();
var datecontroller = TextEditingController();

  List<Widget> Screens=[
    TaskScreen(),
    DoneScreen(),
    ArchivedScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NotesCubit, NotesState>(
      listener: (context, state) {

      },
      builder: (context, state) {
        return Scaffold(
          key: Scaffoldkey,
          appBar: AppBar(
            elevation: 0.0,
            title: Text('NotesApp',style: TextStyle(fontSize: 25,)),
            centerTitle: true,
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: NotesCubit.get(context).curntindex,
            onTap: (index){
              NotesCubit.get(context).changeSCreen(index);
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.menu),
                label: 'Taskes',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.done),
                label: 'Done',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.archive_outlined),
                label: 'Archive',
              )
            ],
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(NotesCubit.get(context).fabeicon),
            onPressed: (){
              if(NotesCubit.get(context).isbottomshetshown){
                if(Formkey.currentState!.validate()){
                  NotesCubit.get(context).insertToDataBase(
                    title: titlecontroller.text, 
                    date: datecontroller.text, 
                    time: timecontroller.text
                    ).then((value) => {
                      Navigator.pop(context),
                    });
                  //  
                  // NotesCubit.get(context).isbottomshetshown = false;
                  // NotesCubit.get(context).fabeicon = Icons.edit;
                }
               
              }else{
                Scaffoldkey.currentState!.showBottomSheet(
                (context) => Container(
                  color: Colors.grey[300],
                  padding: EdgeInsets.all(20),
                 child: Form(
                  key: Formkey,
                   child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        customtextform(
                          controller: titlecontroller,
                          type:TextInputType.text ,
                          lable: 'Title', 
                          fun: (){},
                          ispssword: false,
                          prefix: Icons.title,
                          ),
                          customtextform(
                          controller: timecontroller,
                          type:TextInputType.datetime ,
                          fun: (){
                            showTimePicker(
                              context: context, 
                              initialTime: TimeOfDay.now()
                              ).then((value){
                                print(value);
                                timecontroller.text = value!.format(context).toString();
                              });
                          },
                          lable: 'Time', 
                          ispssword: false,
                          prefix: Icons.watch_later_outlined,
                          ),
                          customtextform(
                          controller: datecontroller,
                          type:TextInputType.datetime ,
                          fun: (){
                            showDatePicker(
                              context: context, 
                              initialDate: DateTime.now(), 
                              firstDate: DateTime.now(), 
                              lastDate: DateTime.parse('2024-12-30')
                              ).then((value) => {
                                datecontroller.text = DateFormat.yMMMd().format(value!)
                              });
                          },
                          lable: 'Date', 
                          ispssword: false,
                          prefix: Icons.date_range,
                          ),
                      
                      ],
                    ),
                 ),
                 
                )
                
                ).closed.then((value){
                  NotesCubit.get(context).ChangeBottomsheetShown(
                    isshow: false, 
                    icon:  Icons.edit
                    );
                  
                });
                NotesCubit.get(context).ChangeBottomsheetShown(
                    isshow: true, 
                    icon:  Icons.add
                    );
              }
            },
          ),
          body: Screens[NotesCubit.get(context).curntindex] ,
        );
      },
    );
  }
}

Widget customtextform({
  required String lable,
   Widget? suffix,
  IconData? prefix,
  TextInputType? type,
  required bool ispssword,
  Function? fun,
  TextEditingController ? controller,

}){
  return TextFormField(
              controller: controller,
              keyboardType:type ,
              onTap:(){
                fun!();
              } ,
              validator: (value) {
                if(value!.isEmpty){
                  return 'thes field must not empty';
                }else{
                  return null;
                }
                },
                // onChanged: (value){
                //   fun!();
                // },
                obscureText: ispssword,
              decoration: InputDecoration(
                label: Text(lable,style: TextStyle(
                  fontSize: 30
                ),),
                prefix: Icon(prefix),
                
                suffix: suffix,
                // border: OutlineInputBorder(
                //   borderRadius: BorderRadius.circular(10)
                // )
              ),
            );
}