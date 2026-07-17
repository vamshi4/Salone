// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get insightsTitle => 'Estadísticas';

  @override
  String get tabEarnings => 'Ganancias';

  @override
  String get tabRetention => 'Retención';

  @override
  String get periodToday => 'Hoy';

  @override
  String get periodWeek => 'Semana';

  @override
  String get periodMonth => 'Mes';

  @override
  String get periodLast7Days => 'Últimos 7 días';

  @override
  String get periodLast30Days => 'Últimos 30 días';

  @override
  String get earningsLoadError => 'No se pudieron cargar las ganancias.';

  @override
  String get retry => 'Reintentar';

  @override
  String completedServicesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count servicios',
      one: '$count servicio',
    );
    return '$_temp0';
  }

  @override
  String get completedServicesHeading => 'Servicios completados';

  @override
  String get noCompletedServices =>
      'Aún no hay servicios completados en este período.';

  @override
  String get topServicesHeading => 'Servicios principales';

  @override
  String get byStaffHeading => 'Por personal';

  @override
  String get vsYesterday => 'vs ayer';

  @override
  String get vsLastWeek => 'vs la semana pasada';

  @override
  String get vsLastMonth => 'vs el mes pasado';

  @override
  String percentChangeLabel(int percent, String label) {
    return '$percent% $label';
  }

  @override
  String get reactivatedWinsTitle => 'Clientes recuperados';

  @override
  String reactivatedSummary(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count clientes regresaron este mes',
      one: '$count cliente regresó este mes',
    );
    return '$_temp0';
  }

  @override
  String customerServicePair(String customer, String service) {
    return '$customer · $service';
  }

  @override
  String get retentionLoadError => 'No se pudo cargar el informe de retención.';

  @override
  String get couldNotOpenWhatsapp => 'No se pudo abrir WhatsApp';

  @override
  String whatsappReminderMessage(String name, String salonName) {
    return '¡Hola $name! Te extrañamos en $salonName. Reserva tu próxima visita y disfruta de una oferta especial de bienvenida. ¡Nos vemos pronto!';
  }

  @override
  String get customerCohortsHeading => 'Grupos de clientes';

  @override
  String cohortMembersLabel(String label, int count) {
    return '$label · $count clientes';
  }

  @override
  String noCohortCustomers(String label) {
    return 'No hay clientes $label en este período.';
  }

  @override
  String get missedCustomersHeading => 'Clientes perdidos';

  @override
  String get missedCustomersHint =>
      'Toca \"Recordar\" para enviarles un mensaje por WhatsApp.';

  @override
  String get noMissedCustomers => 'Ningún cliente perdido este mes.';

  @override
  String get cohortRegulars => 'Habituales';

  @override
  String get cohortNew => 'Nuevos';

  @override
  String get cohortCameBack => 'Regresaron';

  @override
  String get cohortStoppedComing => 'Dejaron de venir';

  @override
  String get customersLabel => 'clientes';

  @override
  String get reachOutNow => 'Contactar ahora';

  @override
  String atRiskSummary(int count, String revenue) {
    return '$count clientes habituales se están perdiendo · $revenue en riesgo';
  }

  @override
  String overdueBadge(String ratio) {
    return '$ratio× atrasado';
  }

  @override
  String cadenceOverdue(String cadence, String overdue) {
    return 'Normalmente cada ${cadence}d · ${overdue}d de atraso';
  }

  @override
  String get remind => 'Recordar';

  @override
  String get remindOnWhatsappTooltip => 'Recordar por WhatsApp';

  @override
  String get retentionProTitle =>
      'Las estadísticas de retención son una función PRO';

  @override
  String get retentionProBody =>
      'Descubre quién dejó de venir, tu proporción de clientes nuevos frente a recurrentes, y recupera clientes perdidos con recordatorios de un toque.';

  @override
  String get upgradeToPro => 'Mejorar a PRO';

  @override
  String visitsSpentSummary(int visits, String spend) {
    return '$visits visitas · gastado $spend';
  }

  @override
  String get createYourAccount => 'Crea tu cuenta';

  @override
  String get basics => 'Datos básicos';

  @override
  String get country => 'País';

  @override
  String get countryHelperText =>
      'Define tu moneda, formato de teléfono e idioma predeterminado.';

  @override
  String get language => 'Idioma';

  @override
  String get phoneNumberLabel => 'Número de teléfono';

  @override
  String get passwordLabel => 'Contraseña';

  @override
  String stepOfTotal(int step, int total) {
    return 'Paso $step de $total';
  }

  @override
  String get createAccountButton => 'Crear cuenta';

  @override
  String get continueButton => 'Continuar';

  @override
  String get enterPhoneNumber => 'Ingresa un número de teléfono';

  @override
  String get passwordMinLength =>
      'La contraseña debe tener al menos 6 caracteres';

  @override
  String get fillOwnerSalonAddress =>
      'Completa el nombre del propietario, el salón y la dirección';

  @override
  String get turnOnLocationPermission =>
      'Activa la ubicación y permite el acceso para usar esto';

  @override
  String get couldNotGetLocation => 'No se pudo obtener tu ubicación';

  @override
  String get phoneAlreadyRegisteredSignIn =>
      'Este teléfono ya está registrado. Inicia sesión en su lugar.';

  @override
  String get signupFailedCheckBackend =>
      'Error al registrarse. Verifica la conexión del servidor.';

  @override
  String get signupFailedTryAgain =>
      'Error al registrarse. Inténtalo de nuevo.';

  @override
  String get yourSalon => 'Tu salón';

  @override
  String get salonDetailsSubtitle => 'Paso 2 de 3 · Detalles del salón';

  @override
  String get ownerNameLabel => 'Nombre del propietario';

  @override
  String get salonNameLabel => 'Nombre del salón';

  @override
  String get salonAddressLabel => 'Dirección del salón';

  @override
  String get locationSet => 'Ubicación establecida';

  @override
  String get useMyCurrentLocation => 'Usar mi ubicación actual';

  @override
  String get pickYourColor => 'Elige tu color';

  @override
  String get colorPreviewHelp =>
      'Este es el color de acento de tu salón en toda la app. Cámbialo cuando quieras en Cuenta.';

  @override
  String get previewLabel => 'Vista previa';

  @override
  String get newBooking => 'Nueva reserva';

  @override
  String get colorTeal => 'Verde azulado';

  @override
  String get colorTerracotta => 'Terracota';

  @override
  String get colorBlue => 'Azul';

  @override
  String get colorViolet => 'Violeta';

  @override
  String get colorRose => 'Rosa';

  @override
  String get welcomeBack => 'Bienvenido de nuevo';

  @override
  String get signInToDashboard => 'Inicia sesión en el panel de tu salón';

  @override
  String get enterSalonOwnerPhone =>
      'Ingresa el teléfono del propietario del salón';

  @override
  String get enterYourPassword => 'Ingresa tu contraseña';

  @override
  String get noSalonOwnerFound =>
      'No se encontró ninguna cuenta de propietario de salón para este teléfono.';

  @override
  String get loginFailedCheckBackend =>
      'Error al iniciar sesión. Verifica la conexión del servidor.';

  @override
  String get loginFailedTryAgain =>
      'Error al iniciar sesión. Inténtalo de nuevo.';

  @override
  String get hidePassword => 'Ocultar contraseña';

  @override
  String get showPassword => 'Mostrar contraseña';

  @override
  String get signIn => 'Iniciar sesión';

  @override
  String get newHere => '¿Nuevo aquí?';

  @override
  String get createAccount => 'Crear cuenta';

  @override
  String get forgotPassword => '¿Olvidaste tu contraseña?';

  @override
  String get resetPasswordTitle => 'Restablecer contraseña';

  @override
  String get resetPasswordEnterPhone =>
      'Ingresa tu número de teléfono y te enviaremos un código de 6 dígitos por WhatsApp.';

  @override
  String get sendCodeViaWhatsApp => 'Enviar código por WhatsApp';

  @override
  String get codeSentViaWhatsApp =>
      'Si esa cuenta existe, se envió un código por WhatsApp.';

  @override
  String get resetPasswordEnterCode =>
      'Ingresa el código que te enviamos por WhatsApp y elige una nueva contraseña.';

  @override
  String get otpCodeLabel => 'Código de 6 dígitos';

  @override
  String get resetPasswordButton => 'Restablecer contraseña';

  @override
  String get resendCode => 'Reenviar código';

  @override
  String get changePhoneNumber => 'Cambiar número de teléfono';

  @override
  String get enterSixDigitCode => 'Ingresa el código de 6 dígitos';

  @override
  String get passwordsDoNotMatch => 'Las contraseñas no coinciden';

  @override
  String get passwordResetSuccess =>
      'Contraseña restablecida. Inicia sesión con tu nueva contraseña.';

  @override
  String get waitBeforeRetryingCode =>
      'Espera un minuto antes de solicitar otro código';

  @override
  String get invalidOrExpiredCode => 'Ese código no es válido o ha expirado';

  @override
  String get tooManyAttemptsRequestNewCode =>
      'Demasiados intentos — solicita un nuevo código';

  @override
  String get continueWithGoogle => 'Continuar con Google';

  @override
  String get signedInWithGoogle => 'Sesión iniciada con Google';

  @override
  String signedInWithGoogleAs(String email) {
    return 'Sesión iniciada con Google como $email';
  }

  @override
  String get usePasswordInstead => 'Usar contraseña en su lugar';

  @override
  String get googleSignInNotConfigured =>
      'El inicio de sesión con Google aún no está configurado';

  @override
  String get googleSignInFailed =>
      'Error al iniciar sesión con Google. Inténtalo de nuevo.';

  @override
  String get googleNoAccountFound =>
      'No se encontró ninguna cuenta para esa cuenta de Google. Crea una primero.';

  @override
  String get linkGoogleAccount => 'Vincular cuenta de Google';

  @override
  String get googleAccountLinked =>
      'Cuenta de Google vinculada — ahora puedes iniciar sesión con ella';

  @override
  String get addStaffBeforeBookings =>
      'Agrega personal activo antes de crear reservas';

  @override
  String get salonLabel => 'Salón';

  @override
  String get statToday => 'Hoy';

  @override
  String get statRepeat => 'Recurrentes';

  @override
  String get statLoggedHelper => 'registrados';

  @override
  String get statBackHelper => 'regresaron';

  @override
  String get statWeek => 'Semana';

  @override
  String get statMonth => 'Mes';

  @override
  String get loggedTodayHeading => 'Registrado hoy';

  @override
  String get nothingLoggedToday =>
      'Aún no hay nada registrado hoy. Toca \"Nueva reserva\" cuando termines un servicio.';

  @override
  String get navHome => 'Inicio';

  @override
  String get navBookings => 'Reservas';

  @override
  String get navStaff => 'Personal';

  @override
  String get navInsights => 'Estadísticas';

  @override
  String get navAccount => 'Cuenta';

  @override
  String get salonAdminTitle => 'Salon Admin';

  @override
  String get noSalonLinked =>
      'Todavía no hay ningún salón vinculado a esta cuenta de propietario.';

  @override
  String get bookingsTitle => 'Reservas';

  @override
  String get searchCustomerOrService => 'Buscar cliente o servicio';

  @override
  String get filterThisWeek => 'Esta semana';

  @override
  String get filterAllTime => 'Todo el tiempo';

  @override
  String get filterAllStaff => 'Todo el personal';

  @override
  String get staffLabel => 'Personal';

  @override
  String get needsActionHeading => 'Requiere acción';

  @override
  String get statTotal => 'Total';

  @override
  String get statServices => 'Servicios';

  @override
  String get statAvgTicket => 'Ticket promedio';

  @override
  String get noBookingsMatchFilter =>
      'Ninguna reserva coincide con este filtro';

  @override
  String get today => 'Hoy';

  @override
  String get yesterday => 'Ayer';

  @override
  String dayTotalServices(String total, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count servicios',
      one: '$count servicio',
    );
    return '$total · $_temp0';
  }

  @override
  String get couldNotOpenStore => 'No se pudo abrir la tienda';

  @override
  String get updateRequired => 'Actualización requerida';

  @override
  String get updateRequiredBody =>
      'Hay una nueva versión de la app disponible. Actualiza para seguir usando el panel de tu salón.';

  @override
  String get updateNow => 'Actualizar ahora';

  @override
  String get themeColorTitle => 'Color del tema';

  @override
  String get save => 'Guardar';

  @override
  String get staffTitle => 'Personal';

  @override
  String get addStaff => 'Agregar personal';

  @override
  String get statActive => 'Activos';

  @override
  String get statTodaysTotal => 'Total de hoy';

  @override
  String get noActiveStaffYet => 'Aún no hay personal activo';

  @override
  String get addFirstStaff => 'Agregar primer miembro del personal';

  @override
  String get noServicesYet => 'Aún no hay servicios';

  @override
  String get notActive => 'No activo';

  @override
  String get canSetOwnPrice => 'Puede fijar su propio precio';

  @override
  String staffTodayTally(int count, String revenue) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count servicios',
      one: '$count servicio',
    );
    return '$_temp0 · $revenue';
  }

  @override
  String get newLabel => 'Nueva';

  @override
  String get serviceLabel => 'Servicio';

  @override
  String get customerLabel => 'Cliente';

  @override
  String get repeatLabel => 'Recurrente';

  @override
  String get couldNotUpdateBooking =>
      'No se pudo actualizar la reserva. Inténtalo de nuevo.';

  @override
  String get couldNotAcceptReschedule =>
      'No se pudo aceptar el cambio de horario. Inténtalo de nuevo.';

  @override
  String get couldNotRejectReschedule =>
      'No se pudo rechazar el cambio de horario. Inténtalo de nuevo.';

  @override
  String get rescheduleLabel => 'Reprogramar';

  @override
  String get pendingLabel => 'Pendiente';

  @override
  String customerWithStylist(String customer, String stylist) {
    return '$customer con $stylist';
  }

  @override
  String customerRequestedTime(String time) {
    return 'El cliente solicitó $time';
  }

  @override
  String get reject => 'Rechazar';

  @override
  String get accept => 'Aceptar';

  @override
  String get confirm => 'Confirmar';

  @override
  String plusMoreServices(String first, int count) {
    return '$first + $count más';
  }

  @override
  String twoServicesJoin(String a, String b) {
    return '$a + $b';
  }

  @override
  String get couldNotLoadAccount =>
      'No se pudieron cargar los detalles de la cuenta';

  @override
  String get fillOwnerPhoneSalonAddress =>
      'Completa propietario, teléfono, nombre del salón y dirección';

  @override
  String get accountUpdated => 'Cuenta actualizada';

  @override
  String get phoneOrEmailUsed => 'El teléfono o correo ya está en uso';

  @override
  String get couldNotSaveAccount =>
      'No se pudieron guardar los detalles de la cuenta';

  @override
  String get newPasswordMinLength =>
      'La nueva contraseña debe tener al menos 6 caracteres';

  @override
  String get newPasswordsDontMatch => 'Las nuevas contraseñas no coinciden';

  @override
  String get passwordChanged => 'Contraseña cambiada';

  @override
  String get currentPasswordIncorrect => 'La contraseña actual es incorrecta';

  @override
  String get couldNotChangePassword => 'No se pudo cambiar la contraseña';

  @override
  String get countryAndCurrency => 'País y moneda';

  @override
  String get accountTitle => 'Cuenta';

  @override
  String ownerSinceDate(String date) {
    return 'Propietario desde $date';
  }

  @override
  String planLabel(String plan) {
    return 'Plan $plan';
  }

  @override
  String get retentionFreeFor6Months =>
      'Estadísticas de retención gratis por 6 meses';

  @override
  String get upgrade => 'Mejorar';

  @override
  String get appearance => 'Apariencia';

  @override
  String get salonProfile => 'Perfil del salón';

  @override
  String get emailLabel => 'Correo electrónico';

  @override
  String get locationUpdated => 'Ubicación actualizada';

  @override
  String get saveDetailsButton => 'Guardar detalles';

  @override
  String get savingEllipsis => 'Guardando...';

  @override
  String get security => 'Seguridad';

  @override
  String get currentPasswordLabel => 'Contraseña actual';

  @override
  String get newPasswordLabel => 'Nueva contraseña';

  @override
  String get confirmNewPasswordLabel => 'Confirmar nueva contraseña';

  @override
  String get changePasswordButton => 'Cambiar contraseña';

  @override
  String get changingEllipsis => 'Cambiando...';

  @override
  String get signOut => 'Cerrar sesión';

  @override
  String get enterServiceNamePrice => 'Ingresa el nombre y precio del servicio';

  @override
  String get fillStaffNamePhone => 'Completa el nombre y teléfono del personal';

  @override
  String get addAtLeastOneService => 'Agrega al menos un servicio';

  @override
  String get enterValidOpenCloseTimes =>
      'Ingresa horarios de apertura y cierre válidos (HH:MM, 24 horas)';

  @override
  String get selectAtLeastOneWorkingDay => 'Selecciona al menos un día laboral';

  @override
  String get staffPhoneInUse => 'Ese teléfono del personal ya está en uso';

  @override
  String get couldNotAddStaff =>
      'No se pudo agregar al personal. Inténtalo de nuevo.';

  @override
  String get addStaffSubtitle =>
      'Configura su perfil, servicios y días laborales.';

  @override
  String get staffNameLabel => 'Nombre del personal';

  @override
  String get staffPhoneLabel => 'Teléfono del personal';

  @override
  String get servicesLabel => 'Servicios';

  @override
  String servicesAddedCount(int count) {
    return '$count agregados';
  }

  @override
  String get workingHours => 'Horario laboral';

  @override
  String get opens => 'Abre';

  @override
  String get closes => 'Cierra';

  @override
  String get hhmmHint => 'HH:MM';

  @override
  String get workingDays => 'Días laborales';

  @override
  String get serviceNameHint => 'Nombre del servicio';

  @override
  String get priceHint => 'Precio';

  @override
  String get dayMon => 'Lun';

  @override
  String get dayTue => 'Mar';

  @override
  String get dayWed => 'Mié';

  @override
  String get dayThu => 'Jue';

  @override
  String get dayFri => 'Vie';

  @override
  String get daySat => 'Sáb';

  @override
  String get daySun => 'Dom';

  @override
  String get enterValidStaffNamePhone =>
      'Ingresa un nombre y teléfono válidos del personal';

  @override
  String get staffDetailsSaved => 'Detalles del personal guardados';

  @override
  String get phoneAlreadyInUse => 'Ese teléfono ya está en uso';

  @override
  String get couldNotUpdateStaff => 'No se pudo actualizar al personal';

  @override
  String get enterServiceNameAndPriceShort =>
      'Ingresa el nombre y precio del servicio';

  @override
  String get couldNotAddService => 'No se pudo agregar el servicio';

  @override
  String get editServiceTitle => 'Editar servicio';

  @override
  String get enterValidServiceNamePrice =>
      'Ingresa un nombre y precio de servicio válidos';

  @override
  String get couldNotUpdateService => 'No se pudo actualizar el servicio';

  @override
  String get saveServiceButton => 'Guardar servicio';

  @override
  String get couldNotRemoveServiceDefault => 'No se pudo eliminar el servicio';

  @override
  String get useHHmmWorkingHours => 'Usa HH:mm para el horario laboral';

  @override
  String get hoursAdded => 'Horario agregado';

  @override
  String get couldNotAddWorkingHours => 'No se pudo agregar el horario laboral';

  @override
  String get couldNotRemoveTiming => 'No se pudo eliminar el horario';

  @override
  String get manageStaffTitle => 'Gestionar personal';

  @override
  String get done => 'Listo';

  @override
  String get manageStaffSubtitle =>
      'Agrega, edita o elimina servicios y horarios, luego toca Listo.';

  @override
  String get saveStaffButton => 'Guardar personal';

  @override
  String get edit => 'Editar';

  @override
  String get delete => 'Eliminar';

  @override
  String get newServiceLabel => 'Nuevo servicio';

  @override
  String get addingEllipsis => 'Agregando...';

  @override
  String get addServiceButton => 'Agregar servicio';

  @override
  String get noTimingsYet => 'Aún no hay horarios';

  @override
  String get removeLabel => 'Eliminar';

  @override
  String get startLabel => 'Inicio';

  @override
  String get endLabel => 'Fin';

  @override
  String get addMonSatHoursButton => 'Agregar horario Lun-Sáb';

  @override
  String get saveHoursButton => 'Guardar horario';

  @override
  String get hhmmLowerHint => 'HH:mm';

  @override
  String get chooseStaffServiceDate => 'Elige personal, servicio y fecha';

  @override
  String get noSlotsForDate => 'No hay horarios disponibles para esta fecha.';

  @override
  String get couldNotLoadSlots => 'No se pudieron cargar los horarios';

  @override
  String get enterCustomerName => 'Ingresa el nombre del cliente';

  @override
  String get chooseStaffAndService => 'Elige personal y al menos un servicio';

  @override
  String get enterCustomerPhone => 'Ingresa el teléfono del cliente';

  @override
  String get chooseAvailableSlot => 'Elige un horario disponible';

  @override
  String get couldNotCreateBooking =>
      'No se pudo crear la reserva. Inténtalo de nuevo.';

  @override
  String get doneServiceOption => 'Servicio completado';

  @override
  String get scheduleLaterOption => 'Programar después';

  @override
  String get customerNameLabel => 'Nombre del cliente';

  @override
  String get customerPhoneLabel => 'Teléfono del cliente';

  @override
  String recordedNowDate(String date) {
    return 'Registrado ahora — $date';
  }

  @override
  String get dateLabel => 'Fecha';

  @override
  String get yyyymmddHint => 'AAAA-MM-DD';

  @override
  String get availableSlots => 'Horarios disponibles';

  @override
  String get cancel => 'Cancelar';

  @override
  String get saveBooking => 'Guardar reserva';

  @override
  String saveBookingWithTotal(String total) {
    return 'Guardar reserva · $total';
  }

  @override
  String get addServiceTitle => 'Agregar servicio';

  @override
  String get serviceNameLabel => 'Nombre del servicio';

  @override
  String get categoryLabel => 'Categoría';

  @override
  String get priceLabel => 'Precio';

  @override
  String get durationMinutesLabel => 'Duración (minutos)';

  @override
  String get deleteServiceButton => 'Eliminar servicio';

  @override
  String get fillServiceFields =>
      'Ingresa nombre, categoría, precio y duración';

  @override
  String get couldNotSaveService => 'No se pudo guardar el servicio';

  @override
  String get noServicesInCatalog => 'Aún no hay servicios. Agrega el primero.';

  @override
  String get searchServicesHint => 'Buscar servicios';

  @override
  String get filterAllCategories => 'Todos';

  @override
  String get assignToStaffLabel => 'Asignar a personal';

  @override
  String get anyStaffOption => 'Cualquier personal';

  @override
  String get addStarterServicesButton => 'Agregar servicios comunes';
}
