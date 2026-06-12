-- ══════════════════════════════════════════════════════════════════
--  USUARIOS DE PRUEBA — ejecuta esto en pgAdmin Query Tool
--  Contraseña para ambos: test1234
--  Hash bcrypt generado con cost 12
-- ══════════════════════════════════════════════════════════════════

-- Logopeda de prueba
INSERT INTO users (id, email, password_hash, name, role, role_set, created_at)
VALUES (
  gen_random_uuid(),
  'logopeda@test.com',
  '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBPj/o8pX2Z8Ii',
  'Dra. García',
  'logopeda',
  true,
  NOW()
)
ON CONFLICT (email) DO NOTHING;

-- Paciente de prueba
INSERT INTO users (id, email, password_hash, name, role, role_set, voice_type, current_level, streak_days, created_at)
VALUES (
  gen_random_uuid(),
  'paciente@test.com',
  '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBPj/o8pX2Z8Ii',
  'Adrián Molina',
  'patient',
  true,
  'esofagico',
  1,
  3,
  NOW()
)
ON CONFLICT (email) DO NOTHING;

-- Verificar que se crearon
SELECT id, email, name, role, role_set FROM users
WHERE email IN ('logopeda@test.com', 'paciente@test.com');
