import 'package:flutter/material.dart';

Widget defaultFormField({
  required TextEditingController? controller,
  required Function? validat,
  Function? suffixPressed,
  bool? isPassword = false,
  required TextInputType? keyboardType,
  required String? lable,
  IconData? prefix,
  IconData? suffix,
}) =>
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: TextFormField(
        controller: controller!,
        validator: (v) {
          return validat!(v);
        },
        keyboardType: keyboardType!,
        decoration: InputDecoration(
          label: Text(lable!),
          border: OutlineInputBorder(),
          prefixIcon: prefix!=null ? Icon(prefix) : null,
          suffixIcon: suffix != null
              ? IconButton(
                  onPressed: () {
                    return suffixPressed!();
                  },
                  icon: Icon(suffix))
              : null,
        ),
        obscureText: isPassword!,
      ),
    );
