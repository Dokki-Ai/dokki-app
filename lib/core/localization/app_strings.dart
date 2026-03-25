enum AppLanguage { ru, en, ar }

class AppStrings {
  final AppLanguage language;
  const AppStrings(this.language);

  // --- Навигация ---
  String get navShop => _map({AppLanguage.ru: 'Магазин', AppLanguage.en: 'Shop', AppLanguage.ar: 'المتجر'});
  String get navMyBots => _map({AppLanguage.ru: 'Мои боты', AppLanguage.en: 'My Bots', AppLanguage.ar: 'بوتاتي'});
  String get navSettings => _map({AppLanguage.ru: 'Настройки', AppLanguage.en: 'Settings', AppLanguage.ar: 'الإعدادات'});
  String get navSupport => _map({AppLanguage.ru: 'Поддержка', AppLanguage.en: 'Support', AppLanguage.ar: 'الدعم'});

  // --- Auth ---
  String get authLogin => _map({AppLanguage.ru: 'Войти', AppLanguage.en: 'Login', AppLanguage.ar: 'تسجيل الدخول'});
  String get authRegistration => _map({AppLanguage.ru: 'Регистрация', AppLanguage.en: 'Registration', AppLanguage.ar: 'إنشاء حساب'});
  String get authPassword => _map({AppLanguage.ru: 'Пароль', AppLanguage.en: 'Password', AppLanguage.ar: 'كلمة المرور'});
  String get authForgotPassword => _map({AppLanguage.ru: 'Забыли пароль?', AppLanguage.en: 'Forgot password?', AppLanguage.ar: 'هل نسيت كلمة المرور؟'});
  String get authNoAccount => _map({AppLanguage.ru: 'Нет аккаунта? Регистрация', AppLanguage.en: 'No account? Register', AppLanguage.ar: 'ليس لديك حساب؟ سجل الآن'});
  String get authHasAccount => _map({AppLanguage.ru: 'Уже есть аккаунт? Войти', AppLanguage.en: 'Already have an account? Login', AppLanguage.ar: 'لديك حساب بالفعل؟ دخول'});
  String get authGoogle => _map({AppLanguage.ru: 'Войти через Google', AppLanguage.en: 'Sign in with Google', AppLanguage.ar: 'تسجيل الدخول عبر Google'});
  String get authFieldsRequired => _map({AppLanguage.ru: 'Заполните все поля', AppLanguage.en: 'Fill all fields', AppLanguage.ar: 'يرجى ملء جميع الحقول'});
  String get authCheckEmail => _map({AppLanguage.ru: 'Проверьте почту для подтверждения', AppLanguage.en: 'Check your email for confirmation', AppLanguage.ar: 'تحقق من بريدك الإلكتروني للتأكيد'});
  String get authError => _map({AppLanguage.ru: 'Произошла ошибка', AppLanguage.en: 'An error occurred', AppLanguage.ar: 'حدث خطأ ما'});
  String get authOr => _map({AppLanguage.ru: 'или', AppLanguage.en: 'or', AppLanguage.ar: 'أو'});

  // --- Каталог ---
  String get catDetails => _map({AppLanguage.ru: 'Подробнее', AppLanguage.en: 'Details', AppLanguage.ar: 'المزيد'});
  String get catDescription => _map({AppLanguage.ru: 'Описание', AppLanguage.en: 'Description', AppLanguage.ar: 'الوصف'});
  String get catFunctions => _map({AppLanguage.ru: 'Функции', AppLanguage.en: 'Functions', AppLanguage.ar: 'الميزات'});
  String get catEmpty => _map({AppLanguage.ru: 'Список пуст', AppLanguage.en: 'List is empty', AppLanguage.ar: 'القائمة فارغة'});

  // --- BotDetail ---
  String get botConnect => _map({AppLanguage.ru: 'Подключить', AppLanguage.en: 'Connect', AppLanguage.ar: 'اتصال'});

