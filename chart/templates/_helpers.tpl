{{/*
Expand the name of the chart.
*/}}
{{- define "paperless.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "paperless.fullname" -}}
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
{{- define "paperless.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "paperless.labels" -}}
helm.sh/chart: {{ include "paperless.chart" . }}
{{ include "paperless.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "paperless.selectorLabels" -}}
app.kubernetes.io/name: {{ include "paperless.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "paperless.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "paperless.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create chart environment and make it reusable
*/}}
{{- define "paperless.env" -}}
{{- if .Values.redis.enabled }}
{{- if .Values.redis.auth.enabled }}
- name: PAPERLESS_REDIS
  value: {{ printf "redis://:%s@%s-redis-headless:%s" .Values.redis.auth.password .Release.Name ( .Values.redis.redisPort | default "6379" | toString ) | quote }}
{{- else }}
- name: PAPERLESS_REDIS
  value: {{ printf "redis://%s-redis-headless:%s" .Release.Name ( .Values.redis.redisPort | default "6379" | toString ) | quote }}
{{- end }}
{{- end }}
{{- if .Values.config.auth.existing_secret }}
- name: PAPERLESS_ADMIN_USER
  valueFrom:
    secretKeyRef:
      name: {{ .Values.config.auth.existing_secret }}
      key: paperless-user
- name: PAPERLESS_ADMIN_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ .Values.config.auth.existing_secret }}
      key: paperless-pass
- name: PAPERLESS_ADMIN_MAIL
  valueFrom:
    secretKeyRef:
      name: {{ .Values.config.auth.existing_secret }}
      key: paperless-mail
{{- else }}
- name: PAPERLESS_ADMIN_USER
  value: {{ .Values.config.auth.username }}
- name: PAPERLESS_ADMIN_PASSWORD
  value: {{ .Values.config.auth.password }}
- name: PAPERLESS_ADMIN_MAIL
  value: {{ .Values.config.auth.email }}
{{- end }}
{{- /*
# Database configuration
*/}}
{{- if .Values.mariadb.enabled }}
- name: PAPERLESS_DBENGINE
  value: "mariadb"
- name: PAPERLESS_DBHOST
  value: {{ printf "%s-mariadb" .Release.Name | quote }}
- name: PAPERLESS_DBPORT
  value: "3306"
- name: DB_USER
  value: {{ .Values.mariadb.auth.username | quote }}
- name: PAPERLESS_DBNAME
  value: {{ .Values.mariadb.auth.database | quote }}
- name: PAPERLESS_DBPASS
  valueFrom:
    secretKeyRef:
      name: {{ printf "%s-mariadb" .Release.Name | quote }}
      key: mariadb-password
{{- else if contains "mariadb" .Values.config.database.type }}
- name: PAPERLESS_DBENGINE
  value: "mariadb"
- name: PAPERLESS_DBHOST
  value: {{ .Values.config.database.mariadb.host | quote }}
- name: PAPERLESS_DBPORT
  value: {{ .Values.config.database.mariadb.port | quote }}
- name: DB_USER
  value: {{ .Values.config.database.mariadb.user | quote }}
- name: PAPERLESS_DBNAME
  value: {{ .Values.config.database.mariadb.schema | quote }}
- name: PAPERLESS_DBPASS
  value: {{ .Values.config.database.mariadb.pass | quote }}
{{- else if .Values.postgresql.enabled }}
- name: PAPERLESS_DBENGINE
  value: "postgresql"
- name: PAPERLESS_DBHOST
  value: {{ printf "%s-postgresql" .Release.Name | quote }}
- name: PAPERLESS_DBPORT
  value: "5432"
- name: DB_USER
  value: {{ .Values.postgresql.auth.username | quote }}
- name: PAPERLESS_DBNAME
  value: {{ .Values.postgresql.auth.database | quote }}
- name: PAPERLESS_DBPASS
  valueFrom:
    secretKeyRef:
      name: {{ printf "%s-postgresql" .Release.Name | quote }}
      key: password
{{- else }}
- name: PAPERLESS_DBENGINE
  value: ""
{{- end }}
{{- /*
# END Database configuration
*/}}
- name: PAPERLESS_OCR_LANGUAGES
  value: {{ join "+" .Values.config.ocr_languages | quote }}
- name: PAPERLESS_CONSUMER_RECURSIVE
  value: {{ .Values.config.consumer.recursive | quote }}
- name: PAPERLESS_CONSUMPTION_DIR
  value: "/mnt/library/consume"
- name: PAPERLESS_DATA_DIR
  value: "/var/paperless/data"
- name: PAPERLESS_MEDIA_ROOT
  value: "/mnt/library"
- name: PAPERLESS_LOGGING_DIR
  value: "/var/log/paperless"
- name: PAPERLESS_URL
  value: {{ .Values.config.paperless_url | quote }}
{{- end }}


{{/*
Create chart volume mounts and make it reusable
*/}}
{{- define "paperless.volumeMounts" -}}
- name: consume
  mountPath: /var/paperless/consume
- name: library
  mountPath: /mnt/library
- name: temp
  mountPath: /tmp/
- name: log
  mountPath: /var/log/paperless
{{- end }}

{{/*
Create chart volumes and make it reusable
*/}}
{{- define "paperless.volumes" -}}
- name: consume
  {{- if .Values.persistence.consume.enabled }}
  persistentVolumeClaim:
    claimName: {{ include "paperless.fullname" . }}-consume
  {{- else }}
  emptyDir: { }
  {{- end }}
- name: log
  {{- if .Values.persistence.log.enabled }}
  persistentVolumeClaim:
    claimName: {{ include "paperless.fullname" . }}-log
  {{- else }}
  emptyDir: { }
  {{- end }}
- name: library
  {{- if .Values.mediaVolume.enabled }}
  persistentVolumeClaim:
    claimName: {{ include "paperless.fullname" $ }}-mediavol-{{ .Values.mediaVolume.name }}
  {{- else }}
  emptyDir: { }
  {{- end }}
- name: data
  {{- if .Values.persistence.data.enabled }}
  persistentVolumeClaim:
    claimName: {{ include "paperless.fullname" . }}-data
  {{- else }}
  emptyDir: { }
  {{- end }}
- name: celerydata
  emptyDir: { }
- name: temp
  emptyDir: { }
- name: ftpd-config
  configMap:
    name: {{ include "paperless.fullname" . }}-config
    items:
    - key: pureftpd.conf
      path: pureftpd.conf
{{- end }}
