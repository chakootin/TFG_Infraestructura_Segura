<?php
/**
 * CONFIGURACIÓN INTEGRAL TFG - MICKY (ASIR 2025)
 * Conexión segura con Azure MySQL y Load Balancer.
 */

// 1. Detección de protocolo HTTPS tras el Load Balancer de Azure
if (isset($_SERVER['HTTP_X_FORWARDED_PROTO']) && $_SERVER['HTTP_X_FORWARDED_PROTO'] === 'https') {
    $_SERVER['HTTPS'] = 'on';
}

// 2. URLs de producción (Apunta al dominio del Load Balancer)
define('WP_HOME', 'https://tfg-seguro-micky.francecentral.cloudapp.azure.com');
define('WP_SITEURL', 'https://tfg-seguro-micky.francecentral.cloudapp.azure.com');

// 3. Configuración de la Base de Datos PaaS (Azure MySQL)
define( 'DB_NAME', 'wordpress_db' );
define( 'DB_USER', 'micky_admin' ); 
define( 'DB_PASSWORD', '%UW%DFcL&AAaFMNYMG' ); 
define( 'DB_HOST', 'tfg-mysql-micky.mysql.database.azure.com' ); 
define( 'DB_CHARSET', 'utf8' );
define( 'DB_COLLATE', '' );

// 4. SSL obligatorio para cumplir con la seguridad de Azure
define( 'MYSQL_CLIENT_FLAGS', MYSQLI_CLIENT_SSL );

// 5. Claves de seguridad únicas (Salts)
define('AUTH_KEY',         'tfg-micky-secure-key-01');
define('SECURE_AUTH_KEY',  'tfg-micky-secure-key-02');
define('LOGGED_IN_KEY',    'tfg-micky-secure-key-03');
define('NONCE_KEY',        'tfg-micky-secure-key-04');
define('AUTH_SALT',        'tfg-micky-secure-key-05');
define('SECURE_AUTH_SALT', 'tfg-micky-secure-key-06');
define('LOGGED_IN_SALT',   'tfg-micky-secure-key-07');
define('NONCE_SALT',       'tfg-micky-secure-key-08');

$table_prefix = 'wp_';
define( 'WP_DEBUG', false );

if ( ! defined( 'ABSPATH' ) ) {
	define( 'ABSPATH', __DIR__ . '/' );
}

require_once ABSPATH . 'wp-settings.php';
