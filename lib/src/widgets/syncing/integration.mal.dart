import 'package:flutter/material.dart';
import 'package:momentum/momentum.dart';

import '../../components/integration/index.dart';
import '../index.dart';
import '../inputs/index.dart';

Future<bool> showImportMAL(BuildContext context) async {
  final popped = await showDialog<bool>(context: context, builder: (_) => _ImportMAL());
  return popped ?? false;
}

Future<void> showMalImportProgress(BuildContext context) async {
  await showDialog(
    context: context,
    builder: (_) => _ImportProgress(),
    barrierDismissible: false,
  );
  return;
}

class _ImportMAL extends StatelessWidget {
  const _ImportMAL({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Momentum.controller<IntegrationController>(context);
    final username = controller.model.malUsername;

    return Dialog(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              initialValue: controller.model.malUsername,
              readOnly: true,
              enabled: false,
              decoration: InputDecoration(
                border: new OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(4),
                  ),
                ),
                hintText: 'MAL Username',
                hintStyle: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.6),
                ),
                filled: true,
                fillColor: Color(0xff151515),
                isDense: true,
              ),
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
              maxLines: 1,
              minLines: 1,
              onChanged: (value) {
                controller.model.update(malUsername: value);
              },
            ),
            SizedBox(height: 8),
            MomentumBuilder(
              controllers: [IntegrationController],
              builder: (context, snapshot) {
                var model = controller.model;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CheckboxWidget(
                      value: model.syncSub,
                      label: 'Sub',
                      onChanged: (value) {
                        model.update(syncSub: value);
                      },
                    ),
                    CheckboxWidget(
                      value: model.syncDub,
                      label: 'Dub',
                      onChanged: (value) {
                        model.update(syncDub: value);
                      },
                    ),
                  ],
                );
              },
            ),
            CustomButton(
              color: primary,
              text: 'Start Import',
              textColor: Colors.white,
              onPressed: username.isEmpty
                  ? null
                  : () {
                      controller.loadMalList();
                      Navigator.pop(context, true);
                    },
            ),
            SizedBox(height: 8),
            CustomButton(
              color: Colors.redAccent,
              text: 'Logout',
              textColor: Colors.white,
              onPressed: () async {
                await controller.logout();
                Navigator.pop(context, false);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ImportProgress extends StatefulWidget {
  const _ImportProgress({Key? key}) : super(key: key);

  @override
  __ImportProgressState createState() => __ImportProgressState();
}

class __ImportProgressState extends MomentumState<_ImportProgress> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Momentum.controller<IntegrationController>(context).listen<IntegrationEvents>(
      state: this,
      invoke: (event) {
        switch (event) {
          case IntegrationEvents.done:
            Navigator.pop(context);
            break;
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Dialog(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          width: double.infinity,
          child: MomentumBuilder(
            controllers: [IntegrationController],
            builder: (context, snapshot) {
              var import = snapshot<IntegrationModel>();

              var hasNothingToImport = import.statToImport == 0;
              var progress = import.statProgress / import.statToImport;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Importing ${import.malUsername}\'s anime list.'),
                  SizedBox(height: 16),
                  SizedBox(
                    height: 3,
                    width: double.infinity,
                    child: LinearProgressIndicator(
                      value: hasNothingToImport ? null : progress,
                      minHeight: 3,
                    ),
                  ),
                  SizedBox(height: hasNothingToImport ? 0 : 16),
                  hasNothingToImport ? SizedBox() : Text('${import.statProgress}/${import.statToImport}'),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
