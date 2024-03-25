// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:pay_per_view/components/custom_button.dart';
import 'package:pay_per_view/components/custom_drawer.dart';
import 'package:pay_per_view/components/custom_event_card.dart';
import 'package:pay_per_view/components/custom_textfield.dart';
import 'package:pay_per_view/components/publish_event_button.dart';
import 'package:pay_per_view/database/firestore.dart';
//import 'package:pay_per_view/pages/stream_page.dart';
import 'package:pay_per_view/pages/stream_video_page.dart';
import 'package:pay_per_view/pages/stream_viewer_page.dart';
//import 'package:pay_per_view/pages/watch_video_page.dart';
import 'package:rounded_expansion_tile/rounded_expansion_tile.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:string_validator/string_validator.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  String serverIP = "YOUR_SERVER_IP";

  TextEditingController newEventNameController = TextEditingController();
  TextEditingController newEventPriceController = TextEditingController();

  final FirestoreDatabase database = FirestoreDatabase();
  User? user = FirebaseAuth.instance.currentUser;

  void postEvent() {
    if (newEventNameController.text == "") {
      return;
    }

    if (isInt(newEventPriceController.text) == false) {
      return;
    }

    String eventName = newEventNameController.text;
    int eventPrice = int.parse(newEventPriceController.text);
    String adminID = user!.uid;

    database.addEvent(eventName, eventPrice);

    newEventNameController.clear();
    newEventPriceController.clear();
  }

  void displayBuyDialog(
      QueryDocumentSnapshot<Object?> event, BuildContext context) {
    int price = event['eventPrice'];
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
                content: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(24)),
                  padding: EdgeInsets.all(25),
                  child: Icon(
                    Icons.cruelty_free,
                    size: 75,
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Text(
                  "gain access",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 25,
                ),
                SlideAction(
                  text: "\$${price.toString()}",
                  innerColor: Theme.of(context).colorScheme.secondary,
                  outerColor: Theme.of(context).colorScheme.primary,
                  sliderButtonIcon: Icon(
                    Icons.arrow_forward,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  borderRadius: 12,
                  sliderRotate: false,
                  //animationDuration: Duration(seconds: 1),
                  onSubmit: () {
                    database.buyEvent(event, user!.email);
                    Navigator.pop(context);

                    VlcPlayerController newcontroller =
                        VlcPlayerController.network(
                      "rtmp://${serverIP}:1935/${event['adminID']}/live",
                      hwAcc: HwAcc.auto,
                      autoPlay: true,
                      options: VlcPlayerOptions(),
                    );

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => StreamViewerPage(
                                  controller: newcontroller,
                                )));
                  },
                )
              ],
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        iconTheme:
            IconThemeData(color: Theme.of(context).colorScheme.inversePrimary),
        title:
            Text("E V E N T S", style: Theme.of(context).textTheme.titleLarge),
        backgroundColor:
            Colors.transparent, //Theme.of(context).colorScheme.primary,
        elevation: 0,
      ),
      drawer: CustomDrawer(),
      //drawerScrimColor: Theme.of(context).colorScheme.inversePrimary,
      drawerEnableOpenDragGesture: true,
      body: Column(
        children: [
          // post field
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      CustomTextfield(
                          hintText: "event name",
                          obscureText: false,
                          controller: newEventNameController),
                      SizedBox(
                        height: 5,
                      ),
                      CustomTextfield(
                          hintText: "event price",
                          obscureText: false,
                          controller: newEventPriceController),
                    ],
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                PublishEventButton(onTap: postEvent),
              ],
            ),
          ),

          //all events
          StreamBuilder(
              stream: database.getEventsStream(),
              builder: ((context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final events = snapshot.data!.docs;

                if (snapshot.data == null || events.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.all(25),
                      child: Text("no events yet"),
                    ),
                  );
                }

                return Expanded(
                    child: ListView.builder(
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    final event = events[index];

                    String eventName = event['eventName'];
                    int eventPrice = event['eventPrice'];
                    String adminEmail = event['adminEmail'];
                    //String docID = event.reference.id;

                    return (adminEmail == user!.email)
                        ? CustomEventCard(
                            eventName: eventName,
                            eventAdmin: adminEmail,
                            eventPrice: eventPrice,
                            buttonText: "go live",
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => StreamVideoPage(
                                            streamID: event['adminID'],
                                          )));
                            },
                          )
                        : (event['buyers'].contains(user!.email))
                            ? CustomEventCard(
                                eventName: eventName,
                                eventAdmin: adminEmail,
                                eventPrice: eventPrice,
                                buttonText: "watch live",
                                onTap: () {
                                  VlcPlayerController newcontroller =
                                      VlcPlayerController.network(
                                    "rtmp://${serverIP}:1935/${event['adminID']}/live",
                                    hwAcc: HwAcc.auto,
                                    autoPlay: true,
                                    options: VlcPlayerOptions(),
                                  );

                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              StreamViewerPage(
                                                controller: newcontroller,
                                              )));
                                },
                              )
                            : CustomEventCard(
                                eventName: eventName,
                                eventAdmin: adminEmail,
                                eventPrice: eventPrice,
                                buttonText: "\$${eventPrice.toString()}",
                                onTap: () {
                                  displayBuyDialog(event, context);
                                },
                              );
                  },
                ));
              }))
        ],
      ),
    );
  }
}
