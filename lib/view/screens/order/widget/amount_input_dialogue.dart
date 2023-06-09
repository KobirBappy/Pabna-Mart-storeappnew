import 'package:appmartbdstore/controller/order_controller.dart';
import 'package:appmartbdstore/util/dimensions.dart';
import 'package:appmartbdstore/util/styles.dart';
import 'package:appmartbdstore/view/base/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:appmartbdstore/view/base/my_text_field.dart';

class AmountInputDialogue extends StatefulWidget {
  final int orderId;
  final bool isItemPrice;
  final double amount;
  AmountInputDialogue({@required this.orderId, @required this.isItemPrice, @required this.amount});

  @override
  State<AmountInputDialogue> createState() => _AmountInputDialogueState();
}

class _AmountInputDialogueState extends State<AmountInputDialogue> {
  final TextEditingController _amountController = TextEditingController();
  final FocusNode _amountNode = FocusNode();

  @override
  void initState() {
    super.initState();

    _amountController.text = widget.amount.toString();
  }
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL)),
      insetPadding: EdgeInsets.all(30),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: SizedBox(width: 500, child: Padding(
        padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
        child: Column(mainAxisSize: MainAxisSize.min, children: [

          Padding(
            padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE),
            child: Text(
              widget.isItemPrice ? 'update_order_amount'.tr : 'update_discount_amount'.tr, textAlign: TextAlign.center,
              style: robotoMedium.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE, color: Colors.red),
            ),
          ),
          SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_LARGE),

          MyTextField(
            hintText: widget.isItemPrice ? 'order_amount'.tr : 'discount_amount'.tr,
            controller: _amountController,
            focusNode: _amountNode,
            inputAction: TextInputAction.done,
            isAmount: true,
            amountIcon: true,
          ),
          SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

          GetBuilder<OrderController>(
            builder: (orderController) {
              return !orderController.isLoading ? CustomButton(
                buttonText: 'submit'.tr,
                onPressed: (){
                  orderController.updateOrderAmount(widget.orderId, _amountController.text.trim(), widget.isItemPrice);
                },
              ) : CircularProgressIndicator();
            }
          )

        ]),
      )),
    );
  }
}