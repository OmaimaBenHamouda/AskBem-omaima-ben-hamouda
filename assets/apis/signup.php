<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);

// 💡 Habilitar CORS antes de cualquier salida
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");
header("Content-Type: application/json; charset=UTF-8");

// Manejar solicitudes OPTIONS (preflight)
if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
    http_response_code(200);
    exit();
}

require '../../vendor/autoload.php';
use Firebase\JWT\JWT;

$host = 'localhost';  // Cambia a la dirección de tu servidor
$dbname = 'askbem';
$username = 'omaimaben';
$password = 'askbem-omaima';
$secret_key = "b3m3n3!S3cur3_K3y_2025";  // 🔐 Clave para firmar el token

try {
    // Conectar a la base de datos
    $conn = new PDO("mysql:host=$host;dbname=$dbname", $username, $password);
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

    // Recibir los datos del frontend
    $data = json_decode(file_get_contents("php://input"));

    if (!$data) {
        echo json_encode(["message" => "Datos inválidos"]);
        exit();
    }

    // Obtener datos del usuario
    $nom = $data->nom ?? null;
    $cognoms = $data->cognoms ?? null;
    $correu = $data->correu ?? null;
    $contrasenya = $data->contrasenya ?? null;

    // Validaciones
    if (!$nom || !$cognoms) {
        echo json_encode(["message" => "Nombre y/o apellidos son requeridos."]);
        exit();
    }

    if (!$correu || !filter_var($correu, FILTER_VALIDATE_EMAIL)) {
        echo json_encode(["message" => "Correo electrónico no válido."]);
        exit();
    }

    if (!$contrasenya) {
        echo json_encode(["message" => "Contraseña es requerida."]);
        exit();
    }

    // Verificar si el correo ya está registrado
    $stmt = $conn->prepare("SELECT COUNT(*) FROM usuaris WHERE correu_institucional = :correu OR correu_personal = :correu");
    $stmt->bindParam(':correu', $correu);
    $stmt->execute();
    $existe = $stmt->fetchColumn();

    if ($existe > 0) {
        echo json_encode(["message" => "El correo ya está registrado."]);
        exit();
    }

    // Hashear la contraseña
    $contrasenya_hash = password_hash($contrasenya, PASSWORD_BCRYPT);

    // Determinar si es un correo institucional
    $is_institutional_email = strpos($correu, '@bemen3.cat') !== false;
    $rol = $is_institutional_email ? 'alumne' : 'visitant';

    // Insertar los datos del usuario en la base de datos
    $stmt = $conn->prepare("INSERT INTO usuaris (nom, cognoms, correu_institucional, correu_personal, contrasenya_hash, rol) 
                            VALUES (?, ?, ?, ?, ?, ?)");
    $stmt->execute([$nom, $cognoms, $is_institutional_email ? $correu : null, !$is_institutional_email ? $correu : null, $contrasenya_hash, $rol]);

    // 🔥 Generar Token JWT
    $payload = [
        "id" => $conn->lastInsertId(),
        "nom" => $nom,
        "cognoms" => $cognoms,
        "correu" => $correu,
        "rol" => $rol,
        "iat" => time(),
        "exp" => time() + (60 * 60) // Expira en 1 hora
    ];
    $token = JWT::encode($payload, $secret_key, 'HS256');

    // Responder con el token JWT
    echo json_encode([
        "message" => "Usuario registrado exitosamente",
        "token" => $token
    ]);

} catch (PDOException $e) {
    echo json_encode(["message" => "Error en la base de datos", "error" => $e->getMessage()]);
}
?>
