{{/*
Expand the name of the chart.
*/}}
{{- define "jenny.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "jenny.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "jenny.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "jenny.labels" -}}
helm.sh/chart: {{ include "jenny.chart" . }}
{{ include "jenny.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "jenny.selectorLabels" -}}
app.kubernetes.io/name: {{ include "jenny.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app: jenny
service: app
{{- end }}

{{- define "jenny.envs" -}}
- name: "DJANGO_SETTINGS_MODULE"
  value: "{{ .Values.django.settings }}"
- name: "DJANGO_CONFIGURATION"
  value: "{{ .Values.django.configuration }}"
- name: "DJANGO_SECRET_KEY"
  valueFrom:
    secretKeyRef:
      name: jenny-secrets
      key: DJANGO_SECRET_KEY
- name: "DJANGO_ALLOWED_HOSTS"
  value: "{{ .Values.django.allowed_hosts }}"
- name: "DB_NAME"
  value: "{{ .Values.django.db.name }}"
- name: "DB_USER"
  value: "{{ .Values.django.db.user }}"
- name: "DB_PASSWORD"
  valueFrom:
    secretKeyRef:
      name: jenny-secrets
      key: DB_PASSWORD
- name: "DB_HOST"
  value: "{{ .Values.django.db.host }}"
- name: "DB_PORT"
  value: "{{ .Values.django.db.port }}"
{{- range $key, $val := .Values.env.secret }}
- name: {{ $val.envName }}
  valueFrom:
    secretKeyRef:
      name: {{ $val.secretName }}
      key: {{ $val.keyName }}
{{- end }}
{{- end }}

{{- define "django.imagePullSecrets" -}}
{{- $pullSecrets := .Values.imagePullSecrets }}
{{- if (not (empty $pullSecrets)) }}
imagePullSecrets:
{{- range $pullSecrets }}
- name: {{ . }}
{{ end }}
{{- end -}}
{{- end }}
