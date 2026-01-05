import 'package:flutter/material.dart';
import 'package:movies_flutter/Core/Base/Impl/Utils/FontConstants.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../Core/Base/Impl/UI/Controls/F_IconTextButton.dart';
import '../../../Core/Base/Impl/Utils/ColorConstants.dart';

class SideMenuView extends StatelessWidget
{
  // Callbacks from parent
  final VoidCallback onShareLogs;
  final VoidCallback onLogout;

  const SideMenuView({
    super.key,
    required this.onShareLogs,
    required this.onLogout,
  });

  Future<String> _getVersionText() async
  {
    final info = await PackageInfo.fromPlatform();
    return 'Version: ${info.version} (${info.buildNumber})';
  }

  @override
  Widget build(BuildContext context)
  {
    return Container(
      color: Colors.white,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          const SizedBox(height: 80),

          // Share Logs button
          F_IconTextButton(
            normalColor: Colors.white,
            pressedColor: ColorConstants.PrimaryColor2,
            onTouchDown: () {},
            onTouchUp: onShareLogs,
            icon: Icons.share,
            text: 'Share Logs',
            height: 60,
          ),

          // Logout button
          F_IconTextButton(
            normalColor: Colors.white,
            pressedColor: ColorConstants.PrimaryColor2,
            onTouchDown: () {},
            onTouchUp: onLogout,
            icon: Icons.logout,
            text: 'Logout',
            height: 60,
          ),

          // Flexible spacer
          const Spacer(),

          // Version text bottom-right
          Padding(
            padding: const EdgeInsets.only(bottom: 50, left: 30, right: 30,),
            child: Row(
              children: [
                const Spacer(),
                FutureBuilder<String>(
                  future: _getVersionText(),
                  builder: (context, snapshot)
                  {
                    return Text(snapshot.data ?? '',
                      style: const TextStyle(
                        fontFamily: FontConstants.RegularFont,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: ColorConstants.LabelColor,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
