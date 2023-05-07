import 'package:appmartbdstore/controller/campaign_controller.dart';
import 'package:appmartbdstore/controller/splash_controller.dart';
import 'package:appmartbdstore/data/model/response/campaign_model.dart';
import 'package:appmartbdstore/helper/date_converter.dart';
import 'package:appmartbdstore/helper/route_helper.dart';
import 'package:appmartbdstore/util/dimensions.dart';
import 'package:appmartbdstore/util/images.dart';
import 'package:appmartbdstore/util/styles.dart';
import 'package:appmartbdstore/view/base/confirmation_dialog.dart';
import 'package:appmartbdstore/view/base/custom_image.dart';
import 'package:appmartbdstore/view/screens/campaign/campaign_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CampaignWidget extends StatelessWidget {
  final CampaignModel campaignModel;
  CampaignWidget({@required this.campaignModel});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.toNamed(
        RouteHelper.getCampaignDetailsRoute(campaignModel.id),
        arguments: CampaignDetailsScreen(campaignModel: campaignModel),
      ),
      child: Container(
        margin: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL),
        padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
          boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 700 : 300], spreadRadius: 1, blurRadius: 5)],
        ),
        child: Row(children: [

          ClipRRect(
            borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
            child: CustomImage(
              image: '${Get.find<SplashController>().configModel.baseUrls.campaignImageUrl}/${campaignModel.image}',
              height: 85, width: 100, fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: Dimensions.PADDING_SIZE_SMALL),

          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [

            Text(campaignModel.title, style: robotoMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
            SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

            Text(
              campaignModel.description ?? 'no_description_found'.tr, maxLines: 2, overflow: TextOverflow.ellipsis,
              style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL, color: Theme.of(context).disabledColor),
            ),
            SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

            Row(children: [

              InkWell(
                onTap: () {
                  if(campaignModel.vendorStatus == null){
                    Get.dialog(ConfirmationDialog(
                      icon: Images.warning, description: campaignModel.isJoined ? 'are_you_sure_to_leave'.tr : 'are_you_sure_to_join'.tr,
                      adminText: '' ,
                      onYesPressed: () {
                        Get.find<CampaignController>().joinCampaign(campaignModel.id, false);
                      },
                    ));
                  }else if(campaignModel.vendorStatus == 'confirmed'){
                    Get.dialog(ConfirmationDialog(
                      icon: Images.warning, description: campaignModel.isJoined ? 'are_you_sure_to_leave'.tr : 'are_you_sure_to_join'.tr,
                      adminText: '' ,
                      onYesPressed: () {
                        Get.find<CampaignController>().leaveCampaign(campaignModel.id, false);
                      },
                    ));
                  }

                },
                child: Container(
                  height: 25, width: 70, alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: campaignModel.vendorStatus == null ? Theme.of(context).primaryColor : campaignModel.vendorStatus == 'rejected' ? Theme.of(context).colorScheme.error : Theme.of(context).secondaryHeaderColor,
                    borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                  ),
                  child: Text(campaignModel.vendorStatus == null ? 'join_now'.tr : campaignModel.vendorStatus != 'confirmed'
                      ? campaignModel.vendorStatus.tr : 'leave_now'.tr, textAlign: TextAlign.center, style: robotoBold.copyWith(
                    color: Theme.of(context).cardColor,
                    fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL,
                  )),
                ),
              ),
              Expanded(child: SizedBox()),

              Icon(Icons.date_range, size: 15, color: Theme.of(context).disabledColor),
              SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
              Text(
                DateConverter.convertDateToDate(campaignModel.availableDateStarts),
                style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL, color: Theme.of(context).disabledColor),
              ),

            ]),

          ])),

        ]),
      ),
    );
  }
}
