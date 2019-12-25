# Systemd Timer for Temp directories

Se manejan ciertos directorios para que constantemente se estén
borrando sus contenidos, mediante systemd timers.

Los archivos van en:
* .tmp_dir --> home
* tmp_dir.service --> /etc/systemd/system/tmp_dir.service
* tmp_dir.timer --> /etc/systemd/system/tmp_dir.timer

Para activar el timer:
* systemctl daemon-reload (detecta las nuevas unidades y servicios)
* systemctl enable tmp_dir.timer
