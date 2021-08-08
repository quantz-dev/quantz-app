import 'package:flutter/material.dart';
import 'package:momentum/momentum.dart';

import '../../../components/filter/index.dart';
import '../../index.dart';

class StatusOption extends StatelessWidget {
  const StatusOption({Key? key}) : super(key: key);

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
          return current.showOngoing == prev?.showOngoing && current.showUpcoming == prev?.showUpcoming;
        },
        /* optimization */
        builder: (context, snapshot) {
          final filter = snapshot<FilterModel>();
          return Column(
            children: [
              ListTile(
                leading: filter.showOngoing
                    ? Icon(
                        Icons.check,
                        color: primary,
                      )
                    : SizedBox(),
                title: Text('Currently Airing'),
                onTap: () {
                  final controller = Momentum.controller<FilterController>(context);
                  controller.toggleOngoing();
                },
              ),
              ListTile(
                leading: filter.showUpcoming
                    ? Icon(
                        Icons.check,
                        color: primary,
                      )
                    : SizedBox(),
                title: Text('Upcoming'),
                onTap: () {
                  final controller = Momentum.controller<FilterController>(context);
                  controller.toggleUpcoming();
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
