<?php
require_once '../config/auth.php';

// Solo permite a 'anfitrion' (y 'admin' si quieres que el admin pueda ver esa sección)
enforce_role_access(['anfitrion', 'admin']); 

// El código de mis propiedades continúa aquí...