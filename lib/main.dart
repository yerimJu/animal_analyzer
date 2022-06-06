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
        body: const MyStatelessWidget(),
        // body: Center(child: showGrid ? _buildGrid() : _buildList()),
      ),
    );
  }
}

class MyStatelessWidget extends StatelessWidget {
  const MyStatelessWidget({Key? key}) : super(key: key);

  List<Container> _buildGridTileList(int count) => List.generate(
      count, (i) => Container(child: Image.asset('images/pic$i.jpg')));

  @override
  Widget build(BuildContext context) {
    final AlertDialog dialog = AlertDialog(
      title: const Text('Alert'),
      content: const Text('Are you sure to submit the selected image?'),
      actions: [
        TextButton(
          onPressed: () {
            debugPrint('[AlertDialog] Received cancel');
          },
          child: const Text('CANCEL'),
        ),
        TextButton(
          onPressed: () {
            debugPrint('[AlertDialog] Received submit');
            Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (BuildContext context) => const FullScreenDialog(),
                fullscreenDialog: true,
              ),
            );
          },
          child: const Text('SUBMIT'),
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
            childAspectRatio: 1 / 2, //item 의 가로 1, 세로 2 의 비율
            mainAxisSpacing: 20, //수평 Padding
            crossAxisSpacing: 20, //수직 Padding
          ),
          itemBuilder: (BuildContext context, int index) {
            return GridView.extent(
                maxCrossAxisExtent: 300,
                padding: const EdgeInsets.all(4),
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                children: _buildGridTileList(10));
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
            showDialog<void>(context: context, builder: (context) => dialog);
          },
          child: const Text('Submit'),
        ),
      ],
    );
  }
}

class FullScreenDialog extends StatelessWidget {
  const FullScreenDialog({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF6200EE),
        title: const Text('Result'),
      ),
      body: const Center(
        child: Text('This is result. Enjoy app!'),
      ),
    );
  }
}
