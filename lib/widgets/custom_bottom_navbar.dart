import 'package:flutter/material.dart';

typedef ItemTapNavigation = void Function(int index);

class CustomBottomNavBar extends StatefulWidget {
  const CustomBottomNavBar({
    Key key,
    @required this.onTap,
    @required this.currentIndex,
    @required this.items,
  }) : super(key: key);

  final ItemTapNavigation onTap;
  final int currentIndex;
  final List<CustomBottomNavBarItem> items;

  @override
  _CustomBottomNavBarState createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: kBottomNavigationBarHeight,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: widget.items.map((item) => _buildItem(item)).toList(),
      ),
    );
  }

  Widget _buildItem(CustomBottomNavBarItem item) {
    var activeColor = item.selectedColor ?? Theme.of(context).primaryColor;
    var inactiveColor = Colors.grey;
    var thisIndex = widget.items.indexOf(item);
    var isCurrentIndex = widget.currentIndex == thisIndex;
    var color = isCurrentIndex ? activeColor : inactiveColor;

    var textStyle = TextStyle(
      color: activeColor,
      fontWeight: FontWeight.bold,
    );

    var childSwitch = isCurrentIndex
        ? Row(
            children: [
              SizedBox(width: 7),
              Text(item.title, style: textStyle),
            ],
          )
        : SizedBox();

    var iconSwitch = isCurrentIndex
        ? Icon(
            item.icon,
            key: ValueKey(1),
            color: activeColor,
          )
        : Icon(
            item.icon,
            key: ValueKey(2),
            color: inactiveColor,
          );

    return Expanded(
      child: GestureDetector(
        onTap: () => _tapItem(thisIndex),
        behavior: HitTestBehavior.translucent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              // width: isCurrentIndex ? 110 : 46,
              padding: EdgeInsets.symmetric(vertical: 7, horizontal: 10),
              decoration: BoxDecoration(
                  color: isCurrentIndex ? item.boxColor : Colors.white,
                  borderRadius: BorderRadius.circular(10)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedSwitcher(
                    duration: Duration(milliseconds: 200),
                    switchInCurve: Curves.easeInOut,
                    switchOutCurve: Curves.easeInOut,
                    reverseDuration: Duration(milliseconds: 300),
                    child: iconSwitch,
                  ),
                  AnimatedSwitcher(
                    duration: Duration(milliseconds: 200),
                    child: childSwitch,
                    reverseDuration: Duration.zero,
                    switchInCurve: Curves.easeInOut,
                    transitionBuilder: (widget, animation) {
                      return ScaleTransition(
                        scale: animation,
                        alignment: Alignment.centerLeft,
                        child: widget,
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _tapItem(int index) {
    if (index != widget.currentIndex) {
      widget.onTap(index);
    }
  }
}

class CustomBottomNavBarItem {
  final IconData icon;
  final String title;

  ///Si Se da un color debes colocar otro en box color
  final Color selectedColor;
  final Color boxColor;
  const CustomBottomNavBarItem({
    @required this.icon,
    @required this.title,
    this.selectedColor,
    this.boxColor,
  });
}
