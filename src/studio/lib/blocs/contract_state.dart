part of 'contract_cubit.dart';

enum ContractStatus { initial, loading, loaded, error }

class ContractState extends Equatable {
  final ContractStatus status;
  final List<Contract> contracts;
  final List<Contract> selectedContracts;
  final String? errorMessage;

  const ContractState({
    this.status = ContractStatus.initial,
    this.contracts = const [],
    this.selectedContracts = const [],
    this.errorMessage,
  });

  ContractState copyWith({
    ContractStatus? status,
    List<Contract>? contracts,
    List<Contract>? selectedContracts,
    String? errorMessage,
  }) {
    return ContractState(
      status: status ?? this.status,
      contracts: contracts ?? this.contracts,
      selectedContracts: selectedContracts ?? this.selectedContracts,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        contracts,
        selectedContracts,
        errorMessage,
      ];
}
