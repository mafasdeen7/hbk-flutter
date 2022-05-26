import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyInputWidget extends StatefulWidget {
  final String labelText;
  final String hintText;
  final bool isRequired;
  final bool isTextArea;
  final bool isPassword;
  final bool isNumber;
  final bool isNumberOnly;
  final bool isEmail;
  final bool isReadOnly;
  final String dataKey;
  final String suffix;
  final Map<String, String> formData;
  final int displayOrder;
  final TextEditingController controller;
  final Function additionalValidation;
  final int textAreaLine;

  MyInputWidget(
      {this.labelText,
      this.hintText,
      this.isRequired = false,
      this.isTextArea = false,
      this.isNumber = false,
      this.isNumberOnly = false,
      this.isPassword = false,
      this.isEmail = false,
      this.isReadOnly = false,
      this.dataKey,
      this.formData,
      this.suffix,
      this.displayOrder = 0,
      this.controller,
      this.additionalValidation,
      this.textAreaLine = 8});

  @override
  _MyInputWidgetState createState() => _MyInputWidgetState();
}

class _MyInputWidgetState extends State<MyInputWidget>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  TextInputType getInputType() {
    if (this.widget.isNumber)
      return TextInputType.numberWithOptions(decimal:true);
    else if (this.widget.isNumberOnly)
      return TextInputType.number;
    else if (this.widget.isTextArea)
      return TextInputType.multiline;
    else if (this.widget.isEmail)
      return TextInputType.emailAddress;
    else
      return TextInputType.text;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Row(
      children: <Widget>[
        Flexible(
          child: TextFormField(
            maxLines: this.widget.isTextArea ? this.widget.textAreaLine : 1,
            controller: this.widget.controller,
            obscureText: this.widget.isPassword,
            keyboardType: getInputType(),
            inputFormatters: this.widget.isNumberOnly? [WhitelistingTextInputFormatter.digitsOnly]: this.widget.isNumber ? [FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,2}'))]:null,
            // inputFormatters: this.widget.isNumber? [FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,2}'))]:null,
            readOnly: this.widget.isReadOnly,
            decoration: InputDecoration(
              labelText: this.widget.labelText,
              hintText: this.widget.hintText,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              suffixText: this.widget.suffix,
            ),
            validator: (v) {
              if (this.widget.isRequired && v.isEmpty) {
                return 'This field is required';
              }
              if (this.widget.additionalValidation != null)
                return this.widget.additionalValidation();
              if (this.widget.isEmail) {
                bool emailValid = RegExp(
                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                    .hasMatch(v);
                if (emailValid) return null;
                return 'Please, Enter a valid Email Address.';
              }
              return null;
            },
            onSaved: (v) {
              if (widget.formData != null) {
                widget.formData[widget.dataKey] = v;
              }
            },
          ),
        ),
      ],
    );
  }
}
