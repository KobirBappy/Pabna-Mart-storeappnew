import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:appmartbdstore/data/api/api_client.dart';
import 'package:appmartbdstore/util/app_constants.dart';

class ExpenseRepo {
  final ApiClient apiClient;

  ExpenseRepo({@required this.apiClient});

  Future<Response> getExpenseList({@required int offset, @required int restaurantId, @required String from, @required String to,  @required String searchText}) async {
    return apiClient.getData('${AppConstants.EXPENSE_LIST_URI}?limit=10&offset=$offset&restaurant_id=$restaurantId&from=$from&to=$to&search=${searchText == null ? '' : searchText}');
  }
}