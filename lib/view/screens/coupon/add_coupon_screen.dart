import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:appmartbdstore/controller/auth_controller.dart';
import 'package:appmartbdstore/controller/coupon_controller.dart';
import 'package:appmartbdstore/data/model/response/coupon_body.dart';
import 'package:appmartbdstore/helper/date_converter.dart';
import 'package:appmartbdstore/util/dimensions.dart';
import 'package:appmartbdstore/util/styles.dart';
import 'package:appmartbdstore/view/base/custom_app_bar.dart';
import 'package:appmartbdstore/view/base/custom_button.dart';
import 'package:appmartbdstore/view/base/custom_snackbar.dart';
import 'package:appmartbdstore/view/base/my_text_field.dart';
class AddCouponScreen extends StatefulWidget {
  final CouponBody coupon;
  const AddCouponScreen({Key key, this.coupon}) : super(key: key);

  @override
  State<AddCouponScreen> createState() => _AddCouponScreenState();
}

class _AddCouponScreenState extends State<AddCouponScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _limitController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _expireDateController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();
  final TextEditingController _maxDiscountController = TextEditingController();
  final TextEditingController _minPurchaseController = TextEditingController();

  final FocusNode _codeNode = FocusNode();
  final FocusNode _limitNode = FocusNode();
  final FocusNode _minNode = FocusNode();
  final FocusNode _discountNode = FocusNode();
  final FocusNode _maxDiscountNode = FocusNode();

  @override
  void initState() {
    super.initState();
    if(widget.coupon != null){
      _titleController.text = widget.coupon.title;
      _codeController.text = widget.coupon.code;
      _limitController.text = widget.coupon.limit.toString();
      _startDateController.text = widget.coupon.startDate.toString();
      _expireDateController.text = widget.coupon.expireDate.toString();
      _discountController.text = widget.coupon.discount.toString();
      _maxDiscountController.text = widget.coupon.maxDiscount.toString();
      _minPurchaseController.text = widget.coupon.minPurchase.toString();
      print('=====couponType=====${widget.coupon.couponType == 'default'}');
      print('=====discountType=====${widget.coupon.discountType == 'percent'}');
      Get.find<CouponController>().setCouponTypeIndex(widget.coupon.couponType == 'default' ? 0 : 1 , false);
      Get.find<CouponController>().setDiscountTypeIndex(widget.coupon.discountType == 'percent' ? 0 : 1, false);
    }
  }
  @override
  Widget build(BuildContext context) {
    bool _selfDelivery;
    if(Get.find<AuthController>().profileModel != null && Get.find<AuthController>().profileModel.stores != null){
      _selfDelivery = Get.find<AuthController>().profileModel.stores[0].selfDeliverySystem == 1;
    }
    if(!_selfDelivery){
      Get.find<CouponController>().setCouponTypeIndex(0, false);
    }
    return Scaffold(
      appBar: CustomAppBar(title: widget.coupon != null ? 'update_coupon'.tr : 'add_coupon'.tr),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL, vertical: Dimensions.PADDING_SIZE_SMALL),
        child: GetBuilder<CouponController>(
          builder: (couponController) {
            return Column(children: [

              MyTextField(
                hintText: 'title'.tr,
                controller: _titleController,
                nextFocus: _codeNode,
              ),
              SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

              Row(children: [
                _selfDelivery ? Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(
                      'coupon_type'.tr,
                      style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: Theme.of(context).disabledColor),
                    ),
                    SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

                    Container(
                      padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                        boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 800 : 200], spreadRadius: 2, blurRadius: 5, offset: Offset(0, 5))],
                      ),
                      child: DropdownButton<String>(
                        value: couponController.couponTypeIndex == 0 ? 'default' : 'free_delivery',
                        items: <String>['default', 'free_delivery'].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value.tr),
                          );
                        }).toList(),
                        onChanged: (value) {
                          couponController.setCouponTypeIndex(value == 'default' ? 0 : 1, true);
                        },
                        isExpanded: true,
                        underline: SizedBox(),
                      ),
                    ),
                  ]),
                )  : SizedBox(),
                SizedBox(width: _selfDelivery ? Dimensions.PADDING_SIZE_SMALL : 0),

                Expanded(child: MyTextField(
                  hintText: 'code'.tr,
                  controller: _codeController,
                  focusNode: _codeNode,
                  nextFocus: _limitNode,
                )),
              ]),
              SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

              Row(children: [
                Expanded(child: MyTextField(
                  hintText: 'limit_for_same_user'.tr,
                  controller: _limitController,
                  focusNode: _limitNode,
                  nextFocus: _minNode,
                  isAmount: true,
                )),
                SizedBox(width: Dimensions.PADDING_SIZE_SMALL),

                Expanded(child: MyTextField(
                  hintText: 'min_purchase'.tr,
                  controller: _minPurchaseController,
                  isAmount: true,
                  focusNode: _minNode,
                  nextFocus: _discountNode,
                )),
              ]),
              SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

              Row(children: [
                Expanded(child: MyTextField(
                  controller: _startDateController,
                  hintText: 'start_date'.tr,
                  readOnly: true,
                  onTap: () async{
                    DateTime pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                    );
                    if (pickedDate != null) {
                      String formattedDate = DateConverter.dateTimeForCoupon(pickedDate);
                      setState(() {
                        _startDateController.text = formattedDate;
                      });
                    }
                  },
                )),
                SizedBox(width: Dimensions.PADDING_SIZE_SMALL),

                Expanded(child: MyTextField(
                  controller: _expireDateController,
                  hintText: 'expire_date'.tr,
                  readOnly: true,
                  onTap: () async{
                    DateTime pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                    );
                    if (pickedDate != null) {
                      String formattedDate = DateConverter.dateTimeForCoupon(pickedDate);
                      setState(() {
                        _expireDateController.text = formattedDate;
                      });
                    }
                  },
                )),
              ]),
              SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

              couponController.couponTypeIndex == 0 ? Row(children: [
                Expanded(child: MyTextField(
                  hintText: 'discount'.tr,
                  controller: _discountController,
                  isAmount: true,
                  focusNode: _discountNode,
                  nextFocus: _maxDiscountNode,
                )),
                SizedBox(width: Dimensions.PADDING_SIZE_SMALL),

                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(
                    'discount_type'.tr,
                    style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: Theme.of(context).disabledColor),
                  ),
                  SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                      boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 800 : 200], spreadRadius: 2, blurRadius: 5, offset: Offset(0, 5))],
                    ),
                    child: DropdownButton<String>(
                      value: couponController.discountTypeIndex == 0 ? 'percent' : 'amount',
                      items: <String>['percent', 'amount'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value.tr),
                        );
                      }).toList(),
                      onChanged: (value) {
                        couponController.setDiscountTypeIndex(value == 'percent' ? 0 : 1, true);
                      },
                      isExpanded: true,
                      underline: SizedBox(),
                    ),
                  ),
                ])),
              ]) : SizedBox(),
              SizedBox(height: couponController.couponTypeIndex == 0 ? Dimensions.PADDING_SIZE_LARGE : 0),

              couponController.couponTypeIndex == 0 && couponController.discountTypeIndex == 0 ?MyTextField(
                hintText: 'max_discount'.tr,
                controller: _maxDiscountController,
                isAmount: true,
                focusNode: _maxDiscountNode,
                inputAction: TextInputAction.done,
              ) : SizedBox(),
              SizedBox(height: 50),

              !couponController.isLoading ? CustomButton(
                buttonText: widget.coupon == null ? 'add'.tr : 'update'.tr,
                onPressed: (){
                  String title = _titleController.text.trim();
                  String code = _codeController.text.trim();
                  String startDate = _startDateController.text.trim();
                  String expireDate = _expireDateController.text.trim();
                  String discount = _discountController.text.trim();
                  if(title.isEmpty){
                    showCustomSnackBar('please_fill_up_your_coupon_title'.tr);
                  }else if(code.isEmpty){
                    showCustomSnackBar('please_fill_up_your_coupon_code'.tr);
                  }else if(startDate.isEmpty){
                    showCustomSnackBar('please_select_your_coupon_start_date'.tr);
                  }else if(expireDate.isEmpty){
                    showCustomSnackBar('please_select_your_coupon_expire_date'.tr);
                  }else if(couponController.couponTypeIndex == 0 && discount.isEmpty){
                    showCustomSnackBar('please_fill_up_your_coupon_discount'.tr);
                  }else if(couponController.couponTypeIndex == 0 && (int.parse(_limitController.text.trim()) > 100)){
                    showCustomSnackBar('limit_for_same_user_cant_be_more_then_100'.tr);
                  }else {
                    if(widget.coupon == null){
                      couponController.addCoupon(title: title, code: code, startDate: startDate, expireDate: expireDate,
                        couponType: couponController.couponTypeIndex == 0 ? 'default' : 'free_delivery', discount: /*couponController.discountTypeIndex == 1 ? null :*/ discount,
                        discountType: couponController.discountTypeIndex == 0 ? 'percent' : 'amount', limit: _limitController.text.trim(),
                        maxDiscount: _maxDiscountController.text.trim(), minPurches: _minPurchaseController.text.trim(),
                      );
                    }else{
                      couponController.updateCoupon(couponId: widget.coupon.id.toString(), title: title, code: code, startDate: startDate, expireDate: expireDate,
                        couponType: couponController.couponTypeIndex == 0 ? 'default' : 'free_delivery', discount: /*couponController.discountTypeIndex == 1 ? null :*/ discount,
                        discountType: couponController.discountTypeIndex == 0 ? 'percent' : 'amount', limit: _limitController.text.trim(),
                        maxDiscount: _maxDiscountController.text.trim(), minPurches: _minPurchaseController.text.trim(),
                      );
                    }
                  }
                },
              ) : Center(child: CircularProgressIndicator()),

            ]);
          }
        ),
      ),
    );
  }
}
