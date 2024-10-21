import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:uniplanet/features/upload/domain/entities/job.dart';
import 'package:uniplanet/features/upload/domain/usecases/post_job_usecase.dart';

part 'job_event.dart';
part 'job_state.dart';

class JobBloc extends Bloc<JobEvent, JobState> {
  final CreateJobPost createJobPost;

  JobBloc({required this.createJobPost}) : super(JobInitial()) {
    on<PostJob>((event, emit) async {
      // Await the _postJob method to ensure it completes before the handler completes
      await _postJob(event, emit);
    });
  }

  // Ensure async operations are awaited
  Future<void> _postJob(PostJob event, Emitter<JobState> emit) async {
    emit(JobPostInProgress());
    try {
      await createJobPost(event.post); // Make sure this is awaited
      emit(JobPostSuccess());
    } catch (e) {
      emit(JobPostFailure(e.toString()));
    }
  }
}
