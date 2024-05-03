import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/common/utils/utils.dart';
import 'package:whatsapp_ui/features/auth/controller/auth_controller.dart';

class UserInfoScreen extends ConsumerStatefulWidget {
  static const String routeName='/user-info';
  const UserInfoScreen({Key? key}): super (key: key);

  @override
  ConsumerState<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends ConsumerState<UserInfoScreen> {
  final TextEditingController nameController=TextEditingController();

  File? image;

  @override
  void dispose() { 
    super.dispose();
    nameController.dispose();
  }
  void selectImage() async {
    image = await pickImageFromGallery(context);
    setState(() {});
  }

  void storeUserData() async{
    String name=nameController.text.trim();
    if(name.isNotEmpty){
      ref.read(authControllerProvider).saveUserDataToFirebase(context, name, image);
    }
  }


  @override
  Widget build(BuildContext context) {
    final size =MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Center(
           child: Column(
            children: [
              Stack(
                children: [
                  image == null 
                  ? const CircleAvatar(
                    backgroundImage: NetworkImage(
                      'https://w0.peakpx.com/wallpaper/221/949/HD-wallpaper-bob-esponja-mafioso-bob-esponja-gangster-mafioso-meme.jpg'
                    ),
                    radius: 64,
                  ) : CircleAvatar(
                    backgroundImage: FileImage(
                      image!,
                    ),
                    radius: 64,
                  ),
                  Positioned(
                    bottom: -10,
                    left: 80,
                    child: IconButton(
                      onPressed: selectImage,
                      icon: const Icon(Icons.add_a_photo,)))
                ],
              ),
              Row(
               children: [
                Container(
                  width: size.width*.85,
                  padding: const EdgeInsets.all(20),
                  child: TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      hintText: 'Enter your name',
                    ),
                  ),
                ),
                IconButton(onPressed: storeUserData, icon: const Icon(Icons.done,),),
               ], 
              )
            ],
        ),
        )
      ),
    );
  }
}