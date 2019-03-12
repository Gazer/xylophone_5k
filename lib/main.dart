import 'dart:async';

import 'package:flutter/material.dart';
import 'package:audioplayers/audio_cache.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '5k Xylophone',
      home: Xylophone(),
    );
  }
}

typedef void OnPlayNode(String s);

class Xylophone extends StatefulWidget {
  final AudioCache player = new AudioCache(prefix: 'audio/');

  final List<String> notes = [
    "C1", " ", " ", "G1", " ",
    "F1", "E1", "D1", "C2", " ", " ", "G1",
    " ",
    "F1", "E1", "D1", "C2", " ", " ", "G1",
    " ", " ",
    "F1", "E1",
    "F1", "D1", "X"
  ];

  @override
  _XylophoneState createState() => _XylophoneState();
}

class _XylophoneState extends State<Xylophone> {
  var pressedNote = "";
  var currentNote = 0;

  @override
  Widget build(BuildContext context) {
    var play = (note) {
      widget.player.play(note);
    };

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Positioned(
              right: 32.0,
              top: 8.0,
              child: InkWell(
                child: Row(
                  children: <Widget>[
                    Text("Try me! "),
                    Icon(Icons.play_arrow),
                  ],
                ),
                onTap: () {
                  currentNote = 0;

                  Timer.periodic(Duration(milliseconds: 200), (Timer t) {
                    pressedNote = "";

                    var note = widget.notes[currentNote];
                    if (note == 'X') {
                      t.cancel();
                      setState(() {});
                    } else if (note != ' ') {
                      play("$note.wav");
                      setState(() {
                        pressedNote = note;
                      });
                    }
                    currentNote++;
                  });
                },
              ),
            ),
            Positioned.fill(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 32.0, horizontal: 32.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    NoteWidget("C1", Colors.blue, 0, pressedNote, play),
                    NoteWidget("D1", Colors.green, 1, pressedNote, play),
                    NoteWidget("E1", Colors.yellow, 2, pressedNote, play),
                    NoteWidget("F1", Colors.deepOrange, 3, pressedNote, play),
                    NoteWidget("G1", Colors.pink, 4, pressedNote, play),
                    NoteWidget("A1", Colors.purple, 5, pressedNote, play),
                    NoteWidget("B1", Colors.redAccent, 6, pressedNote, play),
                    NoteWidget("C2", Colors.blue, 7, pressedNote, play),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NoteWidget extends StatefulWidget {
  final String name;
  final Color color;
  final int i;
  final OnPlayNode callback;
  final String pressedNote;

  NoteWidget(this.name, this.color, this.i, this.pressedNote, this.callback);

  @override
  _NoteWidgetState createState() => _NoteWidgetState();
}

class _NoteWidgetState extends State<NoteWidget> {
  bool pressed = false;

  @override
  void initState() {
    super.initState();

    pressed = widget.name == widget.pressedNote;
  }

  @override
  void didUpdateWidget(NoteWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    pressed = widget.name == widget.pressedNote;
  }

  @override
  Widget build(BuildContext context) {
    var shadow = BoxShadow(
      color: Colors.black.withOpacity(pressed ? .5 : 0),
      offset: Offset(0.0, 0.0),
      spreadRadius: 3.0,
      blurRadius: 4.0,
    );

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0 * widget.i),
      child: GestureDetector(
        onTap: () {},
        onTapDown: (_) {
          setState(() {
            pressed = true;
            widget.callback("${widget.name}.wav");
          });
        },
        onTapUp: (_) {
          setState(() {
            pressed = false;
          });
        },
        onTapCancel: () {
          setState(() {
            pressed = false;
          });
        },
        child: Container(
          width: 75.0,
          height: double.infinity,
          decoration: BoxDecoration(
            color: widget.color,
            borderRadius: BorderRadius.circular(20.0),
            boxShadow: [
              shadow
            ],
          ),
          child: Center(
            child: Text(widget.name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
                color: Colors.white,
                shadows: [
                  shadow
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}