abstract class LayoutCubitstate {}

class InitialState extends LayoutCubitstate {}

class LayoutLoadingState extends InitialState {}

class LayoutSuccessState extends InitialState {}

class LayoutErrorState extends InitialState {
  final error;
  LayoutErrorState(this.error);
}
class ChangeNav extends InitialState{}

class GetProfileImageSuccess extends InitialState{}

class GetProfileImageError extends InitialState{}

class UploadProfileImageSuccess extends InitialState{}

class UploadProfileImageError extends InitialState{}

class GetCoverImageSuccess extends InitialState{}

class GetCoverImageError extends InitialState{}

class UploadCoverImageSuccess extends InitialState{}

class UploadCoverImageError extends InitialState{}

class UpdateUsersDataLoadingState extends InitialState {}

class UpdateUserDataError extends InitialState{}