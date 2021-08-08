import 'package:flutter/material.dart';
import 'package:momentum/momentum.dart';

import '../../../components/filter/index.dart';
import '../../index.dart';

const _options = DisplayTitle.values;

class DisplayOption extends StatelessWidget {
  const DisplayOption({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: MomentumBuilder(
        controllers: [FilterController],
        /* optimization */
        dontRebuildIf: (ctrl, isTimeTravel) {
          final controller = ctrl<FilterController>();
          final current = controller.model;
          final prev = controller.prevModel;
          return current.displayTitle == prev?.displayTitle;
        },
        /* optimization */
        builder: (context, snapshot) {
          final filter = snapshot<FilterModel>();
          return ListView.builder(
            itemCount: _options.length,
            itemBuilder: (context, index) {
              final item = _options[index];
              final isSelected = item == filter.displayTitle;
              return ListTile(
                leading: isSelected
                    ? Icon(
                        Icons.check,
                        color: primary,
                      )
                    : SizedBox(),
                title: Text(displayTitleLabel(item)),
                onTap: () {
                  final controller = Momentum.controller<FilterController>(context);
                  controller.setDisplayTitle(item);
                },
              );
            },
          );
        },
      ),
    );
  }
}
