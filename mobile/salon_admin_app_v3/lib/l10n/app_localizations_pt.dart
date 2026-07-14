// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get insightsTitle => 'Insights';

  @override
  String get tabEarnings => 'Ganhos';

  @override
  String get tabRetention => 'Retenção';

  @override
  String get periodToday => 'Hoje';

  @override
  String get periodWeek => 'Semana';

  @override
  String get periodMonth => 'Mês';

  @override
  String get periodLast7Days => 'Últimos 7 dias';

  @override
  String get periodLast30Days => 'Últimos 30 dias';

  @override
  String get earningsLoadError => 'Não foi possível carregar os ganhos.';

  @override
  String get retry => 'Tentar novamente';

  @override
  String completedServicesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count serviços',
      one: '$count serviço',
    );
    return '$_temp0';
  }

  @override
  String get completedServicesHeading => 'Serviços concluídos';

  @override
  String get noCompletedServices =>
      'Ainda não há serviços concluídos neste período.';

  @override
  String get topServicesHeading => 'Principais serviços';

  @override
  String get byStaffHeading => 'Por funcionário';

  @override
  String get vsYesterday => 'vs ontem';

  @override
  String get vsLastWeek => 'vs semana passada';

  @override
  String get vsLastMonth => 'vs mês passado';

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
      other: '$count clientes voltaram este mês',
      one: '$count cliente voltou este mês',
    );
    return '$_temp0';
  }

  @override
  String customerServicePair(String customer, String service) {
    return '$customer · $service';
  }

  @override
  String get retentionLoadError =>
      'Não foi possível carregar o relatório de retenção.';

  @override
  String get couldNotOpenWhatsapp => 'Não foi possível abrir o WhatsApp';

  @override
  String whatsappReminderMessage(String name, String salonName) {
    return 'Olá $name! Sentimos sua falta no $salonName. Agende sua próxima visita e aproveite uma oferta especial de boas-vindas. Até breve!';
  }

  @override
  String get customerCohortsHeading => 'Grupos de clientes';

  @override
  String cohortMembersLabel(String label, int count) {
    return '$label · $count clientes';
  }

  @override
  String noCohortCustomers(String label) {
    return 'Nenhum cliente $label neste período.';
  }

  @override
  String get missedCustomersHeading => 'Clientes perdidos';

  @override
  String get missedCustomersHint =>
      'Toque em \"Lembrar\" para enviar uma mensagem pelo WhatsApp.';

  @override
  String get noMissedCustomers => 'Nenhum cliente perdido este mês.';

  @override
  String get cohortRegulars => 'Frequentes';

  @override
  String get cohortNew => 'Novos';

  @override
  String get cohortCameBack => 'Voltaram';

  @override
  String get cohortStoppedComing => 'Pararam de vir';

  @override
  String get customersLabel => 'clientes';

  @override
  String get reachOutNow => 'Entre em contato agora';

  @override
  String atRiskSummary(int count, String revenue) {
    return '$count clientes frequentes estão sumindo · $revenue em risco';
  }

  @override
  String overdueBadge(String ratio) {
    return '$ratio× atrasado';
  }

  @override
  String cadenceOverdue(String cadence, String overdue) {
    return 'Normalmente a cada ${cadence}d · ${overdue}d de atraso';
  }

  @override
  String get remind => 'Lembrar';

  @override
  String get remindOnWhatsappTooltip => 'Lembrar pelo WhatsApp';

  @override
  String get retentionProTitle => 'Insights de retenção são um recurso PRO';

  @override
  String get retentionProBody =>
      'Veja quem parou de vir, sua proporção de clientes novos e recorrentes, e recupere clientes perdidos com lembretes de um toque.';

  @override
  String get upgradeToPro => 'Atualizar para PRO';

  @override
  String visitsSpentSummary(int visits, String spend) {
    return '$visits visitas · gasto $spend';
  }

  @override
  String get createYourAccount => 'Crie sua conta';

  @override
  String get basics => 'Informações básicas';

  @override
  String get country => 'País';

  @override
  String get countryHelperText =>
      'Define sua moeda, formato de telefone e idioma padrão.';

  @override
  String get language => 'Idioma';

  @override
  String get phoneNumberLabel => 'Número de telefone';

  @override
  String get passwordLabel => 'Senha';

  @override
  String stepOfTotal(int step, int total) {
    return 'Passo $step de $total';
  }

  @override
  String get createAccountButton => 'Criar conta';

  @override
  String get continueButton => 'Continuar';

  @override
  String get enterPhoneNumber => 'Digite um número de telefone';

  @override
  String get passwordMinLength => 'A senha deve ter pelo menos 6 caracteres';

  @override
  String get fillOwnerSalonAddress =>
      'Preencha o nome do proprietário, do salão e o endereço';

  @override
  String get turnOnLocationPermission =>
      'Ative a localização e permita o acesso para usar isso';

  @override
  String get couldNotGetLocation => 'Não foi possível obter sua localização';

  @override
  String get phoneAlreadyRegisteredSignIn =>
      'Este telefone já está registrado. Faça login em vez disso.';

  @override
  String get signupFailedCheckBackend =>
      'Falha no cadastro. Verifique a conexão com o servidor.';

  @override
  String get signupFailedTryAgain => 'Falha no cadastro. Tente novamente.';

  @override
  String get yourSalon => 'Seu salão';

  @override
  String get salonDetailsSubtitle => 'Passo 2 de 3 · Detalhes do salão';

  @override
  String get ownerNameLabel => 'Nome do proprietário';

  @override
  String get salonNameLabel => 'Nome do salão';

  @override
  String get salonAddressLabel => 'Endereço do salão';

  @override
  String get locationSet => 'Localização definida';

  @override
  String get useMyCurrentLocation => 'Usar minha localização atual';

  @override
  String get pickYourColor => 'Escolha sua cor';

  @override
  String get colorPreviewHelp =>
      'Esta é a cor de destaque do seu salão em todo o app. Altere quando quiser em Conta.';

  @override
  String get previewLabel => 'Pré-visualização';

  @override
  String get newBooking => 'Novo agendamento';

  @override
  String get colorTeal => 'Verde-azulado';

  @override
  String get colorTerracotta => 'Terracota';

  @override
  String get colorBlue => 'Azul';

  @override
  String get colorViolet => 'Violeta';

  @override
  String get colorRose => 'Rosa';

  @override
  String get welcomeBack => 'Bem-vindo de volta';

  @override
  String get signInToDashboard => 'Entre no painel do seu salão';

  @override
  String get enterSalonOwnerPhone =>
      'Digite o telefone do proprietário do salão';

  @override
  String get enterYourPassword => 'Digite sua senha';

  @override
  String get noSalonOwnerFound =>
      'Nenhuma conta de proprietário de salão encontrada para este telefone.';

  @override
  String get loginFailedCheckBackend =>
      'Falha no login. Verifique a conexão com o servidor.';

  @override
  String get loginFailedTryAgain => 'Falha no login. Tente novamente.';

  @override
  String get hidePassword => 'Ocultar senha';

  @override
  String get showPassword => 'Mostrar senha';

  @override
  String get signIn => 'Entrar';

  @override
  String get newHere => 'Novo por aqui?';

  @override
  String get createAccount => 'Criar conta';

  @override
  String get forgotPassword => 'Esqueceu a senha?';

  @override
  String get resetPasswordTitle => 'Redefinir senha';

  @override
  String get resetPasswordEnterPhone =>
      'Digite seu número de telefone e enviaremos um código de 6 dígitos pelo WhatsApp.';

  @override
  String get sendCodeViaWhatsApp => 'Enviar código pelo WhatsApp';

  @override
  String get codeSentViaWhatsApp =>
      'Se essa conta existir, um código foi enviado pelo WhatsApp.';

  @override
  String get resetPasswordEnterCode =>
      'Digite o código que enviamos pelo WhatsApp e escolha uma nova senha.';

  @override
  String get otpCodeLabel => 'Código de 6 dígitos';

  @override
  String get resetPasswordButton => 'Redefinir senha';

  @override
  String get resendCode => 'Reenviar código';

  @override
  String get changePhoneNumber => 'Alterar número de telefone';

  @override
  String get enterSixDigitCode => 'Digite o código de 6 dígitos';

  @override
  String get passwordsDoNotMatch => 'As senhas não coincidem';

  @override
  String get passwordResetSuccess =>
      'Senha redefinida. Faça login com sua nova senha.';

  @override
  String get waitBeforeRetryingCode =>
      'Aguarde um minuto antes de solicitar outro código';

  @override
  String get invalidOrExpiredCode => 'Esse código é inválido ou expirou';

  @override
  String get tooManyAttemptsRequestNewCode =>
      'Muitas tentativas — solicite um novo código';

  @override
  String get continueWithGoogle => 'Continuar com o Google';

  @override
  String get signedInWithGoogle => 'Conectado com o Google';

  @override
  String signedInWithGoogleAs(String email) {
    return 'Conectado com o Google como $email';
  }

  @override
  String get usePasswordInstead => 'Usar senha em vez disso';

  @override
  String get googleSignInNotConfigured =>
      'O login com Google ainda não foi configurado';

  @override
  String get googleSignInFailed =>
      'Falha no login com Google. Tente novamente.';

  @override
  String get googleNoAccountFound =>
      'Nenhuma conta encontrada para essa conta do Google. Crie uma primeiro.';

  @override
  String get linkGoogleAccount => 'Vincular conta do Google';

  @override
  String get googleAccountLinked =>
      'Conta do Google vinculada — agora você pode entrar com ela';

  @override
  String get addStaffBeforeBookings =>
      'Adicione funcionários ativos antes de criar agendamentos';

  @override
  String get salonLabel => 'Salão';

  @override
  String get statToday => 'Hoje';

  @override
  String get statRepeat => 'Recorrentes';

  @override
  String get statLoggedHelper => 'registrados';

  @override
  String get statBackHelper => 'retornaram';

  @override
  String get statWeek => 'Semana';

  @override
  String get statMonth => 'Mês';

  @override
  String get loggedTodayHeading => 'Registrado hoje';

  @override
  String get nothingLoggedToday =>
      'Nada registrado hoje ainda. Toque em \"Novo agendamento\" quando um serviço for concluído.';

  @override
  String get navHome => 'Início';

  @override
  String get navBookings => 'Agendamentos';

  @override
  String get navStaff => 'Funcionários';

  @override
  String get navInsights => 'Insights';

  @override
  String get navAccount => 'Conta';

  @override
  String get salonAdminTitle => 'Salon Admin';

  @override
  String get noSalonLinked =>
      'Ainda não há nenhum salão vinculado a esta conta de proprietário.';

  @override
  String get bookingsTitle => 'Agendamentos';

  @override
  String get searchCustomerOrService => 'Buscar cliente ou serviço';

  @override
  String get filterThisWeek => 'Esta semana';

  @override
  String get filterAllTime => 'Todo o período';

  @override
  String get filterAllStaff => 'Todos os funcionários';

  @override
  String get staffLabel => 'Funcionários';

  @override
  String get needsActionHeading => 'Requer ação';

  @override
  String get statTotal => 'Total';

  @override
  String get statServices => 'Serviços';

  @override
  String get statAvgTicket => 'Ticket médio';

  @override
  String get noBookingsMatchFilter =>
      'Nenhum agendamento corresponde a este filtro';

  @override
  String get today => 'Hoje';

  @override
  String get yesterday => 'Ontem';

  @override
  String dayTotalServices(String total, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count serviços',
      one: '$count serviço',
    );
    return '$total · $_temp0';
  }

  @override
  String get couldNotOpenStore => 'Não foi possível abrir a loja';

  @override
  String get updateRequired => 'Atualização necessária';

  @override
  String get updateRequiredBody =>
      'Uma nova versão do app está disponível. Atualize para continuar usando o painel do seu salão.';

  @override
  String get updateNow => 'Atualizar agora';

  @override
  String get themeColorTitle => 'Cor do tema';

  @override
  String get save => 'Salvar';

  @override
  String get staffTitle => 'Funcionários';

  @override
  String get addStaff => 'Adicionar funcionário';

  @override
  String get statActive => 'Ativos';

  @override
  String get statTodaysTotal => 'Total de hoje';

  @override
  String get noActiveStaffYet => 'Ainda não há funcionários ativos';

  @override
  String get addFirstStaff => 'Adicionar primeiro funcionário';

  @override
  String get noServicesYet => 'Ainda não há serviços';

  @override
  String get notActive => 'Não ativo';

  @override
  String get canSetOwnPrice => 'Pode definir o próprio preço';

  @override
  String staffTodayTally(int count, String revenue) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count serviços',
      one: '$count serviço',
    );
    return '$_temp0 · $revenue';
  }

  @override
  String get newLabel => 'Novo';

  @override
  String get serviceLabel => 'Serviço';

  @override
  String get customerLabel => 'Cliente';

  @override
  String get repeatLabel => 'Recorrente';

  @override
  String get couldNotUpdateBooking =>
      'Não foi possível atualizar o agendamento. Tente novamente.';

  @override
  String get couldNotAcceptReschedule =>
      'Não foi possível aceitar o reagendamento. Tente novamente.';

  @override
  String get couldNotRejectReschedule =>
      'Não foi possível recusar o reagendamento. Tente novamente.';

  @override
  String get rescheduleLabel => 'Reagendar';

  @override
  String get pendingLabel => 'Pendente';

  @override
  String customerWithStylist(String customer, String stylist) {
    return '$customer com $stylist';
  }

  @override
  String customerRequestedTime(String time) {
    return 'Cliente solicitou $time';
  }

  @override
  String get reject => 'Recusar';

  @override
  String get accept => 'Aceitar';

  @override
  String get confirm => 'Confirmar';

  @override
  String plusMoreServices(String first, int count) {
    return '$first + $count mais';
  }

  @override
  String twoServicesJoin(String a, String b) {
    return '$a + $b';
  }

  @override
  String get couldNotLoadAccount =>
      'Não foi possível carregar os detalhes da conta';

  @override
  String get fillOwnerPhoneSalonAddress =>
      'Preencha proprietário, telefone, nome do salão e endereço';

  @override
  String get accountUpdated => 'Conta atualizada';

  @override
  String get phoneOrEmailUsed => 'Telefone ou e-mail já está em uso';

  @override
  String get couldNotSaveAccount =>
      'Não foi possível salvar os detalhes da conta';

  @override
  String get newPasswordMinLength =>
      'A nova senha deve ter pelo menos 6 caracteres';

  @override
  String get newPasswordsDontMatch => 'As novas senhas não coincidem';

  @override
  String get passwordChanged => 'Senha alterada';

  @override
  String get currentPasswordIncorrect => 'A senha atual está incorreta';

  @override
  String get couldNotChangePassword => 'Não foi possível alterar a senha';

  @override
  String get countryAndCurrency => 'País e moeda';

  @override
  String get accountTitle => 'Conta';

  @override
  String ownerSinceDate(String date) {
    return 'Proprietário desde $date';
  }

  @override
  String planLabel(String plan) {
    return 'Plano $plan';
  }

  @override
  String get retentionFreeFor6Months =>
      'Insights de retenção grátis por 6 meses';

  @override
  String get upgrade => 'Atualizar';

  @override
  String get appearance => 'Aparência';

  @override
  String get salonProfile => 'Perfil do salão';

  @override
  String get emailLabel => 'E-mail';

  @override
  String get locationUpdated => 'Localização atualizada';

  @override
  String get saveDetailsButton => 'Salvar detalhes';

  @override
  String get savingEllipsis => 'Salvando...';

  @override
  String get security => 'Segurança';

  @override
  String get currentPasswordLabel => 'Senha atual';

  @override
  String get newPasswordLabel => 'Nova senha';

  @override
  String get confirmNewPasswordLabel => 'Confirmar nova senha';

  @override
  String get changePasswordButton => 'Alterar senha';

  @override
  String get changingEllipsis => 'Alterando...';

  @override
  String get signOut => 'Sair';

  @override
  String get enterServiceNamePrice => 'Digite o nome e o preço do serviço';

  @override
  String get fillStaffNamePhone =>
      'Preencha o nome e o telefone do funcionário';

  @override
  String get addAtLeastOneService => 'Adicione pelo menos um serviço';

  @override
  String get enterValidOpenCloseTimes =>
      'Digite horários válidos de abertura e fechamento (HH:MM, 24 horas)';

  @override
  String get selectAtLeastOneWorkingDay =>
      'Selecione pelo menos um dia de trabalho';

  @override
  String get staffPhoneInUse => 'Esse telefone de funcionário já está em uso';

  @override
  String get couldNotAddStaff =>
      'Não foi possível adicionar o funcionário. Tente novamente.';

  @override
  String get addStaffSubtitle =>
      'Configure o perfil, os serviços e os dias de trabalho.';

  @override
  String get staffNameLabel => 'Nome do funcionário';

  @override
  String get staffPhoneLabel => 'Telefone do funcionário';

  @override
  String get servicesLabel => 'Serviços';

  @override
  String servicesAddedCount(int count) {
    return '$count adicionados';
  }

  @override
  String get workingHours => 'Horário de trabalho';

  @override
  String get opens => 'Abre';

  @override
  String get closes => 'Fecha';

  @override
  String get hhmmHint => 'HH:MM';

  @override
  String get workingDays => 'Dias de trabalho';

  @override
  String get serviceNameHint => 'Nome do serviço';

  @override
  String get priceHint => 'Preço';

  @override
  String get dayMon => 'Seg';

  @override
  String get dayTue => 'Ter';

  @override
  String get dayWed => 'Qua';

  @override
  String get dayThu => 'Qui';

  @override
  String get dayFri => 'Sex';

  @override
  String get daySat => 'Sáb';

  @override
  String get daySun => 'Dom';

  @override
  String get enterValidStaffNamePhone =>
      'Digite um nome e telefone válidos do funcionário';

  @override
  String get staffDetailsSaved => 'Detalhes do funcionário salvos';

  @override
  String get phoneAlreadyInUse => 'Esse telefone já está em uso';

  @override
  String get couldNotUpdateStaff => 'Não foi possível atualizar o funcionário';

  @override
  String get enterServiceNameAndPriceShort =>
      'Digite o nome e o preço do serviço';

  @override
  String get couldNotAddService => 'Não foi possível adicionar o serviço';

  @override
  String get editServiceTitle => 'Editar serviço';

  @override
  String get enterValidServiceNamePrice =>
      'Digite um nome e preço de serviço válidos';

  @override
  String get couldNotUpdateService => 'Não foi possível atualizar o serviço';

  @override
  String get saveServiceButton => 'Salvar serviço';

  @override
  String get couldNotRemoveServiceDefault =>
      'Não foi possível remover o serviço';

  @override
  String get useHHmmWorkingHours => 'Use HH:mm para o horário de trabalho';

  @override
  String get hoursAdded => 'Horário adicionado';

  @override
  String get couldNotAddWorkingHours =>
      'Não foi possível adicionar o horário de trabalho';

  @override
  String get couldNotRemoveTiming => 'Não foi possível remover o horário';

  @override
  String get manageStaffTitle => 'Gerenciar funcionário';

  @override
  String get done => 'Concluído';

  @override
  String get manageStaffSubtitle =>
      'Adicione, edite ou remova serviços e horários, depois toque em Concluído.';

  @override
  String get saveStaffButton => 'Salvar funcionário';

  @override
  String get edit => 'Editar';

  @override
  String get delete => 'Excluir';

  @override
  String get newServiceLabel => 'Novo serviço';

  @override
  String get addingEllipsis => 'Adicionando...';

  @override
  String get addServiceButton => 'Adicionar serviço';

  @override
  String get noTimingsYet => 'Ainda não há horários';

  @override
  String get removeLabel => 'Remover';

  @override
  String get startLabel => 'Início';

  @override
  String get endLabel => 'Fim';

  @override
  String get addMonSatHoursButton => 'Adicionar horário Seg-Sáb';

  @override
  String get saveHoursButton => 'Salvar horário';

  @override
  String get hhmmLowerHint => 'HH:mm';

  @override
  String get chooseStaffServiceDate => 'Escolha funcionário, serviço e data';

  @override
  String get noSlotsForDate => 'Nenhum horário disponível para esta data.';

  @override
  String get couldNotLoadSlots => 'Não foi possível carregar os horários';

  @override
  String get enterCustomerName => 'Digite o nome do cliente';

  @override
  String get chooseStaffAndService =>
      'Escolha o funcionário e pelo menos um serviço';

  @override
  String get enterCustomerPhone => 'Digite o telefone do cliente';

  @override
  String get chooseAvailableSlot => 'Escolha um horário disponível';

  @override
  String get couldNotCreateBooking =>
      'Não foi possível criar o agendamento. Tente novamente.';

  @override
  String get doneServiceOption => 'Serviço concluído';

  @override
  String get scheduleLaterOption => 'Agendar para depois';

  @override
  String get customerNameLabel => 'Nome do cliente';

  @override
  String get customerPhoneLabel => 'Telefone do cliente';

  @override
  String recordedNowDate(String date) {
    return 'Registrado agora — $date';
  }

  @override
  String get dateLabel => 'Data';

  @override
  String get yyyymmddHint => 'AAAA-MM-DD';

  @override
  String get availableSlots => 'Horários disponíveis';

  @override
  String get cancel => 'Cancelar';

  @override
  String get saveBooking => 'Salvar agendamento';

  @override
  String saveBookingWithTotal(String total) {
    return 'Salvar agendamento · $total';
  }
}