  // --- Payment ---
  String get paySubscription => _map({AppLanguage.ru: 'Подписка', AppLanguage.en: 'Subscription', AppLanguage.ar: 'اشتراك'});
  String get payMonth => _map({AppLanguage.ru: 'месяц', AppLanguage.en: 'month', AppLanguage.ar: 'شهر'});
  String get payYear => _map({AppLanguage.ru: 'год', AppLanguage.en: 'year', AppLanguage.ar: 'سنة'});
  String get payAction => _map({AppLanguage.ru: 'ПОДКЛЮЧИТЬ ЗА', AppLanguage.en: 'CONNECT FOR', AppLanguage.ar: 'اتصال مقابل'});
  String get paySuccessTitle => _map({AppLanguage.ru: 'Оплата успешна', AppLanguage.en: 'Payment successful', AppLanguage.ar: 'تم الدفع بنجاح'});
  String get paySuccessBody => _map({AppLanguage.ru: 'Подписка активирована (тестовый режим)', AppLanguage.en: 'Subscription activated (test mode)', AppLanguage.ar: 'تم تفعيل الاشتراك (وضع الاختبار)'});
  String get payContinue => _map({AppLanguage.ru: 'Продолжить', AppLanguage.en: 'Continue', AppLanguage.ar: 'استمرار'});

  // --- MyBots & BusinessCard ---
  String get myBotsLocked => _map({AppLanguage.ru: 'Войдите чтобы увидеть ваших ботов', AppLanguage.en: 'Login to see your bots', AppLanguage.ar: 'سجل الدخول لرؤية بوتاتك'});
  String get myBotsEmpty => _map({AppLanguage.ru: 'У вас пока нет подключённых ботов', AppLanguage.en: 'You have no connected bots yet', AppLanguage.ar: 'ليس لديك بوتات متصلة بعد'});
  String get myBotsGoCatalog => _map({AppLanguage.ru: 'Перейти в каталог', AppLanguage.en: 'Go to catalog', AppLanguage.ar: 'الذهاب إلى المتجر'});
  String get bmManage => _map({AppLanguage.ru: 'Управление', AppLanguage.en: 'Manage', AppLanguage.ar: 'إدارة'});
  String get bmStatusOff => _map({AppLanguage.ru: 'Отключён', AppLanguage.en: 'Disabled', AppLanguage.ar: 'معطل'});
  String get bmStatusActive => _map({AppLanguage.ru: 'В работе', AppLanguage.en: 'Active', AppLanguage.ar: 'قيد العمل'});
  String get bmStatusSetup => _map({AppLanguage.ru: 'Настройка', AppLanguage.en: 'Setup', AppLanguage.ar: 'إعداد'});

  // --- Settings ---
  String get setAccount => _map({AppLanguage.ru: 'Аккаунт', AppLanguage.en: 'Account', AppLanguage.ar: 'الحساب'});
  String get setLanguage => _map({AppLanguage.ru: 'Язык', AppLanguage.en: 'Language', AppLanguage.ar: 'اللغة'});
  String get setNotifications => _map({AppLanguage.ru: 'Уведомления', AppLanguage.en: 'Notifications', AppLanguage.ar: 'الإشعارات'});
  String get setAbout => _map({AppLanguage.ru: 'О приложении', AppLanguage.en: 'About app', AppLanguage.ar: 'حول التطبيق'});
  String get setVersion => _map({AppLanguage.ru: 'Версия', AppLanguage.en: 'Version', AppLanguage.ar: 'الإصدار'});
  String get setNotifSettings => _map({AppLanguage.ru: 'Настройки уведомлений', AppLanguage.en: 'Notification settings', AppLanguage.ar: 'إعدادات الإشعارات'});

