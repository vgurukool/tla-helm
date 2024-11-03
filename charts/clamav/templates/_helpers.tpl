{{- define "clamav.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "clamav.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{- define "clamav.pvcname" -}}
{{- printf "%s-signature-db" (include "clamav.fullname" .) -}}
{{- end -}}

{{- define "clamav.selectorLabels" -}}
app.kubernetes.io/name: {{ include "clamav.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}