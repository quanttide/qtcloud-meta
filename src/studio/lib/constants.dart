import 'package:flutter/material.dart';

String eventDirectionLabel(String direction) {
  switch (direction) {
    case 'publish':
      return '发布';
    case 'subscribe':
      return '订阅';
    default:
      return direction;
  }
}

Color eventDirectionColor(String direction) {
  switch (direction) {
    case 'publish':
      return Colors.blue;
    case 'subscribe':
      return Colors.green;
    default:
      return Colors.grey;
  }
}

String eventStatusLabel(String status) {
  switch (status) {
    case 'active':
      return '活跃';
    case 'deprecated':
      return '已弃用';
    default:
      return status;
  }
}

String contractStatusLabel(String status) {
  switch (status) {
    case 'active':
      return '活跃';
    case 'change_pending':
      return '变更待确认';
    case 'superseded':
      return '已替换';
    default:
      return status;
  }
}

Color contractStatusColor(String status) {
  switch (status) {
    case 'active':
      return Colors.green;
    case 'change_pending':
      return Colors.orange;
    case 'superseded':
      return Colors.grey;
    default:
      return Colors.grey;
  }
}

String workflowStatusLabel(String status) {
  switch (status) {
    case 'enabled':
      return '已启用';
    case 'disabled':
      return '未启用';
    default:
      return status;
  }
}

Color workflowStatusColor(String status) {
  switch (status) {
    case 'enabled':
      return Colors.green;
    case 'disabled':
      return Colors.grey;
    default:
      return Colors.grey;
  }
}

String domainLabel(String domain) {
  switch (domain) {
    case 'qtcloud.sales':
      return '销售云';
    case 'qtcloud.biz':
      return '商务云';
    case 'qtcloud.asset':
      return '资产云';
    case 'qtcloud.finance':
      return '财务云';
    case 'qtcloud.customer':
      return '客户云';
    default:
      return domain;
  }
}