  // --- Profile ---
  String get profTitle => _map({AppLanguage.ru: 'Профиль', AppLanguage.en: 'Profile', AppLanguage.ar: 'الملف الشخصي'});
  String get profChangePass => _map({AppLanguage.ru: 'Сменить пароль', AppLanguage.en: 'Change password', AppLanguage.ar: 'تغيير كلمة المرور'});
  String get profLogout => _map({AppLanguage.ru: 'Выйти из аккаунта', AppLanguage.en: 'Sign out', AppLanguage.ar: 'تسجيل الخروج'});
  String get profCurrentPass => _map({AppLanguage.ru: 'Текущий пароль', AppLanguage.en: 'Current password', AppLanguage.ar: 'كلمة المرور الحالية'});
  String get profNewPass => _map({AppLanguage.ru: 'Новый пароль', AppLanguage.en: 'New password', AppLanguage.ar: 'كلمة المرور الجديدة'});
  String get profRepeatPass => _map({AppLanguage.ru: 'Повторите новый пароль', AppLanguage.en: 'Repeat new password', AppLanguage.ar: 'تأكيد كلمة المرور الجديدة'});
  String get profCancel => _map({AppLanguage.ru: 'Отмена', AppLanguage.en: 'Cancel', AppLanguage.ar: 'إلغاء'});
  String get profSave => _map({AppLanguage.ru: 'Сохранить', AppLanguage.en: 'Save', AppLanguage.ar: 'حفظ'});
  String get profPassMismatch => _map({AppLanguage.ru: 'Пароли не совпадают', AppLanguage.en: 'Passwords do not match', AppLanguage.ar: 'كلمات المرور غير متطابقة'});
  String get profPassLength => _map({AppLanguage.ru: 'Пароль должен быть минимум 6 символов', AppLanguage.en: 'Password must be at least 6 characters', AppLanguage.ar: 'يجب أن تكون كلمة المرور 6 أحرف على الأقل'});
  String get profPassSuccess => _map({AppLanguage.ru: 'Пароль успешно изменён', AppLanguage.en: 'Password changed successfully', AppLanguage.ar: 'تم تغيير كلمة المرور بنجاح'});

  // --- Notifications ---
  String get notifPush => _map({AppLanguage.ru: 'Push-уведомления', AppLanguage.en: 'Push notifications', AppLanguage.ar: 'إشعارات الدفع'});
  String get notifPushSub => _map({AppLanguage.ru: 'Получать уведомления на устройство', AppLanguage.en: 'Receive notifications on device', AppLanguage.ar: 'تلقي الإشعارات على الجهاز'});
  String get notifEmail => _map({AppLanguage.ru: 'Email-уведомления', AppLanguage.en: 'Email notifications', AppLanguage.ar: 'إشعارات البريد'});
  String get notifEmailSub => _map({AppLanguage.ru: 'Получать уведомления на почту', AppLanguage.en: 'Receive notifications by email', AppLanguage.ar: 'تلقي الإشعارات عبر البريد'});

  // --- BotManagement ---
  String get bmTitle => _map({AppLanguage.ru: 'Управление ботом', AppLanguage.en: 'Bot management', AppLanguage.ar: 'إدارة البوت'});
  String get bmActions => _map({AppLanguage.ru: 'ДЕЙСТВИЯ', AppLanguage.en: 'ACTIONS', AppLanguage.ar: 'الإجراءات'});
  String get bmAppointments => _map({AppLanguage.ru: 'ЗАПИСИ', AppLanguage.en: 'APPOINTMENTS', AppLanguage.ar: 'السجلات'});
  String get bmPromptSettings => _map({AppLanguage.ru: 'НАСТРОЙКИ ПРОМПТА', AppLanguage.en: 'PROMPT SETTINGS', AppLanguage.ar: 'إعدادات الأوامр'});
  String get bmActivateGroup => _map({AppLanguage.ru: 'АКТИВИРОВАТЬ ГРУППУ', AppLanguage.en: 'ACTIVATE GROUP', AppLanguage.ar: 'تفعيل المجموعة'});
  String get bmActive => _map({AppLanguage.ru: 'Бот активен', AppLanguage.en: 'Bot active', AppLanguage.ar: 'البوت مفعل'});
  String get bmSetupRequired => _map({AppLanguage.ru: 'Требуется настройка', AppLanguage.en: 'Setup required', AppLanguage.ar: 'مطلوب إعداد'});
  String get bmReady => _map({AppLanguage.ru: 'Бот готов к приему заказов', AppLanguage.en: 'Bot ready for orders', AppLanguage.ar: 'البوت جاهز لتلقي الطلبات'});
  String get bmBindGroup => _map({AppLanguage.ru: 'Привяжите Telegram группу', AppLanguage.en: 'Bind Telegram group', AppLanguage.ar: 'ربط مجموعة تيليجرام'});

  // Вспомогательный метод
  String _map(Map<AppLanguage, String> values) => values[language] ?? values[AppLanguage.ru]!;
}
