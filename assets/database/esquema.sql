CREATE TABLE usuaris (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nom VARCHAR(50) NOT NULL,
    cognoms VARCHAR(100) NOT NULL,
    correu_institucional VARCHAR(100) UNIQUE, 
    correu_personal VARCHAR(100),
    contrasenya_hash VARCHAR(255) NOT NULL,  -- Contraseña ahora obligatoria para todos
    estat ENUM('actiu', 'pendent', 'suspès') DEFAULT 'actiu',
    rol ENUM('admin', 'adminEscola', 'alumne', 'visitant') NOT NULL,

    -- Restricción: contraseña obligatoria para todos los roles
    CONSTRAINT chk_contrasenya_requerida 
        CHECK (contrasenya_hash IS NOT NULL),
    
    -- Restricción: correo institucional requerido solo para roles no visitantes
    CONSTRAINT chk_correu_requerit 
        CHECK (
            (rol IN ('admin', 'adminEscola', 'alumne') AND correu_institucional IS NOT NULL)
            OR 
            (rol = 'visitant' AND correu_institucional IS NULL)
        ),
    
    -- Restricción UNIQUE para correos institucionales y personales
    CONSTRAINT unique_email UNIQUE (correu_institucional, correu_personal)
);
