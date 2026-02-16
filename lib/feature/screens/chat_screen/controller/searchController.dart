import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whats_app/feature/authentication/Model/UserModel.dart';
import 'package:whats_app/utiles/const/keys.dart';

class ChatSearchController extends GetxController {
  final searchController = TextEditingController();

  final isLoading = false.obs;
  final results = <UserModel>[].obs;
  final error = RxnString();
  final isTyping = false.obs;

  // Timer? _debounce;

  // void onQueryChanged(String query) {
  //   _debounce?.cancel();
  //   _debounce = Timer( Duration(milliseconds: 350), () {
  //     search(query);
  //   });
  // }

  @override
  void onInit() {
    super.onInit();
    searchController.addListener(() {
      isTyping.value = searchController.text.isNotEmpty;
    });
  }

  void clearSearch() {
    searchController.clear();
    results.clear();
    error.value = null;
    isTyping.value = false;
  }

  Future<void> search(String userName) async {
    final reasult = userName.trim();

    if (reasult.isEmpty) {
      results.clear();
      error.value = null;
      return;
    }

    isLoading.value = true;
    error.value = null;

    try {
      final snap = await FirebaseFirestore.instance
          .collection(MyKeys.userCollection)
          .orderBy('username')
          .startAt([reasult])
          .endAt(['$reasult\uf8ff'])
          .limit(20)
          .get();

      results.value = snap.docs
          .map((data) => UserModel.fromSnapshot(data))
          .toList();
    } catch (e) {
      error.value = "Search error: $e";
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    // _debounce?.cancel();
    searchController.dispose();
    super.onClose();
  }
}
