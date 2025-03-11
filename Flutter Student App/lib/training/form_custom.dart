import 'package:flutter/material.dart';
import 'package:opencentric_lms/controller/auth_controller.dart';
import 'package:opencentric_lms/core/helper/route_helper.dart';
import 'package:opencentric_lms/training/form_validation.dart';
import 'package:get/get.dart';

import '../utils/dimensions.dart';

class FormCustom extends StatefulWidget {
  const FormCustom({super.key});

  @override
  State<FormCustom> createState() => _formCustom();
}

class _formCustom extends State<FormCustom> {
  final _formGlobalKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColorLight,
        appBar: AppBar(title: const Text('Registration user')),
        body: Form(
          key: _formGlobalKey,
          child: GetBuilder<AuthController>(
              builder: (controller) {
                return Container(
                  height: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 25),
                  child: SingleChildScrollView(
                    child: IntrinsicHeight(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        spacing: 25,
                        children: [
                          Flexible(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'lms',
                                style: TextStyle(
                                  fontSize: 60,
                                  fontFamily: 'AtkinsonHyperlegibleMono',
                                ),
                              ),
                              controller.avatarController == null
                              ? IconButton(
                                padding: const EdgeInsets.all(
                                    Dimensions.paddingSizeDefault),
                                onPressed: () {
                                  controller.choosePicture();
                                },
                                icon: const Icon(Icons.person),
                                style: IconButton.styleFrom(
                                  iconSize: Dimensions.paddingSizeLarge,
                                  // backgroundColor: TrainingTheme.avatarBgFirst,
                                ),
                              )
                              : SizedBox(
                                height: 60,
                                child: GestureDetector(
                                  onTap: (){
                                    controller.choosePicture();
                                  },
                                  child: ClipOval(
                                    child:  Image.file(
                                      controller.avatarController!,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )),
                          // field full name
                          const Text(
                            'Registration',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text('Your details',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold)),
                          customTextField(
                              label: 'First name',
                              content: controller.usernameController,
                              validate: Validator.apply(context, [
                                const RequiredValidation(),
                              ])),
                          customTextField(
                              label: 'Surname',
                              content: controller.lastNameController,
                              validate: Validator.apply(context, [
                                const RequiredValidation(),
                              ])),
                          customTextField(
                              label: 'Email',
                              content: controller.emailController,
                              validate: Validator.apply(context, [
                                const RequiredValidation(),
                              ])),
                          customTextField(
                              label: 'Phone',
                              content: controller.phoneController,
                              validate: Validator.apply(context, [
                                const RequiredValidation(),
                              ])),
                          const Text('Password',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold)),
                          customTextField(
                              label: 'Choose password',
                              content: controller.passwordController,
                              validate: Validator.apply(context, [
                                const RequiredValidation(),
                              ])),
                          customTextField(
                              label: 'Confirm password',
                              content: controller.confirmPasswordController,
                              validate: Validator.apply(context, [
                                const RequiredValidation(),
                              ])),
                          const Text('Your password is strong'),
                          Flexible(
                              child: Row(
                            spacing: 10,
                            children: [
                              Flexible(
                                  child: strengthPassword(
                                      strengthColor: const Color(0xffD4A3A3),
                                      value: (controller.passwordController.text.length >= 6) ? 1 : 0
                                  )

                              ),
                              Flexible(
                                  child: strengthPassword(
                                      strengthColor: const Color(0xffD4C5A3),
                                      value: (
                                          controller.getPass!.length >= 6 && RegExp(r'^[a-zA-Z0-9]+$').hasMatch(controller.getPass!)
                                      ) ? 1 : 0
                                  )
                              ),
                              Flexible(
                                  child: strengthPassword(
                                      strengthColor: const Color(0xffA3D4B9),
                                     value: (
                                         controller.getPass!.length >= 6 && RegExp(r'^[a-zA-Z0-9!@#$%^&*]+$').hasMatch(controller.getPass!)
                                     ) ? 1 : 0
                                  )
                              ),
                            ],
                          )),
                          SizedBox(
                            width: double.infinity,
                            child: FilledButton(
                              style: FilledButton.styleFrom(
                                  padding: const EdgeInsets.all(
                                      Dimensions.paddingSizeDefault),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.radiusDefault),
                                  ),),
                              onPressed: () {
                                controller.registration();
                                Get.offNamed(
                                    RouteHelper.getSignInRoute(RouteHelper.signUp));
                                },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Register',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: Dimensions.fontSizeSmall,
                                      )),
                                  const Icon(
                                      Icons.arrow_forward_ios_outlined,
                                    color: Colors.black,
                                  ),
                                ],
                              ),
                              // child: const Text('Register', style: TextStyle(
                              //     color: Colors.black,
                              //
                              // ),
                              // )
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          // lay field save gui api len web
                          // form user name, email,  password, confirm password,
                          // get put data api
                        ],
                      ),
                    ),
                  ),
                );
              }),
        ),
      ),
    );
  }

  Widget strengthPassword(
      {required Color strengthColor, required, required double value}) {
    return LinearProgressIndicator(
      value: value,
      minHeight: Dimensions.paddingSizeSmall,
      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
      backgroundColor: Colors.white,
      color: strengthColor,
    );
  }

  Widget customTextField(
      {required String label,
      required dynamic content,
      required dynamic validate}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(
          height: 10,
        ),
        TextFormField(
          controller: content,
          decoration: const InputDecoration(
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(Dimensions.radiusDefault),
              ),
              borderSide: BorderSide.none,
            ),
            filled: true,
          ),
          onChanged: (value) {

          },
          validator: validate,
        ),
      ],
    );
  }
}
