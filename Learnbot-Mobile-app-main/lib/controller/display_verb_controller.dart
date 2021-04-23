
import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:leanrbot/component/Subscriptionstate.dart';
import 'package:leanrbot/config.dart';
import 'package:leanrbot/model/verbs_model.dart';
import 'package:leanrbot/model/words_model.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';


class Display_verb_controller extends ControllerMVC{

  int first_lang, second_lang;

  bool change_lang_flag;

  List<String> pronoum_first, pronoum_second, pronoum_current;
  List<List<String>> verb_data_first  , verb_data_second , verb_data_sound, verb_data_current;

  String infitiv_text;

  List<List<bool>> audio_flags;

  List<String> tempus_data_fist, tempus_data_second, tempus_current;

  String video_url='';
  String en_video_url='';
  String image_url='';
  String en_image_url='';
  int idx;
  String en_code;

  String video_file_name;
  String en_video_file_name;
  String image_file_name;
  String en_image_file_name;

  String image_path;
  String engs_name;

  String video_path;

  VideoPlayerController controller;

  bool play_video = false;

  String tempus_value='';

  Display_verb_controller(int lang_index, String eng_name) {
    change_lang_flag = false;
    image_path = '';
    first_lang = second_lang = lang_index;
    engs_name = eng_name;
    en_code = Config.flag_code[lang_index].toLowerCase();

    pronoum_first = ['', '', '', '', '', ''];
    pronoum_second = ['', '', '', '', '', ''];
    tempus_data_fist = ['', '', '', '', '', ''];
    tempus_data_second = ['', '', '', '', '', ''];
    tempus_current = ['', '', '', '', '', ''];
    pronoum_current = ['', '', '', '', '', ''];

    verb_data_first = List.generate(6,
            (i) => List.generate(6 , (j) => '', growable: false),
        growable: false);
    verb_data_second =  List.generate(6,
            (i) => List.generate(6 , (j) => '', growable: false),
        growable: false);
    verb_data_sound =  List.generate(6,
            (i) => List.generate(6 , (j) => '', growable: false),
        growable: false);

    verb_data_current =  List.generate(6,
            (i) => List.generate(6 , (j) => '', growable: false),
        growable: false);

    audio_flags =  List.generate(6,
            (i) => List.generate(6 , (j) => false, growable: false),
        growable: false);

    setWordsVerbs(lang_index);
  }


//  Future<Words> fetchsecondWordsFromDatabase(int index) async{
//    var dbHelper = Config.databasehelper;
//    Words words = await dbHelper.getsecondWords(index);
//    return words;
//  }
//  Future<Verbs> fetchsecondVerbsFromDatabase(int index) async{
//    var dbHelper = Config.databasehelper;
//    Verbs verbs = await dbHelper.getsecondVerbs(index, engs_name);
//    return verbs;
//  }

  Future<Words> fetchWordsFromDatabase(int index) async{
    var dbHelper = Config.databasehelper;
    Words words = await dbHelper.getWords(index);
    return words;
  }
  Future<Verbs> fetchVerbsFromDatabase(int index) async{
    var dbHelper = Config.databasehelper;
    Verbs verbs = await dbHelper.getVerbs(index, engs_name);
    return verbs;
  }
  void change_flag() {
    verb_data_current = List();
    pronoum_current = List();
    tempus_current = List();
    setState((){
      pronoum_current.addAll(pronoum_first);
      tempus_current.addAll(tempus_data_fist);
      verb_data_current.addAll(verb_data_first);
    });
    setState((){
      change_lang_flag = !change_lang_flag;
    });
  }

  Future<void> setsecondlanguage(int index) async {

    setState(()  {
      second_lang = index;
    });



   Words words =await  fetchWordsFromDatabase(second_lang);
    if(words != null){
      setState((){
        pronoum_second[0] = words.pronom1;
        pronoum_second[1] = words.pronom2;
        pronoum_second[2] = words.pronom3;
        pronoum_second[3] = words.pronom4;
        pronoum_second[4] = words.pronom5;
        pronoum_second[5] = words.pronom6;
        tempus_data_second[0] = words.tempus1;
        tempus_data_second[1] = words.tempus2;
        tempus_data_second[2] = words.tempus3;
        tempus_data_second[3] = words.tempus4;
        tempus_data_second[4] = words.tempus5;
        tempus_data_second[5] = words.tempus6;

        pronoum_current[0] = words.pronom1;
        pronoum_current[1] = words.pronom2;
        pronoum_current[2] = words.pronom3;
        pronoum_current[3] = words.pronom4;
        pronoum_current[4] = words.pronom5;
        pronoum_current[5] = words.pronom6;
        tempus_current[0] = words.tempus1;
        tempus_current[1] = words.tempus2;
        tempus_current[2] = words.tempus3;
        tempus_current[3] = words.tempus4;
        tempus_current[4] = words.tempus5;
        tempus_current[5] = words.tempus6;

      });
    }
    Verbs verbs = await fetchVerbsFromDatabase(second_lang);
    if(verbs != null){
      setState((){
        verb_data_second[0] = verbs.conj1_text;
        verb_data_second[1] = verbs.conj2_text;
        verb_data_second[2] = verbs.conj3_text;
        verb_data_second[3] = verbs.conj4_text;
        verb_data_second[4] = verbs.conj5_text;
        verb_data_second[5] = verbs.conj6_text;

        verb_data_current[0] = verbs.conj1_text;
        verb_data_current[1] = verbs.conj2_text;
        verb_data_current[2] = verbs.conj3_text;
        verb_data_current[3] = verbs.conj4_text;
        verb_data_current[4] = verbs.conj5_text;
        verb_data_current[5] = verbs.conj6_text;
      });
    }
  }

