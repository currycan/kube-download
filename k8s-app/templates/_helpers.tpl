{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "k8s-app.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "k8s-app.fullname" -}}
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
{{- define "k8s-app.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "k8s-app.labels" -}}
helm.sh/chart: {{ include "k8s-app.chart" . | quote }}
{{ include "k8s-app.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ ( .Values.image.tag | default .Chart.AppVersion ) | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service | quote }}
app: {{ include "k8s-app.fullname" . }}
{{- if .Values.labels }}
{{ toYaml .Values.labels }}
{{- end }}
{{- if .Values.ingress.enabled }}
exposed: "external"
{{- else if .Values.service.enabled }}
exposed: "internal"
{{- else }}
exposed: "no"
{{- end }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "k8s-app.selectorLabels" -}}
app.kubernetes.io/name: {{ include "k8s-app.fullname" . | quote }}
app.kubernetes.io/instance: {{ .Release.Name | quote }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "k8s-app.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "k8s-app.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Validate that only one of useDeployment, useStatefulSet, or useDaemonSet is true.
*/}}
{{- define "validateWorkloadType" -}}
  {{- $useDeployment := .Values.useDeployment -}}
  {{- $useStatefulSet := .Values.useStatefulSet -}}
  {{- $useDaemonSet := .Values.useDaemonSet -}}
  {{- $countTrue := 0 -}}
  {{- if $useDeployment -}}
    {{- $countTrue = add $countTrue 1 -}}
  {{- end -}}
  {{- if $useStatefulSet -}}
    {{- $countTrue = add $countTrue 1 -}}
  {{- end -}}
  {{- if $useDaemonSet -}}
    {{- $countTrue = add $countTrue 1 -}}
  {{- end -}}
  {{- if gt $countTrue 1 -}}
    {{- fail "Only one of useDeployment, useStatefulSet, or useDaemonSet can be true" -}}
  {{- end -}}
{{- end -}}
