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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
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
        OutlinedButton(
          onPressed: () {
            debugPrint('Received click');
          },
          child: const Text('Click Me'),
        ),
      ],
    );
  }
}

// // The images are saved with names pic0.jpg, pic1.jpg...pic29.jpg.
// // The List.generate() constructor allows an easy way to create
// // a list when objects have a predictable naming pattern.
// List<Container> _buildGridTileList(int count) => List.generate(
//     count, (i) => Container(child: Image.asset('images/pic$i.jpg')));
// // #enddocregion grid


// // #docregion grid
// Widget _buildGrid() => GridView.extent(
//     maxCrossAxisExtent: 300,
//     padding: const EdgeInsets.all(4),
//     mainAxisSpacing: 4,
//     crossAxisSpacing: 4,
//     children: _buildGridTileList(10));

// // #docregion list
// Widget _buildList() {
//   return ListView(
//     children: [
//       _tile('CineArts at the Empire', '85 W Portal Ave', Icons.theaters),
//       _tile('The Castro Theater', '429 Castro St', Icons.theaters),
//       _tile('Alamo Drafthouse Cinema', '2550 Mission St', Icons.theaters),
//       _tile('Roxie Theater', '3117 16th St', Icons.theaters),
//       _tile('United Artists Stonestown Twin', '501 Buckingham Way',
//           Icons.theaters),
//       _tile('AMC Metreon 16', '135 4th St #3000', Icons.theaters),
//       const Divider(),
//       _tile('K\'s Kitchen', '757 Monterey Blvd', Icons.restaurant),
//       _tile('Emmy\'s Restaurant', '1923 Ocean Ave', Icons.restaurant),
//       _tile('Chaiya Thai Restaurant', '272 Claremont Blvd', Icons.restaurant),
//       _tile('La Ciccia', '291 30th St', Icons.restaurant),
//     ],
//   );
// }

// ListTile _tile(String title, String subtitle, IconData icon) {
//   return ListTile(
//     title: Text(title,
//         style: const TextStyle(
//           fontWeight: FontWeight.w500,
//           fontSize: 20,
//         )),
//     subtitle: Text(subtitle),
//     leading: Icon(
//       icon,
//       color: Colors.blue[500],
//     ),
//   );
// }
// // #enddocregion list