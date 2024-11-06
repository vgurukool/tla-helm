{{/*
Env vars list follows Docker Compose example at
https://github.com/indico/indico-containers/blob/master/indico.env.sample
*/}}
{{- define "indico.env" -}}
- name: INDICO_DEBUG
  value: "{{ .Values.indico.debug}}"
- name: C_FORCE_ROOT
  value: "True"
- name: PGHOST
  value: "{{ .Values.postgresql.fullnameOverride }}"
- name: PGUSER
  value: "{{ .Values.postgresql.auth.username }}"
- name: PGDATABASE
  value: "{{ .Values.postgresql.auth.database }}"
- name: PGPORT
  value: "5432"
- name: PGPASSWORD
  valueFrom:
    secretKeyRef:
      name: indico-secrets
      key: postgres-password
- name: INDICO_SECRET_KEY
  valueFrom:
    secretKeyRef:
      name: indico-secrets
      key: secret-key
- name: SERVICE_PROTOCOL
  value: "https"
- name: SERVICE_HOSTNAME
  value: "{{ .Values.indico.ingress.host }}"
- name: INDICO_BASE_URL
  value: "{{ .Values.indico.protocol }}://{{ .Values.indico.ingress.host }}"
- name: INDICO_SERVICE_PORT
  value: "{{ .Values.indico.service.port }}"
- name: INDICO_USE_PROXY
  value: "{{ .Values.indico.useProxy }}"
- name: INDICO_REDIS_CACHE_URL
  value: "redis://{{ .Values.indico.redisCacheBaseUrl }}:6379/0"
- name: INDICO_SMTP_SERVER
  value: "{{ .Values.indico.email.smtp.server }}"
- name: INDICO_SMTP_PORT
  value: "{{ .Values.indico.email.smtp.port }}"
- name: INDICO_SUPPORT_EMAIL
  value: "{{ .Values.indico.email.support }}"
- name: INDICO_PUBLIC_SUPPORT_EMAIL
  value: "{{ .Values.indico.email.support }}"
- name: INDICO_NO_REPLY_EMAIL
  value: "{{ .Values.indico.email.noreply }}"
- name: INDICO_DEFAULT_TIMEZONE
  value: "America/Chicago"
- name: INDICO_DEFAULT_LOCALE
  value: "en_US"
- name: INDICO_CELERY_BROKER
  value: "redis://{{ .Values.indico.redisCacheBaseUrl }}:6379/1"
- name: INDICO_STORAGE_BACKENDS
  value: "{'default': 'fs:/opt/indico/archive'}"
- name: INDICO_ATTACHMENT_STORAGE
  value: 'default'
- name: INDICO_ENABLE_ROOMBOOKING
  value: "False"
- name: INDICO_PLUGINS
  value: "{'previewer_code', 'vc_zoom', 'payment_manual'}"
- name: INDICO_KEYCLOAK_TITLE
  value: {{ .Values.indico.auth.oidc.title }}
- name: INDICO_KEYCLOAK_CLIENT_ID
  value: {{ .Values.indico.auth.oidc.clientId }}
- name: INDICO_KEYCLOAK_CLIENT_SECRET
  valueFrom:
    secretKeyRef:
      name: indico-secrets
      key: oidc-client-secret
- name: INDICO_KEYCLOAK_REGISTRATION_URL
  value: {{ .Values.indico.auth.oidc.profileUrl }}
- name: INDICO_KEYCLOAK_METADATA_URL
  value: {{ .Values.indico.auth.oidc.metadataUrl }}
- name: INDICO_LOCAL_IDENTITIES
  value: "{{ .Values.indico.auth.localIdentities }}"
{{- end -}}
