import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notsapp/screens/taskscreen.dart';

import '../cubit/notes_cubit.dart';
import '../cubit/notes_state.dart';

class DoneScreen extends StatelessWidget {
  const DoneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  BlocConsumer<NotesCubit, NotesState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return ConditionalBuilder(
          condition: NotesCubit.get(context).done.length > 0, 
          builder: (context) => ListView.separated(
          physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) => buildtask(NotesCubit.get(context).done[index],context),
            separatorBuilder: (context, index) => Container(
                  color: Colors.grey[300],
                  height: 1,
                ),
            itemCount: NotesCubit.get(context).done.length
            ),
          fallback:(context) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.done,size: 90,color: Colors.grey,),
                Text('No Tasks Done Yet',style: TextStyle(
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
  