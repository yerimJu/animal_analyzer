import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show debugPaintSizeEnabled;

void main() {
  debugPaintSizeEnabled = false; // Set to true for visual layout
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  static const showGrid = true; // Set to false to show ListView

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Animal Analyzer',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Animal Analyzer Demo'),
        ),
        body: const MyStatefulWidget(),
        // body: Center(child: showGrid ? _buildGrid() : _buildList()),
      ),
    );
  }
}

// #docregion FavoriteWidget
class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({super.key});

  @override
  MyStatelessWidget createState() => MyStatelessWidget();
}

class MyStatelessWidget extends State<MyStatefulWidget> {
  // const MyStatelessWidget({Key? key}) : super(key: key);
  static const _picCounts = 10;
  int _selectedPicNum = -1;

  void _setPicNum(i) {
    setState(() {
      _selectedPicNum = i;
    });
    debugPrint("[_setPicNum] ${_selectedPicNum.toString()}");
  }

  List<Container> _buildGridTileList(int count) => List.generate(
      count,
      (i) => Container(
          child: InkWell(
              onTap: () {
                // debugPrint('[_buildGridTileList] Received click from pic$i');
                _setPicNum(i);
              },
              child: Ink.image(
                image: AssetImage('images/pic$i.jpg'),
                fit: BoxFit.cover,
                child: _selectedPicNum == i
                    ? InkWell(
                        onTap: () {
                          debugPrint("[InkWell] clicked ${i}th img");
                        },
                        child: const Align(
                          child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text(
                              'SELECTED',
                              style: TextStyle(
                                fontSize: 50,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      )
                    : null,
              ))));

  @override
  Widget build(BuildContext context) {
    final AlertDialog dialog = AlertDialog(
      title: const Text('Alert'),
      content: const Text('Are you sure to submit the selected image?'),
      actions: [
        TextButton(
          onPressed: () {
            debugPrint('[AlertDialog] Received cancel');
            Navigator.pop(context, false);
          },
          child: const Text('CANCEL'),
        ),
        TextButton(
          onPressed: () {
            debugPrint('[AlertDialog] Received submit');
            Navigator.pop(context, false);
            Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (BuildContext context) =>
                    FullScreenDialog(picNum: _selectedPicNum),
                fullscreenDialog: true,
              ),
            );
          },
          child: const Text('SUBMIT'),
        ),
      ],
    );

    final AlertDialog dialogForValid = AlertDialog(
      title: const Text('Alert'),
      content: const Text('Please select a image.'),
      actions: [
        TextButton(
          onPressed: () {
            debugPrint('[dialogForValid] Received OK');
            Navigator.pop(context, false);
          },
          child: const Text('OK'),
        ),
      ],
    );

    // final AlertDialog dialog_with_options = AlertDialog(
    //   title: const Text('Title'),
    //   contentPadding: EdgeInsets.zero,
    //   content: Column(
    //     mainAxisSize: MainAxisSize.min,
    //     children: [
    //       for (int i = 1; i <= 3; i++)
    //         ListTile(
    //           title: Text(
    //             'option $i',
    //             style: Theme.of(context).textTheme.subtitle1,
    //           ),
    //           leading: Radio(
    //             value: i,
    //             groupValue: 1,
    //             onChanged: (_) {},
    //           ),
    //         ),
    //     ],
    //   ),
    //   actions: [
    //     TextButton(
    //       onPressed: () => Navigator.pop(context),
    //       child: const Text('ACTION 1'),
    //     ),
    //     TextButton(
    //       onPressed: () => Navigator.pop(context),
    //       child: const Text('ACTION 2'),
    //     ),
    //   ],
    // );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Expanded(
            child: GridView.builder(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          itemCount: 1,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1, //1 개의 행에 보여줄 item 개수
            childAspectRatio: 1 / 3, //item 의 가로 1, 세로 2 의 비율
            mainAxisSpacing: 20, //수평 Padding
            crossAxisSpacing: 20, //수직 Padding
          ),
          itemBuilder: (BuildContext context, int index) {
            return GridView.extent(
                maxCrossAxisExtent: 300,
                padding: const EdgeInsets.all(4),
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                children: _buildGridTileList(_picCounts));
          },
        )),
        Material(
          color: Colors.white,
          child: Center(
            child: Ink(
              decoration: const ShapeDecoration(
                color: Colors.lightBlue,
                shape: CircleBorder(),
              ),
              child: IconButton(
                icon: const Icon(Icons.add_a_photo_outlined),
                color: Colors.white,
                onPressed: () {
                  debugPrint('[IconButton] Received click');
                },
              ),
            ),
          ),
        ),
        OutlinedButton(
          onPressed: () {
            debugPrint('[OutlinedButton] Received click');
            if (_selectedPicNum == -1) {
              showDialog<void>(
                  context: context, builder: (context) => dialogForValid);
            } else {
              showDialog<void>(context: context, builder: (context) => dialog);
            }
          },
          child: const Text('Submit'),
        ),
      ],
    );
  }
}

class FullScreenDialog extends StatelessWidget {
  const FullScreenDialog({Key? key, required this.picNum}) : super(key: key);
  final int picNum;

  @override
  Widget build(BuildContext context) {
    debugPrint("[FullScreenDialog] result: ${picNum.toString()}th pic");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF6200EE),
        title: const Text('Result'),
      ),
      body: Center(
          child: Column(
        children: [
          const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text("This is result. Enjoy app!\nemotion: 편안/안정")),
          Image.asset('images/pic$picNum.jpg', width: 300),
        ],
      )),
    );
  }
}
