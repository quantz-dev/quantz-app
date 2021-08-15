import 'package:flutter/material.dart';

class MenuListItem extends StatelessWidget {
  const MenuListItem({
    Key? key,
    this.title = '',
    this.titleWidget,
    this.subtitle = '',
    required this.icon,
    this.trail = const SizedBox(),
    this.onTap,
  }) : super(key: key);

  final String title;
  final Widget? titleWidget;
  final String subtitle;
  final IconData icon;
  final Widget trail;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        height: 100,
        child: Icon(icon),
      ),
      title: titleWidget ??
          Text(
            title,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
      subtitle: Text(
        subtitle,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
      trailing: trail,
      onTap: onTap ?? () {},
    );
  }
}
