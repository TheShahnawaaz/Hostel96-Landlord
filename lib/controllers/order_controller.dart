import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:hostel96_landlord/controllers/landlord_controller.dart';
import 'package:hostel96_landlord/controllers/user_controller.dart';
import 'package:hostel96_landlord/models/order_model.dart';
import 'package:hostel96_landlord/repositories/order_repository.dart';
import 'package:hostel96_landlord/utils/connectivity/connectivity.dart';
import 'package:hostel96_landlord/widgets/navigation_menu.dart';
import 'package:hostel96_landlord/widgets/widgets.dart';
import "package:hostel96_landlord/widgets/full_screen_loader.dart";

class OrderController extends GetxController {
  static OrderController get instance => Get.find();

  RxList<OrderModel> studentOrders = <OrderModel>[].obs;
  RxList<OrderModel> landlordOrders = <OrderModel>[].obs;
  RxBool isOrderLoading = false.obs;
  final orderRepository = Get.put(OrderRepository());

  @override
  void onInit() {
    fetchOrdersByLandlord(LandlordController.instance.landlord.value.id);
    super.onInit();
    // fetchOrdersByLandlord("landlordId");
  }

  Future<void> createOrder(OrderModel order) async {
    try {
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        // TFullScreenLoader.closeLoadingDialog();
        TLoaders.warningSnackbar(
            title: "No internet connection!",
            message: "Please check your internet connection and try again.");
        return;
      }

      TFullScreenLoader.openLoadingDialog(
        "Your payment have been recieved!\nWe are booking your hostel!",
        "Please wait...",
      );

      await orderRepository.createOrder(order);

      TFullScreenLoader.closeLoadingDialog();
      // Remove every screen from the stack and navigate to the home screen
      Get.back();
      Get.back();
      Get.back();
      NavigationContainer.instance.selectedIndex.value = 2;

      TLoaders.successSnackbar(
          title: "Hostel booked successfully!",
          message: "Your hostel has been booked successfully.");
    } catch (e) {
      print(e);
      print("Error: $e");
      TLoaders.errorSnackbar(title: "Oops!", message: e.toString());
      TFullScreenLoader.closeLoadingDialog();
    }
  }

  Future<OrderModel> fetchOrderDetails(String orderId) async {
    try {
      isOrderLoading(true);
      OrderModel order = await orderRepository.fetchOrderDetails(orderId);
      return order;
    } catch (e) {
      print(e);
      return OrderModel.empty();
    } finally {
      isOrderLoading(false);
    }
  }

  Future<void> updateOrderDetails(OrderModel order) async {
    try {
      isOrderLoading(true);
      await orderRepository.updateOrderDetails(order);
    } catch (e) {
      print(e);
    } finally {
      isOrderLoading(false);
    }
  }

  Future<void> fetchOrdersByStudent(String studentId) async {
    try {
      isOrderLoading(true);
      List<OrderModel> orders =
          await orderRepository.fetchOrdersByStudent(studentId);
      studentOrders.assignAll(orders);
    } catch (e) {
      print(e);
    } finally {
      isOrderLoading(false);
    }
  }

  Future<void> fetchOrdersByLandlord(String landlordId) async {
    try {
      isOrderLoading(true);
      List<OrderModel> orders =
          await orderRepository.fetchOrdersByLandlord(landlordId);
      landlordOrders.assignAll(orders);
    } catch (e) {
      print(e);
    } finally {
      isOrderLoading(false);
    }
  }
}
