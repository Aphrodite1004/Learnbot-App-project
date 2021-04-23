

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:leanrbot/config.dart';
import 'package:leanrbot/model/Select_verb_model.dart';
import 'package:leanrbot/model/myverb_model.dart';
import 'package:leanrbot/model/words_model.dart';
import 'package:leanrbot/screen/myverbs/myverbs.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:image/image.dart' as i;
import 'package:path_provider/path_provider.dart';

class Add_verb_controller extends ControllerMVC {

  int first_lang = 0;
  String infinitv_text;
  String tempus_value = '';

  List<String> tempus_data_fist;
  List<String> pronoum_current;

  List<List<TextEditingController>> addverb_controller;
  List<List<FocusNode>> myFocusNode;

  bool image_selected = false;

  String image_path;

  Add_verb_controller(int selected_lang, String infinitv_texts) {
    first_lang = selected_lang;
    infinitv_text = infinitv_texts;

    tempus_data_fist = ['', '', '', '', '', ''];
    pronoum_current = ['', '', '', '', '', ''];
    addverb_controller =  List.generate(6,
      (i) => List.generate(6 , (j) => TextEditingController(), growable: false),
        growable: false);
    myFocusNode =  List.generate(6,
            (i) => List.generate(6 , (j) => FocusNode() , growable: false),
        growable: false);
    setWordVerbs();
    set_select_verb_list();
    setimage();
  }

  void set_select_verb_list() async{
    var dbHelper = Config.databasehelper;
    MyVerb_Model myverb = await dbHelper.getmycurrentVerbs(first_lang, infinitv_text);
    if(myverb != null){
      for(int i = 0; i < 6; i++){
        addverb_controller[0][i].text = myverb.conj1_text[i];
        if(myverb.conj1_text[i].toString().length == 0) myFocusNode[0][i].requestFocus();
        addverb_controller[1][i].text = myverb.conj2_text[i];
        if(myverb.conj2_text[i].toString().length == 0) myFocusNode[1][i].requestFocus();
        addverb_controller[2][i].text = myverb.conj3_text[i];
        if(myverb.conj3_text[i].toString().length == 0) myFocusNode[2][i].requestFocus();
        addverb_controller[3][i].text = myverb.conj4_text[i];
        if(myverb.conj4_text[i].toString().length == 0) myFocusNode[3][i].requestFocus();
        addverb_controller[4][i].text = myverb.conj5_text[i];
        if(myverb.conj5_text[i].toString().length == 0) myFocusNode[4][i].requestFocus();
        addverb_controller[5][i].text = myverb.conj6_text[i];
        if(myverb.conj6_text[i].toString().length == 0) myFocusNode[5][i].requestFocus();
      }
      setState((){

      });
    }

  }
  change_tempus(int index) {
    setState(() {
      tempus_value = tempus_data_fist[index];
    });
  }

  Future<void> setWordVerbs() async {
    Words words = await fetchWordsFromDatabase(first_lang);
    if (words != null) {
      pronoum_current[0] = words.pronom1;
      pronoum_current[1] = words.pronom2;
      pronoum_current[2] = words.pronom3;
      pronoum_current[3] = words.pronom4;
      pronoum_current[4] = words.pronom5;
      pronoum_current[5] = words.pronom6;
      tempus_data_fist[0] = words.tempus1;
      tempus_data_fist[1] = words.tempus2;
      tempus_data_fist[2] = words.tempus3;
      tempus_data_fist[3] = words.tempus4;
      tempus_data_fist[4] = words.tempus5;
      tempus_data_fist[5] = words.tempus6;
      tempus_value = tempus_data_fist[0];

      setState((){

      });
    }
  }
  Future<Words> fetchWordsFromDatabase(int index) async{
    var dbHelper = Config.databasehelper;
    Words words = await dbHelper.getWords(index);
    return words;
  }

  Future<void> updateverb(String value, int i, int index) async {
    var dbHelper = Config.databasehelper;
    var data_index = i  * 6 + (index + 1);
    print(data_index);
    await dbHelper.updatemyverb(first_lang, infinitv_text, data_index.toString(), value);
  }

  Future selectimage(BuildContext context) async{
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
              title: Text(
                "Select source",
              ),
              insetAnimationCurve: Curves.decelerate,
              actions: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: GestureDetector(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.photo_camera,
                          size: 28,
                        ),
                        Text(
                          " Camera",
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                              decoration: TextDecoration.none),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      showDialog(
                          context: context,
                          builder: (context) {
                            getImage(
                                ImageSource.camera, context);
                            return Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ));
                          });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: GestureDetector(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.photo_library,
                          size: 28,
                        ),
                        Text(
                          " Gallery",
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                              decoration: TextDecoration.none),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) {
                            getImage(ImageSource.gallery, context,);
                            return Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ));
                          });
                    },
                  ),
                ),
              ]);
        });
  }
  Future getImage(ImageSource imageSource, context) async {
    var image = await ImagePicker.pickImage(source: imageSource);
    if (image != null) {
      File croppedFile = await ImageCropper.cropImage(
          sourcePath: image.path,
          aspectRatioPresets: [CropAspectRatioPreset.square],
          androidUiSettings: AndroidUiSettings(
              toolbarTitle: 'Crop',
              toolbarColor: Colors.grey,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.square,
              lockAspectRatio: true),
          iosUiSettings: IOSUiSettings(
            minimumAspectRatio: 1.0,
          ));
      if (croppedFile != null) {
        await compressimage(croppedFile);
        File imagefile = new File(image_path);

        if(imagefile.existsSync()) {
          image_selected = true;
        }
        setState((){
          image_path = image_path;
        });
      }
    }
    Navigator.pop(context);
  }
  Future compressimage(File image) async {

    i.Image imagefile = i.decodeImage(image.readAsBytesSync());
    final compressedImagefile = File(image_path)
      ..writeAsBytesSync(i.encodeJpg(imagefile, quality: 80));
    // setState(() {
    return compressedImagefile;
    // });
  }

  Future<void> setimage() async {
    final tempdir = await getApplicationDocumentsDirectory();
    final path = tempdir.path;
    image_path = '${path}/myverb-'+ Config.flag_code[first_lang] + '-' + infinitv_text + '.jpg';

    File imagefile = new File(image_path);

    if(imagefile.existsSync()) {
      image_selected = true;
    }
    setState((){

    });
  }

  Future<void> deleteimage(BuildContext context) async {
    File imagefile = new File(image_path);
    setState((){
      image_selected = false;
    });
    await imagefile.delete();
  }
}