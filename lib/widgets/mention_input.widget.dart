part of mention_input;

// ignore: constant_identifier_names
const DEFAULT_ITEM_HEIGHT = 40.0;

enum SuggestionAlignment {
  top,
  bottom,
}

// ignore: must_be_immutable
class MentionInput extends StatefulWidget {
  // Properties for Suggestion Container
  Color? suggestionContainerColor;
  EdgeInsetsGeometry? suggestionContainerPadding;
  EdgeInsetsGeometry? suggestionContainerMargin;
  Decoration? suggestionContainerDecoration;
  SuggestionAlignment suggestionAlignment;
  double? suggestionContainerBorderRadius;

  // Properties for Suggestion Item
  double itemHeight;
  bool? dividerBetweenItem;

  // Properties for Text Field
  String? placeHolder;
  bool? autoFocus;
  bool clearTextAfterSent;
  double leftInputMargin;
  double rightInputMargin;
  List<Widget>? leftWidgets;
  List<Widget>? rightWidgets;

  // Data properties
  List<Mention> mentions;

  // Controller
  MentionInputController? controller;

  // Send Button
  Function? onSend;
  bool hasSendButton;

  MentionInput({
    super.key,
    required this.mentions,
    this.controller,
    this.suggestionContainerColor,
    this.suggestionContainerPadding,
    this.suggestionContainerMargin,
    this.suggestionContainerDecoration,
    this.suggestionAlignment = SuggestionAlignment.top,
    this.placeHolder,
    this.autoFocus,
    this.clearTextAfterSent = true,
    this.leftWidgets,
    this.rightWidgets,
    this.leftInputMargin = 8,
    this.rightInputMargin = 8,
    this.itemHeight = DEFAULT_ITEM_HEIGHT,
    this.dividerBetweenItem = true,
    this.onSend,
    this.hasSendButton = true,
  });

  @override
  State<MentionInput> createState() => _MentionInputState();
}

class _MentionInputState extends State<MentionInput> {
  bool isSuggestionsVisible = false;
  late MentionInputTextEditingController _controller;
  List<MentionData> suggestionList = [];
  SelectionWord? selectionWord;
  late FocusNode focusNode;
  AllMentionWords allMentionWords = {};
  late String allTriggerAnnotations;

  void updateAllMentionWords() {
    for (var mention in widget.mentions) {
      for (var mentionWord in mention.data) {
        allMentionWords["${mention.triggerAnnotation}${mentionWord.display}"] =
            MentionWord(
          style: mention.highlightStyle,
          id: mentionWord.id,
          trigger: mention.triggerAnnotation,
        );
      }
    }
  }

  void showSuggestions() {
    setState(() {
      isSuggestionsVisible = true;
    });
  }

  void hideSuggestions() {
    setState(() {
      isSuggestionsVisible = false;
    });
  }

  void _suggestionListener() {
    final cursorPos = _controller.selection.baseOffset;
    final fullText = _controller.text;

    if (fullText.isNotEmpty && cursorPos > 0) {
      var leftPos = cursorPos - 1;
      var rightPos = cursorPos - 1;

      var gotWord = false;

      while (!gotWord) {
        final leftChar = fullText[leftPos];
        final rightChar = fullText[rightPos];

        var gotStartIdxOfWord = (leftChar == " " || leftPos == 0);
        var gotEndIdxOfWord =
            (rightChar == " " || rightPos == fullText.length - 1);

        gotWord = gotStartIdxOfWord && gotEndIdxOfWord;

        if (!gotStartIdxOfWord) leftPos = max(0, leftPos - 1);
        if (!gotEndIdxOfWord) {
          rightPos = min(fullText.length - 1, rightPos + 1);
        }
      }

      final startIdxOfWord =
          leftPos == 0 && fullText[leftPos] != " " ? 0 : leftPos;
      final endIdxOfWord = rightPos + 1;

      final selectingWord =
          fullText.substring(startIdxOfWord, endIdxOfWord).trim();

      if (selectingWord
          .toLowerCase()
          .startsWith(RegExp(allTriggerAnnotations))) {
        final currentAnnotation = selectingWord[0];
        final word = selectingWord.substring(1);

        // TODO: Maybe implement debounce below this line

        suggestionList = widget.mentions
            .firstWhere(
                (mention) => mention.triggerAnnotation == currentAnnotation)
            .data
            .where((mention) => mention.display.contains(word))
            .toList();

        if (suggestionList.isNotEmpty) {
          selectionWord = SelectionWord(
              text: selectingWord,
              startIdx: startIdxOfWord,
              endIdx: endIdxOfWord);
          showSuggestions();
        } else {
          hideSuggestions();
        }
      } else {
        hideSuggestions();
      }
    } else {
      hideSuggestions();
    }
  }

