import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';
import 'package:zal/Screens/ConnectedScreen/connected_screen_providers.dart';
import 'package:zal/Screens/MainScreen/main_screen_providers.dart';

class IsProgramAdminstratorWidget extends ConsumerWidget {
  const IsProgramAdminstratorWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final computerData = ref.watch(computerDataProvider).value;
    if (computerData?.isRunningAsAdminstrator ?? false) {
      return Container();
    }
    return Card(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
        child: Column(
          children: [
            const Text("the program is not running as Adminstrator, some data will not be available."),
            ElevatedButton.icon(
              onPressed: () {
                ref.read(socketProvider.notifier).sendMessage("restart_admin", "");
              },
              icon: const Icon(Icons.admin_panel_settings),
              label: const Text("restart program as adminstrator"),
            ),
          ],
        ),
      ),
    );
  }
}
