import 'package:flutter/material.dart';
import '../utils/dimensions.dart';

class CustomButtonNotification extends StatefulWidget {
  final String buttonText;
  final List<String?> notifications;
  final Color? btnColor;
  final Color? expandColor;
  final bool alert;
  const CustomButtonNotification({
    super.key,
    required this.buttonText,
    required this.notifications,
    required this.alert,
    required this.btnColor,
    required this.expandColor,
  });
  @override
  State<CustomButtonNotification> createState() => _CustomButtonNotification();
}

class _CustomButtonNotification extends State<CustomButtonNotification> {
  late bool buttonShow;
  late List<String?> _notifications;
  final expand = ExpansionTileController();

  @override
  void initState() {
    buttonShow = false;
    _notifications = widget.notifications;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final count =
        _notifications.isNotEmpty ? ' (${_notifications.length})' : '';
    return Column(
      children: [
        Stack(alignment: Alignment.topCenter, children: [
          ExpansionTile(
            controller: expand,
            title: const Text(''),
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                color:  Colors.transparent,
                child: Column(
                    spacing: 10,
                    children: List.generate(
                      _notifications.length,
                      (index) => Card(
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              vertical: Dimensions.paddingSizeExtraLarge,
                              horizontal: Dimensions.paddingSizeDefault),
                          child: Text(
                            _notifications[index] ?? '',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ),
                      ),
                    )),
              ),
            ],
          ),
          Card(
            color: widget.btnColor ?? Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: Dimensions.paddingSizeExtraSmall,
                  horizontal: Dimensions.paddingSizeDefault),
              child: Row(
                spacing: 5,
                children: [
                  const Icon(Icons.notifications, size: Dimensions.iconSizeExtraLarge, ),
                  Expanded(
                    child: Text(
                      '${widget.buttonText}$count',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                  IconButton.filledTonal(
                      onPressed: () {
                        setState(() {
                          expand.isExpanded
                              ? expand.collapse()
                              : expand.expand();
                        });
                      },
                      icon: widget.alert
                          ? const Icon(
                              Icons.arrow_forward_ios_rounded,
                            )
                          : const Icon(
                              Icons.keyboard_arrow_down_sharp,
                        size: Dimensions.iconSizeExtraLarge
                            ),
                      style: widget.alert
                          ? IconButton.styleFrom(
                              backgroundColor: Colors.white,
                            )
                          : IconButton.styleFrom(
                              backgroundColor: Colors.transparent,
                            )),
                ],
              ),
            ),
          ),
        ]),
      ],
    );
  }
}
