import 'package:flutter/material.dart';
import 'package:momentum/momentum.dart';

import '../components/animelist/index.dart';

class SearchWidget extends StatefulWidget {
  const SearchWidget({Key? key}) : super(key: key);

  @override
  _SearchWidgetState createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final controller = TextEditingController(text: '');
  AnimelistController? listController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    listController = Momentum.controller<AnimelistController>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 12),
      decoration: BoxDecoration(
        color: Color(0xff151515),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: controller,
              decoration: InputDecoration(
                border: InputBorder.none,
                errorBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
                hintText: 'Search',
                isDense: true,
              ),
              maxLines: 1,
              onChanged: (value) {
                listController?.search(value);
              },
            ),
          ),
          Container(
            width: 32,
            child: TextButton(
              child: Icon(
                Icons.close,
                color: Colors.white.withOpacity(0.7),
              ),
              style: ButtonStyle(
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                foregroundColor: MaterialStateProperty.all(Colors.white),
                padding: MaterialStateProperty.all(EdgeInsets.zero),
              ),
              onPressed: () {
                controller.clear();
                listController?.search('');
                FocusScope.of(context).unfocus();
              },
            ),
          ),
        ],
      ),
    );
  }
}
