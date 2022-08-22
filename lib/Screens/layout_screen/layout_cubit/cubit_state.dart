abstract class LayoutCubitstate {}

class InitialState extends LayoutCubitstate {}

class LayoutLoadingState extends InitialState {}

class LayoutSuccessState extends InitialState {}

class LayoutErrorState extends InitialState {
  final error;
  LayoutErrorState(this.error);
}
class ChangeNav extends InitialState{}
class PostScreenState extends InitialState{}

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

// create post 
class CreatePostLoadingState extends InitialState {}
class CreatePostSuccessState extends InitialState {}
class CreatePostErrorState extends InitialState {}

class UploadPostImageSuccess extends InitialState{}

class UploadPostImageError extends InitialState{}

class GetPostImageSuccess extends InitialState{}

class GetPostImageError extends InitialState{}

class ClosedPostImageSuccess extends InitialState{}

// get posts

class GetPostsLoadingState extends InitialState{}
class GetPostsSuccessState extends InitialState{}
class GetPostsErrorState extends InitialState{}


// posts Likes
class PostsLikesSuccessState extends InitialState{}
class PostsLikesErrorState extends InitialState{}
// posts Comments
class PostsCommentsSuccessState extends InitialState{}
class PostsCommentsErrorState extends InitialState{}