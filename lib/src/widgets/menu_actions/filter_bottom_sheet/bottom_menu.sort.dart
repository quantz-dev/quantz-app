import 'package:flutter/material.dart';
import 'package:momentum/momentum.dart';

import '../../../components/filter/index.dart';
import '../../index.dart';

const _options = SortBy.values;

class SortByOption extends StatelessWidget {
  const SortByOption({Key? key}) : super(key: key);

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
          return current.sortBy == prev?.sortBy;
        },
        /* optimization */
        builder: (context, snapshot) {
          final filter = snapshot<FilterModel>();
          return ListView.builder(
            itemCount: _options.length,
            itemBuilder: (context, index) {
              final item = _options[index];
              final isSelected = item == filter.sortBy;
              return ListTile(
                leading: isSelected
                    ? Icon(
                        Icons.check,
                        color: primary,
                      )
                    : SizedBox(),
                title: Text(sortByLabel(item)),
                onTap: () {
                  final controller = Momentum.controller<FilterController>(context);
                  controller.setSortBy(item);
                },
              );
            },
          );
        },
      ),
    );
  }
}
