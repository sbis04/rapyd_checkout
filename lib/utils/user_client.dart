import 'package:appwrite/appwrite.dart';
import 'package:slibro/main.dart';

class UserClient {
  final Account account = Account(client);

  addItemToCart({required String storyId}) async {
    final prefs = await account.getPrefs();

    List<String>? cartItems = prefs.data['in_cart'] != null
        ? List<String>.from(prefs.data['in_cart'])
        : null;

    if (cartItems != null && !cartItems.contains(storyId)) {
      cartItems.add(storyId);
    } else {
      cartItems = [storyId];
    }

    Map<String, dynamic> retrievedPrefs = prefs.data;

    retrievedPrefs.putIfAbsent(
      'in_cart',
      () => cartItems,
    );

    await account.updatePrefs(
      prefs: retrievedPrefs,
    );
  }

  Future<List<String>?> getItemsInCart() async {
    final prefs = await account.getPrefs();
    List<String>? cartItems = prefs.data['in_cart'] != null
        ? List<String>.from(prefs.data['in_cart'])
        : null;

    return cartItems;
  }
}
