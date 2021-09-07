import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:widgets/widgets.dart';

RxInt tabIndex = 0.obs;

class Tabs extends StatelessWidget {
  const Tabs({
    required this.menus,
    required this.children,
    this.divider = const Divider(),
    Key? key,
  }) : super(key: key);

  final List<String> menus;
  final List<Widget> children;
  final Widget divider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabMenu(this.menus),
        divider,
        TabItem(children: children),
      ],
    );
  }
}

class TabItem extends StatelessWidget {
  const TabItem({required this.children, Key? key}) : super(key: key);

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Obx(() => children[tabIndex.value]);
  }
}

class TabMenu extends StatelessWidget {
  const TabMenu(this.menus, {this.onTap, Key? key}) : super(key: key);

  final List<String> menus;
  final Function? onTap;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        for (int i = 0; i < menus.length; i++)
          GestureDetector(
            onTap: () {
              tabIndex.value = i;
              if (onTap != null) onTap!(i);
            },
            behavior: HitTestBehavior.opaque,
            child: Container(
              padding: EdgeInsets.all(xxs),
              decoration: BoxDecoration(
                color: tabIndex.value == i ? Colors.blue[100] : Colors.grey[200],
                borderRadius: BorderRadius.circular(xxs),
              ),
              child: Text(menus[i]),
            ),
          ),
      ],
    );
  }
}
