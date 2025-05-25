import 'dart:io';

import 'package:chat_app/models/message.dart';
import 'package:chat_app/models/users.dart';
import 'package:chat_app/services/firebase_services.dart';
import 'package:chat_app/utils/image_picker.dart';
import 'package:chat_app/utils/my_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PersonalChatScreen extends StatefulWidget {
  // final String name;
  // final int index;
  // final String name;
  final User user;
  final User myloginData;
  const PersonalChatScreen({
    super.key,
    // required this.index,
    // required this.name,
    required this.myloginData,
    required this.user,
  });

  @override
  State<PersonalChatScreen> createState() => _PersonalChatScreenState();
}

class _PersonalChatScreenState extends State<PersonalChatScreen> {
  TextEditingController chatController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  bool isMyChat = false;
  bool isLoading = true;
  File? pickedImage;
  String? convertedImage;

  sendMessage(Message message) async {
    if (chatController.text.isNotEmpty ||
        convertedImage != null ||
        convertedImage!.isNotEmpty) {
      await FirebaseServices().sendMesage(message);
      chatController.clear();
      setState(() {
        convertedImage = null;
      });
      Future.delayed(Duration(milliseconds: 200), () {
        scroll();
      });
    }
  }

  void scroll() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(Duration(milliseconds: 300), () {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      });
    });
  }

  void pickUpImage() async {
    File? image = await pickImage();
    if (image != null) {
      setState(() {
        pickedImage = image;
        imagetoString(pickedImage!);
      });
    } else {
      print("Image is Not Picked");
    }
  }

  imagetoString(File image) async {
    String? imgP = await ImageToString(image);
    if (pickedImage != null) {
      setState(() {
        convertedImage = imgP;
      });
    }
  }

  @override
  void initState() {
    chatController.addListener(
      () {
        setState(() {});
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    chatController.removeListener(
      () {},
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var mediaSize = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: PreferredSize(
        // ignore: sort_child_properties_last
        preferredSize:
            Size(double.infinity, MediaQuery.sizeOf(context).height * .07),

        child: Container(
          color: Color(0xff000080),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 15,
              ),
              Row(
                spacing: 8,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 4,
                  ),
                  GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      )),
                  CircleAvatar(
                    backgroundColor: Color(0xff01579b),
                    child: Text(widget.user.userName.toUpperCase().toString().substring(0,1),style: TextStyle(color: Colors.white,fontSize: 25),),

                  ),
                  Text(
                    widget.user.userName,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      body: SizedBox(
        height: mediaSize.height * .79,
        child: StreamBuilder<List<Message>>(
            stream: FirebaseServices().fetchMessage(),
            builder: (context, snapshot) {
              List<Message>? chats = snapshot.data ?? [];
              chats = chats
                  .where((c) =>
                      c.senderId == widget.myloginData.id &&
                          c.recieverId == widget.user.id ||
                      c.recieverId == widget.myloginData.id &&
                          c.senderId == widget.user.id)
                  .toList();
              chats.sort(
                (a, b) => a.messageDate!.compareTo(b.messageDate!),
              );

              return SingleChildScrollView(
                scrollDirection: Axis.vertical,
                physics: ScrollPhysics(),
                controller: _scrollController,
                child: Column(
                  children: [
                    ListView.builder(
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: chats.length,
                      itemBuilder: (context, index) {
                        var mychats = chats![index];
                        isMyChat = mychats.senderId == widget.myloginData.id
                            ? true
                            : false;
                        return Align(
                          alignment: isMyChat
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 5.0, horizontal: 10.0),
                            padding: EdgeInsets.all(10),
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.sizeOf(context).width * .75,
                            ),
                            decoration: BoxDecoration(
                                color: !isMyChat
                                    ? Color(0xff000080)
                                    : const Color(0xff01579b),
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(12),
                                    topRight: Radius.circular(12),
                                    bottomLeft: isMyChat
                                        ? Radius.zero
                                        : Radius.circular(12),
                                    bottomRight: isMyChat
                                        ? Radius.circular(12)
                                        : Radius.zero)),
                            child: Column(
                              children: [
                                mychats.image == null || mychats.image!.isEmpty
                                    ? SizedBox()
                                    : Image.memory(
                                        StringToImage(mychats.image!)),
                                Text(
                                  mychats.message ?? '',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.white),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            }),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            convertedImage == null || convertedImage!.isEmpty
                ? SizedBox()
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                        //color: Colors.amber,
                        height: mediaSize.height * .75,
                        width: mediaSize.width * .9,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.memory(
                              StringToImage(convertedImage!),
                              fit: BoxFit.cover,
                            ))),
                  ),
            MyTextField(
              controller: chatController,
              suffixIcon: SizedBox(
                height: 30,
                width: 70,
                child: Padding(
                  padding: EdgeInsets.only(
                    right: mediaSize.width * .0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    //spacing: 10,
                    children: [
                      // GestureDetector(
                      //   onTap: () => pickUpImage(),
                      //   child: Icon(
                      //     CupertinoIcons.camera_circle,
                      //     size: 35,
                      //   ),
                      // ),
                      GestureDetector(
                          onTap: () {
                            var currentDate = DateTime.now();
                            var id = currentDate.microsecondsSinceEpoch +
                                widget.user.id +
                                widget.user.phNumber +
                                currentDate.day +
                                currentDate.year;
                            Message myMessage = Message(
                                image: convertedImage,
                                messageDate: currentDate.toString(),
                                message: chatController.text,
                                msgID: id.toString(),
                                recieverId: widget.user.id,
                                senderId: widget.myloginData.id,
                                status: 1);
                            if (chatController.text.isNotEmpty ||
                                pickedImage!.path.isNotEmpty) {
                                sendMessage(myMessage);
                            }
                          },
                          child: Icon(
                            chatController.text.isNotEmpty
                                ? CupertinoIcons.arrow_right_circle_fill
                                : CupertinoIcons.arrow_right_circle,
                            color: Color(0xff000080),
                            size: 35,
                          )),
                    ],
                  ),
                ),
              ),
              placeholder: "Type Message",
            ),
          ],
        ),
      ),
    );

    //  Scaffold(
    //   appBar: AppBar(
    //     backgroundColor: Colors.amber,
    //     title: Text(widget.name),
    //   ),
    //   body: Column(
    //     children: [],
    //   ),
    //   floatingActionButton: Padding(
    //     padding: const EdgeInsets.all(8.0),
    //     child: MyTextField(
    //       controller: chatController,
    //       placeholder: "Enter Message",
    //     ),
    //   ),
    //   floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    // );
  }
}
