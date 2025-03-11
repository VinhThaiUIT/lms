import 'package:flutter/material.dart';

import '../../../data/model/quiz/questions.dart';
import '../../../utils/dimensions.dart';
import '../../../utils/styles.dart';

class LabeledRadioButton extends StatefulWidget {
  const LabeledRadioButton(
      {super.key,
      required this.question,
      this.selectedIndex,
      this.isClickable = true,
      this.resultIndex,
      this.indexRight,
      required this.isCorrectAnsSelected});
  final Questions question;
  final ValueChanged<bool> isCorrectAnsSelected;
  final ValueChanged<int?>? selectedIndex;
  final bool? isClickable;
  final int? resultIndex;
  final int? indexRight;

  @override
  State<LabeledRadioButton> createState() => _LabeledRadioButtonState();
}

class _LabeledRadioButtonState extends State<LabeledRadioButton> {
  int groupValue = -1;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
              color: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .color!
                  .withOpacity(0.06)),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                widget.question.question,
                style: robotoRegular.copyWith(
                  color: Theme.of(context).textTheme.bodyLarge!.color,
                  fontSize: Dimensions.fontSizeDefault,
                ),
              ),
              const SizedBox(height: 10),
              Column(
                children: questionList(),
              )
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> questionList() =>
      List.generate(widget.question.option?.length ?? 0, (index) {
        if (widget.indexRight != null && widget.indexRight == index) {
          return optionRightItem(
              widget.question.option?.elementAt(index).answer ?? "");
        }
        return optionItem(
            widget.question.option?.elementAt(index).answer ?? "", index);
      });

  Widget optionItem(String option, int value) {
    bool checkError = false;
    if (widget.resultIndex != null &&
        widget.indexRight != null &&
        widget.resultIndex != widget.indexRight) {
      checkError = true;
    }
    return InkWell(
      onTap: () => widget.isClickable! ? _handleRadioValueChange(value) : null,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 30,
            width: 30,
            child: Radio(
              materialTapTargetSize: MaterialTapTargetSize.padded,
              fillColor: WidgetStateProperty.resolveWith<Color>((states) {
                if (checkError && value == widget.resultIndex) {
                  return Colors.red;
                }
                if (states.contains(WidgetState.selected)) {
                  return Theme.of(context).primaryColor;
                }
                return Theme.of(context).textTheme.bodyMedium!.color!;
              }),
              value: value,
              groupValue: widget.resultIndex ?? groupValue,
              onChanged: widget.isClickable! ? _handleRadioValueChange : null,
            ),
          ),
          Expanded(
              child: Text(option,
                  style: robotoRegular.copyWith(
                    color: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .color!
                        .withOpacity(0.6),
                    fontSize: Dimensions.fontSizeSmall,
                  ))),
        ],
      ),
    );
  }

  Widget optionRightItem(String option) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 30,
          width: 30,
          child: Radio(
            materialTapTargetSize: MaterialTapTargetSize.padded,
            fillColor: WidgetStateProperty.resolveWith<Color>((states) {
              if (states.contains(WidgetState.selected)) {
                return Theme.of(context).primaryColor;
              }
              return Theme.of(context).textTheme.bodyMedium!.color!;
            }),
            value: 0,
            groupValue: 0,
            onChanged: widget.isClickable! ? _handleRadioValueChange : null,
          ),
        ),
        Expanded(
            child: Text(option,
                style: robotoRegular.copyWith(
                  color: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .color!
                      .withOpacity(0.6),
                  fontSize: Dimensions.fontSizeSmall,
                ))),
      ],
    );
  }

  void _handleRadioValueChange(int? value) {
    setState(() {
      groupValue = value!;
      //check ans is correct or not
      int correctAnsIndex = widget.question.correctAnswerIndex?[0] ?? -1;
      int givenAnsIndex = value;
      if (correctAnsIndex == givenAnsIndex) {
        widget.isCorrectAnsSelected(true);
      } else {
        widget.isCorrectAnsSelected(false);
      }
      if (widget.selectedIndex != null) {
        widget.selectedIndex!(value);
      }
    });
  }
}
