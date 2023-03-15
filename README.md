### Mention Input

---

***Summary:** Flutter mention input widget that has several custom properties. Inspired by flutter_mentions of [fayeed](https://pub.dev/packages/flutter_mentions).*

## How to install

---

### 1. `pubspec.yaml`

```
  dependencies: 
    mention_input: ^0.0.1
```

### 2. Flutter CLI

```
  flutter pub add mention_input
```

## Properties

---

### Common Properties

| Property | Description | Data Type | Default Value | Required? |
| ----------- | ----------- | ----------- | ----------- | ----------- |
| mentions | List mention which each mention has its annotation and mention data | List\<Mention> | | * |
| controller | Methods for controlling mention_input | MentionInputController | | * |

### Suggestion Container Properties

| Property | Description | Data Type | Default Value | Required? |
| ----------- | ----------- | ----------- | ----------- | ----------- |
| suggestionContainerColor | Color of Suggestion Container | Color | Colors.amber | |
| suggestionContainerPadding | Padding of Suggestion Container | EdgeInsetsGeometry | EdgeInsets.all(16) | |
| suggestionContainerMargin | Margin of Suggestion Container | EdgeInsetsGeometry | EdgeInsets.symmetric(vertical: 16) | |
| suggestionContainerDecoration | Decoration of Suggestion Container | Decoration | |
| suggestionAlignment | Alignment of Suggestion Container relative to Input | SuggestionAlignment | SuggestionAlignment.top | |
| suggestionContainerBorderRadius | Border radius of Suggestion Container | double | 12.0 | |

### Suggestion Item Properties

| Property | Description | Data Type | Default Value | Required? |
| ----------- | ----------- | ----------- | ----------- | ----------- |
| itemHeight | Height of Suggestion Item | double | 40.0 | |
| dividerBetweenItem | Should have divider between items | bool | true | |

### Text Field Properties

| Property | Description | Data Type | Default Value | Required? |
| ----------- | ----------- | ----------- | ----------- | ----------- |
| placeHolder | Place holder of Text Field | String | | |
| autoFocus | Auto focus of Text Field | bool | true | |
| clearTextAfterSent | Should clear text after sent | bool | true | |
| leftInputMargin | Left margin of Text Field | double | 8.0 | |
| rightInputMargin | Right margin of Text Field | double | 8.0 | |
| leftWidgets | Left widgets relative to Text Field | List\<Widget> | | |
| rightWidgets | Right widgets relative to Text Field | List\<Widget> | | |

### Send Button Properties

| Property | Description | Data Type | Default Value | Required? |
| ----------- | ----------- | ----------- | ----------- | ----------- |
| onSend | onSend method | Function | | |
| hasSendButton | Should have send button | bool | true | |

## References

`flutter_mentions`: [fayeed](https://pub.dev/packages/flutter_mentions)