  Future<void> setWordsVerbs(int lang_index) async {

  Words words = await fetchWordsFromDatabase(lang_index);
    if(words != null){
      pronoum_first[0] = pronoum_second[0] = words.pronom1;
      pronoum_first[1] = pronoum_second[1] =  words.pronom2;
      pronoum_first[2] = pronoum_second[2] = words.pronom3;
      pronoum_first[3] = pronoum_second[3] = words.pronom4;
      pronoum_first[4] = pronoum_second[4] = words.pronom5;
      pronoum_first[5] = pronoum_second[5] = words.pronom6;
        tempus_data_fist[0] = words.tempus1;
        tempus_data_fist[1] = words.tempus2;
        tempus_data_fist[2] = words.tempus3;
        tempus_data_fist[3] = words.tempus4;
        tempus_data_fist[4] = words.tempus5;
        tempus_data_fist[5] = words.tempus6;
        tempus_value = tempus_data_fist[0];

        pronoum_current[0] = words.pronom1;
        pronoum_current[1] =  words.pronom2;
        pronoum_current[2] = words.pronom3;
        pronoum_current[3] = words.pronom4;
        pronoum_current[4] = words.pronom5;
        pronoum_current[5] = words.pronom6;

        tempus_current[0] = words.tempus1;
        tempus_current[1] = words.tempus2;
        tempus_current[2] = words.tempus3;
        tempus_current[3] = words.tempus4;
        tempus_current[4] = words.tempus5;
        tempus_current[5] = words.tempus6;
    }

   Verbs verbs = await fetchVerbsFromDatabase(lang_index);
   if(verbs != null){
     setState((){
       verb_data_first[0] = verbs.conj1_text;
       verb_data_first[1] = verbs.conj2_text;
       verb_data_first[2] = verbs.conj3_text;
       verb_data_first[3] = verbs.conj4_text;
       verb_data_first[4] = verbs.conj5_text;
       verb_data_first[5] = verbs.conj6_text;

       verb_data_second[0] = verbs.conj1_text;
       verb_data_second[1] = verbs.conj2_text;
       verb_data_second[2] = verbs.conj3_text;
       verb_data_second[3] = verbs.conj4_text;
       verb_data_second[4] = verbs.conj5_text;
       verb_data_second[5] = verbs.conj6_text;

       verb_data_current[0] = verbs.conj1_text;
       verb_data_current[1] = verbs.conj2_text;
       verb_data_current[2] = verbs.conj3_text;
       verb_data_current[3] = verbs.conj4_text;
       verb_data_current[4] = verbs.conj5_text;
       verb_data_current[5] = verbs.conj6_text;

       verb_data_sound[0] = verbs.conj1_audio;
       verb_data_sound[1] = verbs.conj2_audio;
       verb_data_sound[2] = verbs.conj3_audio;
       verb_data_sound[3] = verbs.conj4_audio;
       verb_data_sound[4] = verbs.conj5_audio;
       verb_data_sound[5] = verbs.conj6_audio;


       infitiv_text = verbs.infinitiv_text;
       idx = verbs.idx;
       video_file_name = '${en_code}-3-${idx.toString()}.mp4';
       image_file_name = '${verbs.image.replaceAll('768x1024.jpg', '')}1024x693.png';
       video_url ='https://verb-${en_code}.s3.eu-west-2.amazonaws.com/movies/${video_file_name}';
       image_url ='https://verb-${en_code}.s3.eu-west-2.amazonaws.com/images/${image_file_name}';
       downloadvideoimage();
     });
   }
   int select_default_index = 2;
   if(first_lang == 8 || first_lang == 10 || first_lang == 11 || first_lang == 16 || first_lang == 21){
     select_default_index = 7;
   }
  String en_codes = Config.flag_code[select_default_index].toLowerCase();
  Verbs en_verbs = await fetchVerbsFromDatabase(select_default_index);
  if(en_verbs != null){
    setState((){
      en_video_file_name = '${en_codes}-3-${idx.toString()}.mp4';
      en_image_file_name = '${en_verbs.image.replaceAll('768x1024.jpg', '')}1024x693.png';
      en_video_url ='https://verb-${en_codes}.s3.eu-west-2.amazonaws.com/movies/${en_video_file_name}';
      en_image_url ='https://verb-${en_codes}.s3.eu-west-2.amazonaws.com/images/${en_image_file_name}';
      downloadvideoimage();
    });
  }
  }
  Future<void> downloadvideoimage() async {
    Directory dir = await getApplicationDocumentsDirectory();
    try{
      String imgpath = '${dir.path}/$image_file_name';
      File imgfile = new File(imgpath);
      if(!imgfile.existsSync()) {
        Dio dio = Dio();

       var result = await dio.download(
          image_url,
          imgpath,
          onReceiveProgress: (rcv, total) {
            if(rcv == total){
              setState((){
                image_path = imgpath;
              });
            }
          },
          deleteOnError: true,
        ).then((_) {
        });
      } else{
        setState((){
          image_path = imgpath;
        });
      }
    }on DioError  catch (ex){
      String imgpath = '${dir.path}/$en_image_file_name';
      File imgfile = new File(imgpath);
      if(!imgfile.existsSync()) {
        Dio dio = Dio();

        dio.download(
          en_image_url,
          imgpath,
          onReceiveProgress: (rcv, total) {
            if(rcv == total){
              setState((){
                image_path = imgpath;
              });
            }
          },
          deleteOnError: true,
        ).then((_) {
        });
      } else{
        setState((){
          image_path = imgpath;
        });
      }
    }

    try{
      String videopath = '${dir.path}/$video_file_name';
      File videofile = new File(videopath);
      print(video_url);
      if(!videofile.existsSync()) {
        Dio dio = Dio();

       var result = await dio.download(
          video_url,
          videopath,
          onReceiveProgress: (rcv, total) {
            if(rcv == total){
              controller = VideoPlayerController.file(File(videopath))..initialize().then((_) {
                setState(() {});
                controller.addListener(() {
                  if(controller.value.duration.inSeconds == controller.value.position.inSeconds){
                    setState(() {
                      play_video = false;
                    });
                  }
                });
                video_path = videopath;
              });

            }
          },
          deleteOnError: true,
        ).then((_) {
        });
      } else{
        video_path = videopath;
        controller = VideoPlayerController.file(File(videopath))..initialize().then((_) {
          setState(() {});
          controller.addListener(() {
            if(controller.value.duration.inSeconds == controller.value.position.inSeconds){
              setState(() {
                play_video = false;
              });
            }

          });
        });

      }
    } on DioError  catch (ex){
      String videopath = '${dir.path}/$en_video_file_name';
      File videofile = new File(videopath);
      print(en_video_url);
      if(!videofile.existsSync()) {
        Dio dio = Dio();

      dio.download(
          en_video_url,
          videopath,
          onReceiveProgress: (rcv, total) {
            if(rcv == total){

              controller = VideoPlayerController.file(File(videopath))..initialize().then((_) {
                setState(() {});
                controller.addListener(() {
                  if(controller.value.duration.inSeconds == controller.value.position.inSeconds){
                    setState(() {
                      play_video = false;
                    });
                  }
                });
                video_path = videopath;
              });

            }
          },
          deleteOnError: true,
        ).then((_) {
        });
      } else{
        video_path = videopath;
        controller = VideoPlayerController.file(File(videopath))..initialize().then((_) {
          setState(() {});
          controller.addListener(() {
            if(controller.value.duration.inSeconds == controller.value.position.inSeconds){
              setState(() {
                play_video = false;
              });
            }

          });
        });

      }
    }
  }

