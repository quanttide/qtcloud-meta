import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../models/contract.dart';
import '../sources/data_source.dart';

part 'contract_state.dart';

class ContractCubit extends Cubit<ContractState> {
  final DataLoader<List<Contract>> _loader;

  ContractCubit({
    DataSource? source,
    required String contractsPath,
  }) : _loader = DataLoader<List<Contract>>(
          source ?? BundleSource(),
          contractsPath,
          _parseContractList,
        ),
        super(const ContractState());

  static List<Contract> _parseContractList(dynamic json) {
    return (json as List<dynamic>)
        .map((e) => Contract.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> loadContracts() async {
    emit(state.copyWith(status: ContractStatus.loading));
    final result = await _loader.load();
    switch (result) {
      case DataSuccess<List<Contract>>():
        emit(state.copyWith(
          status: ContractStatus.loaded,
          contracts: result.data,
        ));
      case DataError<List<Contract>>():
        emit(state.copyWith(
          status: ContractStatus.error,
          errorMessage: result.message,
        ));
    }
  }

  void selectContract(String eventId) {
    final contract = state.contracts.where((c) => c.eventId == eventId).toList();
    emit(state.copyWith(selectedContracts: contract));
  }
}
