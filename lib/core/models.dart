// ── Enums ────────────────────────────────────────────────────────────────────

enum UserRole { paciente, logopeda }

enum TipoVoz {
  esofagica('Voz esofágica', 'Vibración del segmento faringoesofágico'),
  electrolaringe('Electrolaringe', 'Dispositivo de vibración externo'),
  protesis('Prótesis traqueoesofágica', 'Válvula de voz');

  const TipoVoz(this.label, this.descripcion);
  final String label;
  final String descripcion;
}

enum NivelEjercicio {
  mono(1, 'monosílaba'),
  bi(2, 'bisílaba'),
  tri(3, 'trisílaba');

  const NivelEjercicio(this.numero, this.label);
  final int numero;
  final String label;
}

enum EstadoEjercicio { completado, siguiente, bloqueado }

// ── Modelos ──────────────────────────────────────────────────────────────────

class PerfilUsuario {
  final String nombre;
  final UserRole rol;
  final TipoVoz? tipoVoz;

  const PerfilUsuario({
    required this.nombre,
    required this.rol,
    this.tipoVoz,
  });

  PerfilUsuario copyWith({String? nombre, UserRole? rol, TipoVoz? tipoVoz}) =>
      PerfilUsuario(
        nombre: nombre ?? this.nombre,
        rol: rol ?? this.rol,
        tipoVoz: tipoVoz ?? this.tipoVoz,
      );
}

class Ejercicio {
  final String id;
  final String palabra;
  final NivelEjercicio nivel;
  final TipoVoz perfil;
  final int umbralExito; // porcentaje 0–100
  final String? urlVideoGuia;
  final String? instrucciones;

  const Ejercicio({
    required this.id,
    required this.palabra,
    required this.nivel,
    required this.perfil,
    this.umbralExito = 65,
    this.urlVideoGuia,
    this.instrucciones,
  });
}

class ResultadoIntento {
  final String ejercicioId;
  final int porcentaje;
  final String textoReconocido;
  final DateTime fecha;

  const ResultadoIntento({
    required this.ejercicioId,
    required this.porcentaje,
    required this.textoReconocido,
    required this.fecha,
  });

  int get estrellas {
    if (porcentaje >= 90) return 3;
    if (porcentaje >= 70) return 2;
    return 1;
  }
}

class Paciente {
  final String id;
  final String nombre;
  final String apellido;
  final TipoVoz tipoVoz;
  final NivelEjercicio nivelActual;
  final List<ResultadoIntento> historial;
  final bool activo;

  const Paciente({
    required this.id,
    required this.nombre,
    required this.apellido,
    required this.tipoVoz,
    required this.nivelActual,
    this.historial = const [],
    this.activo = true,
  });

  String get nombreCompleto => '$nombre $apellido';
  String get iniciales => '${nombre[0]}${apellido[0]}';

  double get tasaExito {
    if (historial.isEmpty) return 0;
    final suma = historial.fold<int>(0, (acc, r) => acc + r.porcentaje);
    return suma / historial.length;
  }

  int get sesionesEstaSemana {
    final ahora = DateTime.now();
    final inicioSemana = ahora.subtract(Duration(days: ahora.weekday - 1));
    return historial.where((r) => r.fecha.isAfter(inicioSemana)).length;
  }
}

// ── Mock data ─────────────────────────────────────────────────────────────────

class MockData {
  static final List<Ejercicio> ejercicios = [
    const Ejercicio(
      id: 'e1',
      palabra: 'pan',
      nivel: NivelEjercicio.mono,
      perfil: TipoVoz.esofagica,
      umbralExito: 65,
      instrucciones: 'Coloca los labios en posición neutra. Suelta el aire desde el esófago formando la "p" con suavidad.',
    ),
    const Ejercicio(
      id: 'e2',
      palabra: 'sol',
      nivel: NivelEjercicio.mono,
      perfil: TipoVoz.esofagica,
      umbralExito: 65,
      instrucciones: 'Relaja la mandíbula. Deja salir el aire suavemente mientras formas la "s".',
    ),
    const Ejercicio(
      id: 'e3',
      palabra: 'flor',
      nivel: NivelEjercicio.mono,
      perfil: TipoVoz.esofagica,
      umbralExito: 65,
      instrucciones: 'Coloca los labios como para soplar. Suelta el aire desde el esófago y forma la f rozando el labio inferior con los dientes.',
    ),
    const Ejercicio(
      id: 'e4',
      palabra: 'tren',
      nivel: NivelEjercicio.mono,
      perfil: TipoVoz.esofagica,
      umbralExito: 65,
      instrucciones: 'Apoya la lengua en el paladar. Suelta el aire con control.',
    ),
    const Ejercicio(
      id: 'e5',
      palabra: 'casa',
      nivel: NivelEjercicio.bi,
      perfil: TipoVoz.esofagica,
      umbralExito: 65,
      instrucciones: 'Suelta el aire y di ca-sa con calma.',
    ),
  ];

  static final List<Paciente> pacientes = [
    Paciente(
      id: 'p1',
      nombre: 'Adrián',
      apellido: 'M.',
      tipoVoz: TipoVoz.esofagica,
      nivelActual: NivelEjercicio.mono,
      activo: true,
      historial: [
        ResultadoIntento(ejercicioId: 'e1', porcentaje: 84, textoReconocido: 'pan', fecha: DateTime.now().subtract(const Duration(days: 1))),
        ResultadoIntento(ejercicioId: 'e1', porcentaje: 76, textoReconocido: 'pan', fecha: DateTime.now().subtract(const Duration(days: 2))),
        ResultadoIntento(ejercicioId: 'e1', porcentaje: 52, textoReconocido: 'ban', fecha: DateTime.now().subtract(const Duration(days: 3))),
      ],
    ),
    Paciente(
      id: 'p2',
      nombre: 'Carmen',
      apellido: 'R.',
      tipoVoz: TipoVoz.electrolaringe,
      nivelActual: NivelEjercicio.mono,
      activo: true,
      historial: [
        ResultadoIntento(ejercicioId: 'e2', porcentaje: 55, textoReconocido: 'sol', fecha: DateTime.now().subtract(const Duration(days: 1))),
      ],
    ),
    Paciente(
      id: 'p3',
      nombre: 'Jose',
      apellido: 'L.',
      tipoVoz: TipoVoz.protesis,
      nivelActual: NivelEjercicio.mono,
      activo: true,
      historial: [],
    ),
  ];
}