  void addMention(String replaceText) {
    if (selectionWord == null) return;

    final annotation = selectionWord!.text[0];
    _controller.text = _controller.value.text.replaceRange(
        selectionWord!.startIdx == 0 ? 0 : selectionWord!.startIdx + 1,
        selectionWord!.endIdx,
        "$annotation$replaceText ");

    selectionWord = null;

    focusNode.requestFocus();
  }

  @override
  void initState() {
    super.initState();

    updateAllMentionWords();

    _controller = MentionInputTextEditingController(allMentionWords);

    _controller.addListener(_suggestionListener);

    if (widget.controller != null) {
      widget.controller!.clearText = () {
        _controller.clear();
      };

      widget.controller!.getText = () {
        return _controller.text;
      };
    }

    allTriggerAnnotations =
        widget.mentions.map((mention) => mention.triggerAnnotation).join("|");

    focusNode = FocusNode();
  }

  @override
  void didUpdateWidget(covariant MentionInput oldWidget) {
    super.didUpdateWidget(oldWidget);

    updateAllMentionWords();

    _controller.allMentionWords = allMentionWords;
  }

  @override
  void dispose() {
    _controller.removeListener(_suggestionListener);

    focusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isKeyboardVisible =
        KeyboardVisibilityProvider.isKeyboardVisible(context);

    return PortalTarget(
      visible: isSuggestionsVisible,
      anchor: Aligned(
          target: widget.suggestionAlignment == SuggestionAlignment.top
              ? Alignment.topCenter
              : Alignment.bottomCenter,
          follower: widget.suggestionAlignment == SuggestionAlignment.top
              ? Alignment.bottomCenter
              : Alignment.topCenter,
          widthFactor: 1),
      portalFollower: Container(
        constraints: BoxConstraints(
            minHeight: widget.itemHeight, maxHeight: widget.itemHeight * 4),
        height: widget.itemHeight * (suggestionList.length + 1),
        margin: widget.suggestionContainerMargin ??
            const EdgeInsets.symmetric(vertical: 16),
        padding: widget.suggestionContainerPadding ?? const EdgeInsets.all(16),
        decoration: widget.suggestionContainerDecoration ??
            BoxDecoration(
                borderRadius: BorderRadius.circular(
                    widget.suggestionContainerBorderRadius ?? 12),
                color: widget.suggestionContainerColor ?? Colors.amber),
        child: Scrollbar(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              ...suggestionList.asMap().entries.map((entry) {
                var index = entry.key;
                var mention = entry.value;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () => addMention(mention.display),
                      child: SizedBox(
                        width: double.infinity,
                        height: widget.itemHeight,
                        child: Row(
                          children: [
                            if (mention.imageUrl != null)
                              CircleAvatar(
                                backgroundImage:
                                    NetworkImage(mention.imageUrl!),
                              ),
                            const SizedBox(width: 12),
                            Text(
                              mention.display,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ),
                    index != suggestionList.length - 1 &&
                            widget.dividerBetweenItem!
                        ? const Divider()
                        : const SizedBox(),
                  ],
                );
              })
            ],
          ),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.greenAccent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                ...?widget.leftWidgets,
                SizedBox(
                  width:
                      widget.leftWidgets != null ? widget.leftInputMargin : 0,
                ),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    focusNode: focusNode,
                    onTapOutside: (event) =>
                        FocusManager.instance.primaryFocus?.unfocus(),
                    autofocus: widget.autoFocus ?? false,
                    decoration: InputDecoration(
                        hintText: widget.placeHolder ?? "Input your text",
                        border: InputBorder.none),
                  ),
                ),
                SizedBox(
                  width:
                      widget.rightWidgets != null ? widget.rightInputMargin : 0,
                ),
                ...?widget.rightWidgets,
                isKeyboardVisible && widget.hasSendButton
                    ? const SizedBox(width: 8)
                    : const SizedBox(),
                isKeyboardVisible && widget.hasSendButton
                    ? IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: () {
                          widget.onSend?.call();
                          if (widget.clearTextAfterSent) _controller.clear();
                        },
                      )
                    : const SizedBox(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
