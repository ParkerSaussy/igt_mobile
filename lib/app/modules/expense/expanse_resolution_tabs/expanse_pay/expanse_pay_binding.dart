import 'package:get/get.dart';
import 'package:lesgo/app/modules/expense/expanse_resolution_tabs/expanse_pay/expanse_pay_controller.dart';

class ExpansePayBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ExpansePayController>(() => ExpansePayController(),
        fenix: true);
  }
}
