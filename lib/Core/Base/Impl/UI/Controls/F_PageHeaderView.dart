import 'package:flutter/material.dart';
import 'package:movies_flutter/Core/Base/Impl/Utils/NumConstants.dart';

import '../../../MVVM/ViewModels/PageViewModel.dart';
import 'F_CircleIconButton.dart';


class F_PageHeaderView extends StatelessWidget implements PreferredSizeWidget
{
  final String title;

  final IconData leftIcon;
  final VoidCallback? onLeftPressed;

  final IconData? rightIcon;
  final VoidCallback? onRightPressed;

  final double height;

  final PageViewModel viewModel;

  const F_PageHeaderView({
    super.key,
    required this.viewModel,
    required this.title,
    this.leftIcon = Icons.arrow_back,
    this.onLeftPressed,
    this.rightIcon,
    this.onRightPressed,
    this.height = NumConstants.ActionBarHeight,
  });

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context)
  {
    return AppBar(
      toolbarHeight: height,
      //(viewModel.CanGoBack && onLeftPressed == null) ?
      leading:  Padding(
        padding: const EdgeInsets.only(left: 8),
        child: F_CircleIconButton(
          icon: leftIcon,
          onPressed: onLeftPressed ?? () { this.viewModel.BackCommand.Execute(); },
        ),
      ),

      automaticallyImplyLeading: false,

      title: Text(title),

      actions: rightIcon == null
          ? null
          : [Padding(padding: const EdgeInsets.only(right: 8),
                      child: SizedBox(
                        width: 48,
                        height: 48,
                        child: F_CircleIconButton(
                          icon: rightIcon!,
                          onPressed: onRightPressed!,
                        ),
                      ),
                    ),
      ],
    );
  }
}
