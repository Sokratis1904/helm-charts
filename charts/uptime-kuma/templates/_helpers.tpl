{{/*
Expand the name of the chart.
*/}}
{{- define "uptime-kuma.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "uptime-kuma.fullname" -}}
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
{{- define "uptime-kuma.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "uptime-kuma.labels" -}}
helm.sh/chart: {{ include "uptime-kuma.chart" . }}
{{ include "uptime-kuma.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "uptime-kuma.selectorLabels" -}}
app.kubernetes.io/name: {{ include "uptime-kuma.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "uptime-kuma.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "uptime-kuma.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Registry secrets
*/}}
{{- define "imagePullSecret" }}
{{- printf "{\"auths\": {\"%s\": {\"auth\": \"%s\"}}}" .registry (printf "%s:%s" .username .password | b64enc) | b64enc }}
{{- end }}

{{/*
Checksum
*/}}
{{- define "uptime-kuma.configChecksum" -}}
{{- $config := print $.Template.BasePath "/configmap.yaml" -}}
{{- $secrets := print $.Template.BasePath "/secret.yaml" -}}
{{- $deployment := print $.Template.BasePath "/deployment.yaml" -}}
{{- $ingress := print $.Template.BasePath "/ingress.yaml" -}}
{{- $service := print $.Template.BasePath "/service.yaml" -}}
{{- $hpa := print $.Template.BasePath "/hpa.yaml" -}}
{{- printf "%s:%s" $config $secrets $deployment $ingress $service $hpa  | sha256sum -}}
{{- end }}