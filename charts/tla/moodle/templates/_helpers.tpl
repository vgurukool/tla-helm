{{/* Generate database env */}}
{{- define "moodle.db_env" -}}
- name: MOODLE_DB_HOST
  valueFrom:
    configMapKeyRef:
      name: moodle-database
      key: host
- name: MOODLE_DB_NAME
  valueFrom:
    configMapKeyRef:
      name: moodle-database
      key: name
- name: MOODLE_DB_USER
  valueFrom:
    configMapKeyRef:
      name: moodle-database
      key: user
- name: MOODLE_DATABASE_PASSWORD_FILE
  value: /run/secrets/moodle_database_password/password
{{- end -}}

{{- define "moodle.redis_env" -}}
{{- if $.Values.redis }}
- name: MOODLE_REDIS_HOST
  valueFrom:
    configMapKeyRef:
      name: moodle-redis
      key: host
- name: MOODLE_REDIS_PORT
  valueFrom:
    configMapKeyRef:
      name: moodle-redis
      key: port
{{- end }}
{{- end -}}

{{- define "moodle.http_env" -}}
- name: MOODLE_HTTP_HOST
  valueFrom:
    configMapKeyRef:
      name: moodle-config
      key: http_host
- name: MOODLE_HTTP_PORT
  valueFrom:
    configMapKeyRef:
      name: moodle-config
      key: http_port
- name: MOODLE_HTTP_SCHEME
  valueFrom:
    configMapKeyRef:
      name: moodle-config
      key: http_scheme
- name: MOODLE_REVERSE_PROXY
  value: {{ $.Values.http.reverse_proxy | quote }}
- name: MOODLE_SSL_PROXY
  value: {{ $.Values.http.ssl_proxy | quote }}
{{- end -}}

{{- define "moodle.image" -}}
image: {{ $.Values.image.registry }}/{{ $.Values.image.repository }}:{{ $.Values.image.tag }}
imagePullPolicy: {{ $.Values.image.pullPolicy | quote}}
{{- end -}}

{{- define "moodle.volume_db_secret" -}}
- name: database-password
  secret:
    secretName: {{ .Values.database.passwordSecretName }}
    items:
    - key: password
      path: password
{{- end -}}

{{- define "moodle.mount_db_secret" -}}
- name: database-password
  readOnly: true
  mountPath: /run/secrets/moodle_database_password
{{- end -}}

{{- define "moodle.volume_data" -}}
- name: moodle-v-data
  persistentVolumeClaim:
    claimName: {{ $.Values.data.pvc }}
{{- end -}}


{{- define "moodle.smtp_env" -}}
{{- if $.Values.smtp.host -}}
- name: MOODLE_SMTP_HOST
  valueFrom:
    configMapKeyRef:
      name: moodle-smtp
      key: host
- name: MOODLE_SMTP_PORT
  valueFrom:
    configMapKeyRef:
      name: moodle-smtp
      key: port
- name: MOODLE_SMTP_SECURITY
  valueFrom:
    configMapKeyRef:
      name: moodle-smtp
      key: security
- name: MOODLE_SMTP_AUTH_MODE
  valueFrom:
    configMapKeyRef:
      name: moodle-smtp
      key: auth_mode
- name: MOODLE_SMTP_USER
  valueFrom:
    configMapKeyRef:
      name: moodle-smtp
      key: user
{{- end -}}
{{- end -}}