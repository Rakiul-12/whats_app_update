import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whats_app/binding/binding.dart';
import 'package:whats_app/feature/authentication/Model/UserModel.dart';
import 'package:whats_app/feature/authentication/backend/MessageRepo/MessageRepository.dart';

class ChatController extends GetxController {
  ChatController(this.otherUser);

  final UserModel otherUser;

  final textController = TextEditingController();

  final RxString message = ''.obs;
  final isSending = false.obs;

  @override
  void onInit() {
    super.onInit();
    textController.addListener(() {
      message.value = textController.text;
      print("MESSAGE VALUE => '${message.value}'");
    });
  }

  Future<void> sendMessage() async {
    if (message.value.trim().isEmpty) return;

    isSending.value = true;
    try {
      await Messagerepository.sendMessage(
        otherUser,
        message.value,
        MessageType.text,
      );
      textController.clear();
    } finally {
      isSending.value = false;
    }
  }

  @override
  void onClose() {
    textController.dispose();
    super.onClose();
  }
}
