import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notsapp/cubit/notes_cubit.dart';
import 'package:notsapp/cubit/notes_state.dart';

class TaskScreen extends StatelessWidget {
  const TaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NotesCubit, NotesState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return ConditionalBuilder(
          condition: NotesCubit.get(context).tasks.length > 0, 
          builder: (context) => ListView.separated(
          physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) => buildtask(NotesCubit.get(context).tasks[index],context),
            separatorBuilder: (context, index) => Container(
                  color: Colors.grey[300],
                  height: 1,
                ),
            itemCount: NotesCubit.get(context).tasks.length
            ), 
          fallback:(context) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.menu,size: 90,color: Colors.grey,),
                Text('No Tasks Yet',style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey
                ),)
              ],
            ),
          )
          );
      },
    );
  }
}

Widget buildtask(Map model,context) => Dismissible(
  key: Key(model['id'].toString()),
  onDismissed: (direction) {
    NotesCubit.get(context).deletDataBase(id: model['id']);
  },
  child:   Padding(
  
        padding: const EdgeInsets.all(15.0),
  
        child: Row(
  
          children: [
  
            CircleAvatar(
  
              radius: 50,
  
              child: Center(child: Text('${model['time']}')),
  
            ),
  
            SizedBox(
  
              width: 20,
  
            ),
  
            Expanded(
  
              child: Column(
  
                mainAxisSize: MainAxisSize.min,
  
                children: [
  
                  Text(
  
                    '${model['title']}',
  
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
  
                  ),
  
                  Text(
  
                    '${model['date']}',
  
                    style: TextStyle(color: Colors.grey),
  
                  ),
  
                ],
  
              ),
  
            ),
  
            SizedBox(
  
              width: 20,
  
            ),
  
            IconButton(
  
              onPressed: (){
  
                NotesCubit.get(context).updateDataBase(status: 'done', id: model['id']);
  
              }, 
  
              icon: Icon(Icons.check_box,color: Colors.green,)
  
  
  
              ),
  
               IconButton(
  
              onPressed: (){
  
                NotesCubit.get(context).updateDataBase(status: 'arcived', id: model['id']);
  
              }, 
  
              icon: Icon(Icons.archive,color: Colors.grey)
  
              )
  
          ],
  
        ),
  
      ),
);
