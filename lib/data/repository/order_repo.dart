import 'package:appmartbdstore/data/api/api_client.dart';
import 'package:appmartbdstore/data/model/body/update_status_body.dart';
import 'package:appmartbdstore/util/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:get/state_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderRepo extends GetxService {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  OrderRepo({@required this.apiClient, @required this.sharedPreferences});

  Future<Response> getAllOrders() {
    return apiClient.getData(AppConstants.ALL_ORDERS_URI);
  }

  Future<Response> getCurrentOrders() {
    return apiClient.getData(AppConstants.CURRENT_ORDERS_URI);
  }

  Future<Response> getCompletedOrders() {
    return apiClient.getData(AppConstants.COMPLETED_ORDERS_URI);
  }

  Future<Response> getPaginatedOrderList(int offset, String status) async {
    return await apiClient.getData('${AppConstants.COMPLETED_ORDERS_URI}?status=$status&offset=$offset&limit=10');
  }

  Future<Response> updateOrderStatus(UpdateStatusBody updateStatusBody) {
    return apiClient.postData(AppConstants.UPDATE_ORDER_STATUS_URI, updateStatusBody.toJson());
  }

  Future<Response> getOrderDetails(int orderID) {
    return apiClient.getData('${AppConstants.ORDER_DETAILS_URI}$orderID');
  }

  Future<Response> getOrderWithId(int orderId) {
    return apiClient.getData('${AppConstants.CURRENT_ORDER_DETAILS_URI}$orderId');
  }

  Future<Response> updateOrderAmount(Map<String, String> body) {
    return apiClient.postData(AppConstants.UPDATE_ORDER_URI, body);
  }

  Future<Response> getCancelReasons() async {
    return await apiClient.getData('${AppConstants.ORDER_CANCELLATION_URI}?offset=1&limit=30&type=store');
  }

}