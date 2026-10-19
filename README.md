Implementación de usuarios, roles, permisos y carga de datos

Como parte de la implementación de la base de datos LubriCar en Oracle Cloud, se configuraron tres usuarios: `LUBRICAR`, `LUBRICAR_OPERADOR` y `LUBRICAR_CONSULTA`. El primero se estableció como propietario del esquema, mientras que los otros dos se utilizaron para controlar el acceso a la información mediante roles.

Se crearon los roles `ROL_LUBRICAR_OPERADOR` y `ROL_LUBRICAR_CONSULTA`, aplicando el principio de mínimo privilegio. Al operador se le concedieron permisos de consulta, inserción y actualización sobre las 12 tablas, mientras que al usuario de consulta únicamente se le permitió visualizar información.

Posteriormente, se realizó la carga de 1.000 registros ficticios distribuidos entre las 12 tablas mediante instrucciones SQL y bloques PL/SQL con ciclos `FOR`, respetando las relaciones establecidas en el modelo de datos.

Finalmente, se ejecutaron consultas de verificación que confirmaron la existencia de 12 claves primarias, 13 claves foráneas y 5 restricciones de unicidad, todas habilitadas. También se comprobaron los permisos de ambos usuarios mediante pruebas de operaciones permitidas y denegadas.

Los resultados permitieron verificar el funcionamiento de la estructura relacional, la carga de información y los controles de acceso implementados en Oracle.
