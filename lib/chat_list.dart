import 'package:chat_app/login_screen.dart';
import 'package:chat_app/models/users.dart';
import 'package:chat_app/personal_chat.dart';
import 'package:chat_app/services/firebase_services.dart';
import 'package:chat_app/services/storage.dart';
import 'package:flutter/material.dart';

class ChatListScreen extends StatefulWidget {
  final User mydata;
  const ChatListScreen({super.key, required this.mydata});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  List<User> allUser = [];
  bool isLogout = false;

  void allUsers() async {
    List<User>? data = await FirebaseServices().allUsers();
    setState(() {
      allUser = data ?? [];
    allUser=  allUser.where((e)=>e.id!=widget.mydata.id).toList();
    });
  }

  void logout() async {
    bool logout = await Storage().logout();
    setState(() {
      isLogout = logout;
    });
  }

  @override
  void initState() {
    allUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 206, 203, 203),
      appBar: AppBar(
        backgroundColor: Color(0xff000080),

        /// Colors.pink,
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: GestureDetector(
                onTap: () async {
                  !isLogout
                      ? logout()
                      : Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(),
                          ));
                },
                child: Icon(Icons.power_settings_new,color: Colors.white,)),
          )
        ],
        title: Text(
          "Chats",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: BouncingScrollPhysics(),
        child: Column(
         
          children: [
            allUser.isEmpty?Center(child: Text("No Users "),):
            ListView.builder(
              itemCount: allUser.length ?? 0,
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                var mydata = allUser[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PersonalChatScreen(
                            myloginData: widget.mydata,
                            user: mydata,
                          ),
                        ));
                  },
                  child: Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor:const Color(0xff01579b),
                        //Colors.pink[200],
                        child: Text(mydata.userName.toUpperCase().substring(0,1),style: TextStyle(color: Colors.white),),
                      ),
                      title: Text(mydata.userName),
                    ),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );

    // Scaffold(
    //   backgroundColor: const Color.fromARGB(255, 206, 203, 203),
    // appBar: AppBar(
    //   backgroundColor: Colors.amber,
    //   title: Text("Chats"),
    //   centerTitle: true,
    // ),
    //   body: SingleChildScrollView(
    //     scrollDirection: Axis.vertical,
    //     physics: BouncingScrollPhysics(),
    //     child: Column(
    //       children: [
    //         ListView.builder(
    //           physics: BouncingScrollPhysics(),
    //           itemCount: 20,
    //           shrinkWrap: true,
    //           itemBuilder: (context, index) {
    //             return GestureDetector(
    //               onTap: () {
    //                 Navigator.push(
    //                     context,
    //                     MaterialPageRoute(
    //                       builder: (context) => PersonalChatScreen(
    //                         name: "Name:${index + 1}",
    //                       ),
    //                     ));
    //               },
    //               child: Card(
    //                 child: ListTile(
    //                   leading: CircleAvatar(
    //                     backgroundColor: Colors.amber[200],
    //                     child: Text("${index + 1}"),
    //                   ),
    //                   title: Text("Name:${index + 1}"),
    //                 ),
    //               ),
    //             );
    //           },
    //         )
    //       ],
    //     ),
    //   ),
    // );
  }
}
