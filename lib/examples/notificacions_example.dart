class NotificacionsExample {
  final String type;
  final String? place;
  final String brand;
  final String status;
  final String message;

  NotificacionsExample({
    required this.type,
    this.place,
    required this.brand,
    required this.status,
    required this.message,
  });
}

List<NotificacionsExample> allNotifications = [
  NotificacionsExample(
      type: 'pedido',
      brand: 'ama de casa',
      status: 'Completada',
      message: 'Pedido completado!'),
  NotificacionsExample(
      type: 'visita',
      brand: 'ama de casa',
      status: 'Pendiente',
      message: 'Tienes una visita pronto',
      place: 'c.c. orinokia, local 59'),
  NotificacionsExample(
      type: 'pedido',
      brand: 'ama de casa',
      status: 'Pendiente',
      message: 'Tienes un pedido en proceso'),
  NotificacionsExample(
      type: 'visita',
      brand: 'ama de casa',
      status: 'Completada',
      message: 'Visita Completada',
      place: 'c.c. orinokia, local 59'),
  NotificacionsExample(
      type: 'pedido',
      brand: 'ama de casa',
      status: 'Pendiente',
      message: 'Tienes un pedido en proceso'),
  NotificacionsExample(
    type: 'visita',
    brand: 'ama de casa',
    status: 'Cancelada',
    message: 'Visita cancaelada',
  ),
  NotificacionsExample(
      type: 'pedido',
      brand: 'ama de casa',
      status: 'Cancelada',
      message: 'Pedido cancelado'),
];
