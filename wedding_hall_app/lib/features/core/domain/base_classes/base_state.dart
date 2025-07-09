
import '../../../../config/networking/api_error_model.dart';

abstract class BaseState {}

class InitialState extends BaseState {}

class LoadingState extends BaseState {}

class SuccessState<T> extends BaseState {
  final T data;

  SuccessState(this.data);
}

class ErrorState<String> extends BaseState {
  final ApiErrorModel apiErrorModel;

  ErrorState(this.apiErrorModel);
}


