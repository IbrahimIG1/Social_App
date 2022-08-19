abstract class LayoutCubitstate {}

class InitialState extends LayoutCubitstate {}

class LayoutLoadingState extends InitialState {}

class LayoutSuccessState extends InitialState {}

class LayoutErrorState extends InitialState {
  final error;
  LayoutErrorState(this.error);
}
class ChangeNav extends InitialState{}