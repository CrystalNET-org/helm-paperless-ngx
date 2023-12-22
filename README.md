# paperless-ngx

![Version: 0.2.7](https://img.shields.io/badge/Version-0.2.7-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 2.1.3](https://img.shields.io/badge/AppVersion-2.1.3-informational?style=flat-square)

A community-supported supercharged version of paperless with an included ftp server: scan, index and archive all your physical documents.

**Homepage:** <https://github.com/CrystalNET-org/helm-paperless-ngx>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| psych0d0g | <h@xx0r.eu> |  |

## Source Code

* <https://github.com/paperless-ngx/paperless-ngx>
* <https://github.com/CrystalNET-org/helm-paperless-ngx>

## Requirements

Kubernetes: `>=1.22.0-0`

| Repository | Name | Version |
|------------|------|---------|
| https://charts.bitnami.com/bitnami | mariadb(mariadb) | ~15.0.0 |
| https://charts.bitnami.com/bitnami | postgresql(postgresql) | ~13.2.24 |
| https://charts.bitnami.com/bitnami | redis(redis) | ~18.6.0 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` | define affinity, to have the pod run on the same node as other specific things |
| config.auth.email | string | `"no@mail.cf"` | default email for the admin user |
| config.auth.existing_secret | string | `nil` | use an pre-existing secret to provide credentials    it should contain the keys paperless-user, paperless-mail and paperless-pass |
| config.auth.password | string | `"admin"` | default password for the admin user |
| config.auth.username | string | `"admin"` | default username for the admin user |
| config.consumer.recursive | bool | `true` | let the consumer recurse into subdirectories for new documents |
| config.database.mariadb | object | See [values.yaml](./values.yaml) | only needed when type is mariadb and mariadb.enabled is set to false    meaning you would use an external already existing mariadb instance |
| config.database.mariadb.existing_secret | string | `nil` | use an pre-existing secret to provide credentials    it should contain the keys mysql-user and mysql-pass |
| config.database.mariadb.host | string | `"localhost"` | hostname where your external mariadb is reachable |
| config.database.mariadb.pass | string | `"password"` | mariadb password to use for our connection |
| config.database.mariadb.port | int | `3306` | port to connect to |
| config.database.mariadb.schema | string | `"paperless"` | database schema that holds the paperless tables |
| config.database.mariadb.user | string | `"paperless-user"` | mariadb user to use for our connection |
| config.database.type | string | `"postgresql"` | type can either be mariadb, postgresql or sqlite |
| config.ftpd.enabled | bool | `false` | set to true to enable builtin ftpd that uses the paperless database for authentication |
| config.ftpd.public_ip | string | `"127.0.0.1"` | Public IP used for the embedded FTPD for passive mode (usually your loadbalancer IP) |
| config.ftpd.service_type | string | `"LoadBalancer"` | loadbalancer for ease of use, you could potentially also use clusterip with an nginx tcp-services configmap |
| config.ocr_languages | list | `["deu","eng"]` | Languages to be used for ocr (only pre-installed languages are supported) |
| config.paperless_url | string | `"https://paperless.domain"` | Url where paperless is reachable via browser (including http(s)://) |
| ftpd_image.pullPolicy | string | `"IfNotPresent"` | pull policy, if you set tag to latest, this should be set to Always to not end up with stale builds |
| ftpd_image.repository | string | `"harbor.crystalnet.org/library/pureftpd"` | referencing the docker image to use for the ftpd component |
| ftpd_image.tag | string | `"0.2.2"` | Overrides the image tag whose default is the chart appVersion. |
| fullnameOverride | string | `""` | String to fully override `common.names.fullname` template |
| global.commonLabels | object | `{}` | Labels to apply to all resources. |
| global.imagePullSecrets | list | `[]` | Reference to one or more secrets to be used when pulling images    (https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/) |
| image.pullPolicy | string | `"IfNotPresent"` | pull policy, if you set tag to latest, this should be set to Always to not end up with stale builds |
| image.repository | string | `"ghcr.io/paperless-ngx/paperless-ngx"` | referencing the docker image to use for the deployment |
| image.tag | string | `""` | Overrides the image tag whose default is the chart appVersion. |
| ingress.annotations | object | `{"nginx.ingress.kubernetes.io/proxy-body-size":"256m"}` | add annotations to the ingress object (for example to have certificates managed by cert-manager) |
| ingress.className | string | `""` | uses the default ingress class if not set |
| ingress.enabled | bool | `false` | Enable creation of an ingress object for the deployment |
| ingress.hosts[0] | object | `{"host":"chart-example.local","paths":[{"path":"/","pathType":"ImplementationSpecific"}]}` | Hostname the ingress should react for |
| ingress.tls | list | `[]` |  |
| mariadb.auth.database | string | `"paperless"` | define database schema name that should be available |
| mariadb.auth.password | string | `"changeme"` | password to connect to the database |
| mariadb.auth.rootPassword | string | `"changeme"` | dedicated root password for the database (normally not used but needed for creation of schemas etc.) |
| mariadb.auth.username | string | `"paperless"` | username to connect to the database |
| mariadb.enabled | bool | `false` | provision an instance of the mariadb sub-chart |
| mariadb.primary.persistence.enabled | bool | `false` | enable to not loose your database contents on updates |
| mediaVolume | object | See [values.yaml](./values.yaml) | The list of additional volumes that will be mounted inside paperless pod, this one to `/paperless/library`. |
| nameOverride | string | `""` | String to partially override `common.names.fullname` template (will maintain the release name) |
| nodeSelector | object | `{}` | Define a subset of worker nodes where the deployment can be scheduled on |
| persistence.consume.enabled | bool | `false` | Enable paperless consume dir persistence using `PVC`. If false, use emptyDir (usually not needed) |
| persistence.consume.volumeClaimSpec.accessModes[0] | string | `"ReadWriteOnce"` |  |
| persistence.consume.volumeClaimSpec.resources.requests.storage | string | `"2Gi"` |  |
| persistence.data.enabled | bool | `true` | Enable paperless data persistence using `PVC`. (search index, SQLite database, classification model, etc) |
| persistence.data.volumeClaimSpec.accessModes[0] | string | `"ReadWriteOnce"` |  |
| persistence.data.volumeClaimSpec.resources.requests.storage | string | `"10Gi"` |  |
| persistence.log.enabled | bool | `true` | Enable paperless data persistence using `PVC`. (search index, SQLite database, classification model, etc) |
| persistence.log.volumeClaimSpec.accessModes[0] | string | `"ReadWriteOnce"` |  |
| persistence.log.volumeClaimSpec.resources.requests.storage | string | `"1Gi"` |  |
| podAnnotations | object | `{}` | If needed, set some annotations to the deployed pods |
| podSecurityContext.fsGroup | int | `1000` | set filesystem group access to the same as runAsGroup |
| podSecurityContext.fsGroupChangePolicy | string | `"OnRootMismatch"` | change fs mount permissions if they are not matching desired fsGroup |
| podSecurityContext.runAsGroup | int | `1000` | run the deployment as a group with this GID, should match fsGroup above |
| podSecurityContext.runAsNonRoot | bool | `true` | ensure the container dosnt run with not-needed root permissions |
| podSecurityContext.runAsUser | int | `1000` | run the deployment as a user with this UID |
| podSecurityContext.seccompProfile.type | string | `"RuntimeDefault"` | secure computing mode - see: https://kubernetes.io/docs/tutorials/security/seccomp/ |
| postgresql.auth.database | string | `"paperless"` | define database schema name that should be available |
| postgresql.auth.password | string | `"changeme"` | password to connect to the database |
| postgresql.auth.username | string | `"paperless"` | username to connect to the database |
| postgresql.enabled | bool | `true` | provision an instance of the postgresql sub-chart |
| redis.architecture | string | `"standalone"` | can be set to replication to spawn a full redis cluster with 3 nodes instead |
| redis.auth.enabled | bool | `true` | enable redis authentication mode |
| redis.auth.password | string | `"changeme"` | password that gets used for the connection between paperless and redis |
| redis.enabled | bool | `true` | provision an instance of the redis sub-chart |
| redis.redisPort | int | `6379` | default port for redis to listen on |
| resources | object | `{}` | Limit the pods ressources if needed |
| securityContext.allowPrivilegeEscalation | bool | `false` | Controls whether a process can gain more privileges than its parent process |
| securityContext.capabilities.drop | list | `["ALL"]` | drop unneccessary permissions |
| securityContext.readOnlyRootFilesystem | bool | `true` | mount / as readonly, writeable directorys are explicitely mounted |
| service.type | string | `"ClusterIP"` | usually ClusterIP if you have an ingress in place,    could also be set to LoadBalancer if for example metallb is in place |
| serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| serviceAccount.create | bool | `true` | Specifies whether a service account should be created |
| serviceAccount.name | string | `""` | The name of the service account to use.    If not set and create is true, a name is generated using the fullname template |
| tolerations | list | `[]` | setup tolerations if you for example want to have a dedicated worker node that only runs paperless |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.11.3](https://github.com/norwoodj/helm-docs/releases/v1.11.3)
