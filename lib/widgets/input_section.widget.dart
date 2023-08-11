import 'package:flutter/material.dart';

import '../controllers/mention_input_text_editing.controller.dart';

class InputSection extends StatelessWidget {
  final List<Widget>? leftWidgets;
  final List<Widget>? rightWidgets;
  final double leftInputMargin;
  final double rightInputMargin;
  final bool hasSendButton;
  final bool shouldShowSendButton;
  final bool clearTextAfterSent;
  final Function? onSend;
  final MentionInputTextEditingController controller;
  final FocusNode focusNode;
  final String? placeHolder;
  final bool? autoFocus;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final BorderRadius? borderRadius;
  final Decoration? decoration;
  final Widget? sendIcon;
  final bool shouldHideRightWidgets;
  final bool shouldHideLeftWidgets;
  final int? minLines;
  final int? maxLines;
  final int? maxLength;
  final Color? cursorColor;
  final TextInputType? keyboardType;
  final TextStyle? style;
  final TextStyle? hintStyle;
  final TextAlign textAlign;
  final TextAlignVertical? textAlignVertical;
  final TextCapitalization textCapitalization;
  final TextDirection? textDirection;
  final double? textContainerHeight;
  final double? textContainerWidth;

  const InputSection(
      {super.key,
      required this.leftInputMargin,
      required this.rightInputMargin,
      required this.hasSendButton,
      required this.shouldShowSendButton,
      required this.focusNode,
      required this.controller,
      required this.shouldHideLeftWidgets,
      required this.shouldHideRightWidgets,
      this.leftWidgets,
      this.rightWidgets,
      this.onSend,
      this.clearTextAfterSent = true,
      this.placeHolder,
      this.autoFocus,
      this.padding,
      this.color,
      this.borderRadius,
      this.decoration,
      this.sendIcon,
      this.cursorColor,
      this.maxLength,
      this.minLines,
      this.maxLines,
      this.keyboardType,
      this.textCapitalization = TextCapitalization.none,
      this.textAlign = TextAlign.start,
      this.style,
      this.hintStyle,
      this.textAlignVertical,
      this.textDirection,
      this.textContainerHeight,
      this.textContainerWidth
      });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(16),
      width: textContainerWidth,
      decoration: decoration ??
          BoxDecoration(
            borderRadius: borderRadius ?? BorderRadius.circular(16),
            color: color ?? Colors.white,
          ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          IntrinsicHeight(
            child: Row(
              children: [
                if (!shouldHideLeftWidgets) ...?leftWidgets,
                SizedBox(
                  width: leftWidgets != null ? leftInputMargin : 0,
                ),
                Expanded(
                  child: SizedBox(
                    height: textContainerHeight,
                    child: TextField(
                      minLines: minLines,
                      maxLines: maxLines,
                      maxLength: maxLength,
                      keyboardType: keyboardType,
                      style: style,
                      textAlign: textAlign,
                      textAlignVertical: textAlignVertical,
                      textCapitalization: textCapitalization,
                      textDirection: textDirection,
                      cursorColor: cursorColor,
                      controller: controller,
                      focusNode: focusNode,
                      autofocus: autoFocus ?? false,
                      decoration: InputDecoration(
                          hintStyle: hintStyle,
                          hintText: placeHolder ?? "Aa",
                          border: InputBorder.none),
                    ),
                  ),
                ),
                SizedBox(
                  width: rightWidgets != null ? rightInputMargin : 0,
                ),
                if (!shouldHideRightWidgets) ...?rightWidgets,
                shouldShowSendButton && hasSendButton
                    ? const SizedBox(width: 8)
                    : const SizedBox(),
                shouldShowSendButton && hasSendButton
                    ? IconButton(
                        padding: EdgeInsets.zero,
                        icon: sendIcon ?? const Icon(Icons.send),
                        onPressed: () {
                          onSend?.call();
                          if (clearTextAfterSent) controller.clear();
                        },
                      )
                    : const SizedBox(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
