// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Buy For Me';

  @override
  String get welcomeMessage =>
      'Bienvenido a la aplicación de compras inteligente';

  @override
  String get emailLabel => 'Correo electrónico';

  @override
  String get passwordLabel => 'Contraseña';

  @override
  String get loginButton => 'Iniciar sesión';

  @override
  String get signUpButton => 'Crear nueva cuenta';

  @override
  String get emailPasswordRequired =>
      'Por favor, ingrese su correo electrónico y contraseña';

  @override
  String get signUpSuccess =>
      '¡Cuenta creada exitosamente! Ahora puede iniciar sesión.';

  @override
  String get unexpectedError => 'Ocurrió un error inesperado';

  @override
  String get errorPrefix => 'Error:';

  @override
  String get roleSelectionTitle => 'Bienvenido a\nBUY FOR ME';

  @override
  String get roleSelectionSubtitle =>
      'Elija su identidad para empezar a comprar o vender';

  @override
  String get customerRole => 'Soy un Cliente';

  @override
  String get customerRoleDesc => 'Busco tiendas y quiero comprar productos';

  @override
  String get merchantRole => 'Soy un Comerciante';

  @override
  String get merchantRoleDesc => 'Tengo una tienda y quiero vender productos';

  @override
  String get merchantSetupTitle => 'Configurar Tienda';

  @override
  String get merchantSetupGreeting =>
      '¡Bienvenido, Comerciante!\nConfiguremos su tienda para empezar a recibir pedidos.';

  @override
  String get storeImage => 'Imagen de la tienda';

  @override
  String get takePhoto => 'Tomar una foto de su tienda';

  @override
  String get storeName => 'Nombre de la tienda';

  @override
  String get storeNameHint => 'Ingrese el nombre de su tienda aquí...';

  @override
  String get ripLabel => 'Número de Cuenta RIP';

  @override
  String get ripHint => 'Ejemplo: 00799999000123456789';

  @override
  String get categoryLabel => 'Identifique su categoría comercial';

  @override
  String get categoryHint => 'Elija la actividad principal...';

  @override
  String get nextButton => 'Siguiente';

  @override
  String get fillAllFields => 'Por favor, complete todos los campos';

  @override
  String get productsTab => 'Productos';

  @override
  String get ordersTab => 'Pedidos';

  @override
  String get searchHint => 'Buscar tiendas cercanas...';

  @override
  String get nearbyStores => 'Tiendas disponibles cercanas';

  @override
  String distanceKm(String distance) {
    return '$distance km';
  }

  @override
  String confirmOrder(String count) {
    return 'Confirmar Pedido ($count)';
  }

  @override
  String get addToCart => 'Añadir';

  @override
  String get rateStore => 'Calificar tienda ahora:';

  @override
  String get submitRating => 'Enviar calificación';

  @override
  String get ratingPrompt => '¿Cuál es su calificación para esta tienda?';

  @override
  String get waitingStatus => 'Esperando';

  @override
  String get deliveryType => 'Entrega';

  @override
  String get pickupType => 'Recogida';

  @override
  String get catGrocery => 'Abarrotes Generales';

  @override
  String get catFruitVeg => 'Frutas y Verduras';

  @override
  String get catBakery => 'Panadería';

  @override
  String get catButchery => 'Carnicería';

  @override
  String get catCleaning => 'Productos de Limpieza';

  @override
  String get catOther => 'Otro';

  @override
  String get pickFromCamera => 'Tomar una foto con la cámara';

  @override
  String get pickFromGallery => 'Elegir de la galería';

  @override
  String get deletePhoto => 'Eliminar foto';

  @override
  String get noStoresNearby => 'No hay tiendas cercanas en este momento';

  @override
  String get viewAll => 'Todo';

  @override
  String get ratingSuccess => 'تم إرسال التقييم بنجاح! شكرًا لك.';

  @override
  String get signInButton => 'Iniciar sesión';

  @override
  String get noAccount => '¿No tienes una cuenta?';

  @override
  String get jobSeekerRole => 'Buscar Trabajo';

  @override
  String get jobSeekerRoleDesc =>
      'Buscando oportunidades de trabajo en tiendas disponibles';

  @override
  String get storeLocationOnMap => 'موقع المتجر على الخريطة';
}