  Future<void> playaudio(int i, int index) async {
    Directory dir = await getApplicationDocumentsDirectory();
    String autdiopath = '${dir.path}/' + verb_data_sound[i][index] + '.mp3';
    String audiourl = 'https://verb-${en_code}.s3.eu-west-2.amazonaws.com/audio/'+ verb_data_sound[i][index] + '.mp3';

    print(audiourl);
    File audiofile = new File(autdiopath);
    if(!audiofile.existsSync()) {
      Dio dio = Dio();

      dio.download(
        audiourl,
        autdiopath,
        onReceiveProgress: (rcv, total) {
          if(rcv == total){
            AudioPlayer audioPlayer = AudioPlayer();
            setState((){
              audio_flags[i][index] = true;
            });
            audioPlayer.play(autdiopath, isLocal: true);
            audioPlayer.onPlayerCompletion.listen((event) {
              setState(() {
                audio_flags[i][index] = false;
              });
            });
          }
        },
        deleteOnError: true,

      ).then((_) {
      });
    } else{
      AudioPlayer audioPlayer = AudioPlayer();
      setState((){
        audio_flags[i][index] = true;
      });
      audioPlayer.play(autdiopath, isLocal: true);
      audioPlayer.onPlayerCompletion.listen((event) {
        setState(() {
          audio_flags[i][index] = false;
        });
      });
    }
  }

  change_tempus(int index) {
    if(!change_lang_flag){
      setState(() {
        tempus_value = tempus_data_fist[index];
      });
    } else{
      setState(() {
        tempus_value = tempus_data_second[index];
      });
    }

  }

  Future<void> addingfavoriteverb() async{
    var dbHelper = Config.databasehelper;
    await dbHelper.addfavorite(first_lang, infitiv_text);
  }
}