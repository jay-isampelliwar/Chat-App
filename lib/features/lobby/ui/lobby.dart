import 'package:flutter/material.dart';
import 'package:socket_io_test/core/constant/app_color.dart';
import 'package:socket_io_test/core/constant/app_text_styles.dart';
import 'package:socket_io_test/core/constant/const_size_box.dart';

class Lobby extends StatelessWidget {
  Lobby({super.key});

  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              left: size.width * 0.1,
              right: size.width * 0.1,
            ),
            child: Column(
              children: [
                Form(
                  key: _key,
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                          border: textFieldBorder(size),
                          label: Text(
                            "Name",
                            style:
                                AppTextStyles.text18(bold: false, size: size),
                          ),
                        ),
                      ),
                      AppConstSizedBox.height(size.height * 0.03),
                      TextFormField(
                        decoration: InputDecoration(
                          border: textFieldBorder(size),
                          label: Text(
                            "Phone Number",
                            style:
                                AppTextStyles.text18(bold: false, size: size),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  OutlineInputBorder textFieldBorder(Size size) {
    return OutlineInputBorder(
        borderSide: BorderSide(
          color: AppColor.primary,
          width: 2,
          style: BorderStyle.solid,
        ),
        borderRadius: BorderRadius.circular(size.width * 0.01));
  }
}
