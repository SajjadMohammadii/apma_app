// بلاک مدیریت state و منطق تجاری احراز هویت
// مرتبط با: auth_event.dart, auth_state.dart, login_usecase.dart, auth_repository.dart, local_storage_service.dart

import 'package:apma_app/core/errors/failures.dart'; // کلاس‌های خطا
import 'package:apma_app/core/services/local_storage_service.dart'; // سرویس ذخیره‌سازی محلی
import 'package:apma_app/features/auth/data/models/user_model.dart'; // مدل کاربر
import 'package:apma_app/features/auth/domain/entities/user.dart'; // موجودیت کاربر
import 'package:apma_app/features/auth/domain/repositories/auth_repository.dart'; // ریپازیتوری احراز هویت
import 'package:apma_app/features/auth/domain/usecases/login_usecase.dart'; // یوزکیس ورود
import 'package:dartz/dartz.dart'; // کتابخانه Either
import 'package:flutter_bloc/flutter_bloc.dart'; // فریمورک BLoC
import 'auth_event.dart'; // رویدادهای احراز هویت
import 'auth_state.dart'; // وضعیت‌های احراز هویت

// کلاس AuthBloc - مدیریت رویدادهای احراز هویت و انتشار وضعیت‌های متناظر
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase? loginUseCase; // یوزکیس ورود (اختیاری)
  final AuthRepository? repository; // ریپازیتوری احراز هویت (اختیاری)
  final LocalStorageService localStorageService; // سرویس ذخیره‌سازی محلی

  // سازنده بلاک - تنظیم هندلرهای رویداد
  AuthBloc({
    this.loginUseCase,
    this.repository,
    required this.localStorageService,
  }) : super(const AuthInitial()) {
    on<LoginEvent>(_onLogin); // هندلر رویداد ورود
    on<LogoutEvent>(_onLogout); // هندلر رویداد خروج
    on<CheckAuthStatusEvent>(
      _onCheckAuthStatus,
    ); // هندلر بررسی وضعیت احراز هویت
    on<AutoLoginEvent>(_onAutoLogin); // هندلر ورود خودکار
  }

  // متد _onLogin - مدیریت ورود دستی با دیالوگ ذخیره رمز عبور
  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(const AuthLoading()); // انتشار وضعیت در حال بارگذاری

    try {
      Either<Failure, User> result; // نتیجه عملیات
      if (loginUseCase != null) {
        // اگر یوزکیس موجود است
        result = await loginUseCase!(
          LoginParams(username: event.username, password: event.password),
        );
      } else if (repository != null) {
        // اگر ریپازیتوری موجود است
        result = await repository!.login(
          username: event.username,
          password: event.password,
        );
      } else {
        // اگر هیچ پیاده‌سازی موجود نیست
        emit(const AuthError('No authentication implementation provided.'));
        return;
      }

      // پردازش نتیجه
      result.fold((failure) => emit(AuthError(failure.message)), (user) {
        final userModel = user as UserModel; // تبدیل به مدل کاربر
        localStorageService.saveUserSession(
          // ذخیره سشن کاربر
          username: userModel.username,
          name: userModel.name ?? '',
          token: userModel.token ?? '',
          role: userModel.role,
        );
        emit(
          AuthAuthenticated(user, showSavePasswordDialog: true),
        ); // انتشار وضعیت احراز هویت شده
      });
    } catch (e) {
      emit(AuthError(e.toString())); // انتشار خطا
    }
  }

  // متد _onAutoLogin - مدیریت ورود خودکار بدون دیالوگ ذخیره رمز عبور
  Future<void> _onAutoLogin(
    AutoLoginEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading()); // انتشار وضعیت در حال بارگذاری

    try {
      Either<Failure, User> result; // نتیجه عملیات
      if (loginUseCase != null) {
        result = await loginUseCase!(
          LoginParams(username: event.username, password: event.password),
        );
      } else if (repository != null) {
        result = await repository!.login(
          username: event.username,
          password: event.password,
        );
      } else {
        emit(const AuthError('No authentication implementation provided.'));
        return;
      }

      // پردازش نتیجه
      result.fold((failure) => emit(AuthError(failure.message)), (user) {
        final userModel = user as UserModel;
        localStorageService.saveUserSession(
          username: userModel.username,
          name: userModel.name ?? '',
          token: userModel.token ?? '',
          role: userModel.role,
        );
        emit(
          AuthAuthenticated(user, showSavePasswordDialog: false),
        ); // بدون دیالوگ ذخیره رمز
      });
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  // متد _onLogout - مدیریت خروج کاربر و پاکسازی سشن
  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    emit(const AuthLoading()); // انتشار وضعیت در حال بارگذاری
    try {
      if (repository != null) {
        await repository!.logout(); // خروج از ریپازیتوری
      }
      await localStorageService.logout(); // پاکسازی ذخیره‌سازی محلی
      emit(const AuthUnauthenticated()); // انتشار وضعیت خارج شده
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  // متد _onCheckAuthStatus - بررسی وضعیت احراز هویت در شروع برنامه
  Future<void> _onCheckAuthStatus(
    CheckAuthStatusEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading()); // انتشار وضعیت در حال بارگذاری
    try {
      if (repository != null) {
        final res = await repository!.isLoggedIn(); // بررسی وضعیت ورود
        res.fold((failure) => emit(const AuthUnauthenticated()), (
          isLogged,
        ) async {
          if (isLogged) {
            // اگر کاربر وارد شده
            final userRes =
                await repository!.getCurrentUser(); // دریافت کاربر فعلی
            userRes.fold(
              (f) => emit(const AuthUnauthenticated()),
              (user) =>
                  emit(AuthAuthenticated(user)), // انتشار وضعیت احراز هویت شده
            );
          } else {
            emit(const AuthUnauthenticated()); // انتشار وضعیت خارج شده
          }
        });
      } else {
        emit(const AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
