import 'package:flutter/material.dart';
import 'package:mention_input/controllers/mention_input.controller.dart';
import 'package:mention_input/mention_input.dart';
import 'package:mention_input/models/mention.model.dart';
import 'package:mention_input/models/mention_data.model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final data1 = [
    MentionData(id: "1", display: "react"),
    MentionData(id: "2", display: "javascript"),
    MentionData(id: "3", display: "nodejs"),
    MentionData(id: "4", display: "angular"),
    MentionData(id: "5", display: "vue"),
  ];

  final data2 = [
    MentionData(id: "1", display: "flutter"),
    MentionData(id: "2", display: "react_native"),
    MentionData(id: "3", display: "native_script"),
  ];

  var controller = MentionInputController();

  bool isData1 = true;

  late List<MentionData> mentionData;

  @override
  void initState() {
    super.initState();

    mentionData = data1;
  }

  void changeDataSet() {
    setState(() {
      mentionData = isData1 ? data2 : data1;
      isData1 = !isData1;
    });

    controller.clearText();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Portal(
        child: KeyboardVisibilityProvider(
          child: Scaffold(
            body: Center(
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      MentionInput(
                        // rightWidgets: const [
                        //   Icon(Icons.access_alarm),
                        //   SizedBox(
                        //     width: 12,
                        //   )
                        // ],
                        controller: controller,
                        mentions: [
                          Mention(
                              triggerAnnotation: "@",
                              highlightStyle: const TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.w600),
                              data: [...mentionData])
                        ],
                      ),
                      ElevatedButton(
                          onPressed: changeDataSet,
                          child: const Text("Change data"))
                    ],
                  )),
            ),
          ),
        ),
      ),
    );
  }
}
