import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whats_app/binding/binding.dart';
import 'package:whats_app/feature/authentication/Model/UserModel.dart';
import 'package:whats_app/feature/authentication/backend/MessageRepo/MessageRepository.dart';

class ChatController extends GetxController {
  ChatController(this.otherUser);

  final UserModel otherUser;

  final TextEditingController textController = TextEditingController();

  final isSending = false.obs;

  Future<void> sendMessage() async {
    final text = textController.text.trim();
    if (text.isEmpty) return;

    isSending.value = true;
    try {
      await Messagerepository.sendMessage(otherUser, text, MessageType.text);

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
