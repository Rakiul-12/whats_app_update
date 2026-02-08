import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:whats_app/utiles/const/keys.dart';
import 'package:whats_app/feature/authentication/Model/UserModel.dart';

class FindUserController extends GetxController {
  final RxBool loading = false.obs;
  final RxString status = "Loading...".obs;

  /// All contacts from phone
  final RxList<Contact> contacts = <Contact>[].obs;

  /// Users who are registered in app (Firestore users)
  final RxList<UserModel> registeredUsers = <UserModel>[].obs;

  /// Phones of registered users (normalized)
  final RxSet<String> registeredPhones = <String>{}.obs;

  @override
  void onInit() {
    super.onInit();
    loadAllAndFilter();
  }

  Future<void> loadAllAndFilter() async {
    loading.value = true;
    status.value = "Requesting contacts permission...";
    contacts.clear();
    registeredUsers.clear();
    registeredPhones.clear();

    final perm = await Permission.contacts.request();
    if (!perm.isGranted) {
      loading.value = false;
      status.value = "Contacts permission denied.";
      return;
    }

    status.value = "Reading contacts...";
    final list = await FlutterContacts.getContacts(withProperties: true);
    list.sort((a, b) => a.displayName.compareTo(b.displayName));
    contacts.assignAll(list);

    // Collect all normalized numbers from contacts
    final Set<String> phones = {};
    for (final c in list) {
      for (final p in c.phones) {
        final n = normalizeBDPhone(p.number);
        if (n.isNotEmpty) phones.add(n);
      }
    }

    if (phones.isEmpty) {
      loading.value = false;
      status.value = "No phone numbers found in contacts";
      return;
    }

    status.value = "Finding users who use this app...";

    // Firestore whereIn limit handling
    const chunkSize = 10;
    final phoneList = phones.toList();

    final Map<String, UserModel> byPhone = {}; // phone -> user

    for (int i = 0; i < phoneList.length; i += chunkSize) {
      final chunk = phoneList.sublist(
        i,
        (i + chunkSize > phoneList.length) ? phoneList.length : i + chunkSize,
      );

      // ✅ Your DB currently uses phoneNumber
      final snap1 = await FirebaseFirestore.instance
          .collection(MyKeys.userCollection)
          .where("phoneNumber", whereIn: chunk)
          .get();

      for (final doc in snap1.docs) {
        final data = Map<String, dynamic>.from(doc.data());
        data["uid"] = doc.id;

        final p = normalizeBDPhone((data["phoneNumber"] ?? "").toString());
        if (p.isEmpty) continue;

        byPhone[p] = _userFromFirestore(data, doc.id);
      }

      // ✅ Optional: if you also have `phone` in some docs
      final snap2 = await FirebaseFirestore.instance
          .collection(MyKeys.userCollection)
          .where("phone", whereIn: chunk)
          .get();

      for (final doc in snap2.docs) {
        final data = Map<String, dynamic>.from(doc.data());
        data["uid"] = doc.id;

        final p = normalizeBDPhone((data["phone"] ?? "").toString());
        if (p.isEmpty) continue;

        byPhone[p] = _userFromFirestore(data, doc.id);
      }
    }

    registeredUsers.assignAll(byPhone.values.toList());
    registeredPhones.addAll(byPhone.keys);

    loading.value = false;
    status.value = registeredUsers.isEmpty
        ? "No contacts are using this app"
        : "Found ${registeredUsers.length} users using this app";
  }

  /// For UI: first phone of contact
  String firstPhone(Contact c) {
    if (c.phones.isEmpty) return "";
    return c.phones.first.number;
  }

  /// For UI: check if this contact is registered
  bool isRegisteredContact(Contact c) {
    for (final p in c.phones) {
      final n = normalizeBDPhone(p.number);
      if (registeredPhones.contains(n)) return true;
    }
    return false;
  }

  /// Get matched registered user for a contact (for opening chat)
  UserModel? matchedUser(Contact c) {
    for (final p in c.phones) {
      final n = normalizeBDPhone(p.number);
      if (registeredPhones.contains(n)) {
        // Find user by matching phoneNumber (fast)
        return registeredUsers.firstWhereOrNull(
          (u) => normalizeBDPhone(u.phoneNumber) == n,
        );
      }
    }
    return null;
  }

  /// 🇧🇩 Normalize to +88017XXXXXXXX
  String normalizeBDPhone(String input) {
    if (input.isEmpty) return '';
    final digits = input.replaceAll(RegExp(r'[^0-9]'), '');

    if (digits.length == 13 && digits.startsWith('880')) return '+$digits';
    if (digits.length == 11 && digits.startsWith('01')) {
      return '+880${digits.substring(1)}';
    }
    if (digits.length == 10 && digits.startsWith('17')) return '+880$digits';

    if (input.startsWith('+') && digits.length >= 11) return '+$digits';
    return '';
  }

  /// Build your existing UserModel from Firestore map
  UserModel _userFromFirestore(Map<String, dynamic> data, String docId) {
    // Your current UserModel uses: id, username, email, phoneNumber, ...
    return UserModel(
      id: (data["id"] ?? docId).toString(),
      username: (data["username"] ?? "").toString(),
      email: (data["email"] ?? "").toString(),
      phoneNumber: (data["phoneNumber"] ?? data["phone"] ?? "").toString(),
      profilePicture: (data["profilePicture"] ?? "").toString(),
      about: (data["about"] ?? "").toString(),
      createdAt: (data["createdAt"] ?? "").toString(),
      isOnline: (data["isOnline"] ?? false) == true,
      pushToken: (data["pushToken"] ?? "").toString(),
      lastActive: (data["lastActive"] ?? "").toString(),
      publicId: (data["publicId"] ?? "").toString(),
    );
  }
}
