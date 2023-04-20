import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:note_app_with_nest/data/get_all_notes_resp/get_all_notes_resp.dart';
import 'package:note_app_with_nest/data/note_model/note_model.dart';
import 'package:note_app_with_nest/data/url.dart';

abstract class ApiCalls {
  Future<NoteModel?> createNote(NoteModel value);
  Future<List<NoteModel>> getAllNotes();
  Future<NoteModel?> updateNote(NoteModel value);
  Future<void> deleteNote(String id);
}

class NoteDB extends ApiCalls {

//singleton
  NoteDB.internal();

  static NoteDB instance = NoteDB.internal();

  NoteDB factory(){
    return instance;
  }
//end

  final dio = Dio();
  final url = Url();

  ValueNotifier<List<NoteModel>> noteListNotifier = ValueNotifier([]);

  NoteDB(){
    dio.options = BaseOptions(
      baseUrl: url.baseUrl,
      responseType: ResponseType.plain,
    );
  }

  @override
  Future<NoteModel?> createNote(NoteModel value) async {
    try {
      final result = await dio.post(
        url.createNote,
        data: value.toJson(),
      );
      final resultAsJson = jsonDecode(result.data);
      return NoteModel.fromJson(resultAsJson as Map<String, dynamic>);
    } on DioError catch (e){
      print(e.response?.data);
      print(e);
      return null;
    }
    catch (e) {
      print(e.toString());
    }
  }

  @override
  Future<void> deleteNote(String id) async {
    // TODO: implement deleteNote
    throw UnimplementedError();
  }

  @override
  Future<List<NoteModel>> getAllNotes() async {
    final result = await dio.get(url.getAllNote);
    if (result.data!=null) {
      final resultAsJson = jsonDecode(result.data);
      final getNoteResp = GetAllNotesResp.fromJson(resultAsJson); 
      noteListNotifier.value.clear();
      noteListNotifier.value.addAll(getNoteResp.data);
      return getNoteResp.data;
    } else {
      noteListNotifier.value.clear();
      return [];
    }
    
  }

  @override
  Future<NoteModel?> updateNote(NoteModel value) async {
    // TODO: implement updateNote
    throw UnimplementedError();
  }
}
