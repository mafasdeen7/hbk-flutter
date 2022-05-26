import 'package:flutter/material.dart';

class ShowFullScreenImageScreen extends StatefulWidget {
  static const routeName = "/show-image";

  @override
  _ShowFullScreenImageScreenState createState() =>
      _ShowFullScreenImageScreenState();
}

class _ShowFullScreenImageScreenState extends State<ShowFullScreenImageScreen> {
  bool _loadedInitData = false;
  bool _loading = false;
  String fileUrl;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (!_loadedInitData) {
      setState(() {
        _loading = true;
      });

      //
      final args =
          ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
      fileUrl = args['fileUrl'];

      setState(() {
        _loading = false;
      });

      _loadedInitData = true;
    }
  }

  downloadFile() async {
    print('download');
    print(fileUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Deposit Slip'),
        // actions: <Widget>[
        //   IconButton(
        //     icon: Icon(
        //       Icons.file_download,
        //       color: Colors.white,
        //     ),
        //     onPressed: downloadFile,
        //   )
        // ],
      ),
      body: GestureDetector(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Hero(
            tag: 'imageHero',
            child: Image.network(
              fileUrl,
            ),
          ),
        ),
      ),
    );
  }
}
