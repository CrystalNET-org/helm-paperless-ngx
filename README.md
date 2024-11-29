

<!-- markdownlint-disable MD033 -->

<h1 align="center">
    <a href="https://github.com/CrystalNET-org/helm-paperless-ngx">
        <img src="https://avatars.githubusercontent.com/u/99562962?s=48&v=4" alt="Logo" style="max-height: 150px">
    </a>
</h1>

<h4 align="center">Paperless Ngx - A community-supported supercharged version of paperless with an included ftp server: scan, index and archive all your physical documents.</h4>

<div align="center">
  <br/>

  [
    ![License](https://img.shields.io/github/license/paperless-ngx/paperless-ngx?logo=git&logoColor=white&logoWidth=20)
  ](LICENSE)
  <br/>
  ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square)
  ![Version: 0.2.17](https://img.shields.io/badge/Version-0.2.17-informational?style=flat-square)
  ![AppVersion: 2.4.3](https://img.shields.io/badge/AppVersion-2.4.3-informational?style=flat-square)
  [![Artifact Hub](https://img.shields.io/endpoint?url=https://artifacthub.io/badge/repository/CrystalNET)](https://artifacthub.io/packages/helm/crystalnet/paperless-ngx)

</div>

---

## [Paperless Ngx](https://github.com/CrystalNET-org/helm-paperless-ngx)

> _Disclaimer: This application has been developed by the [Paperless Ngx](https://github.com/CrystalNET-org/helm-paperless-ngx) community._

Paperless-ngx A community-supported supercharged version of paperless: scan, index and archive all your physical documents.

[> More about Paperless Ngx](https://github.com/CrystalNET-org/helm-paperless-ngx)

---

## TL;DR

Direct install via oci://:
```shell
helm install my-release oci://harbor.crystalnet.org/charts/paperless-ngx
```

install using chartMuseum:
```shell
helm repo add crystalnet https://helm.crystalnet.org
helm install my-release crystalnet/paperless-ngx
```

## Introduction

This chart bootstraps a Paperless Ngx deployment on a [Kubernetes](kubernetes.io) cluster using the [Helm](helm.sh) package manager.

## Prerequisites

- Helm 3+
- PV provisioner support in the underlying infrastructure
- loadbalancer support for the ftp ingestion to work

## Requirements

Kubernetes: `>=1.22.0-0`

| Repository | Name | Version |
|------------|------|---------|
| https://charts.bitnami.com/bitnami | mariadb(mariadb) | ~15.2.0 |
| https://charts.bitnami.com/bitnami | postgresql(postgresql) | ~14.0.0 |
| https://charts.bitnami.com/bitnami | redis(redis) | ~18.12.0 |

## Installing the Chart

To install the chart with the release name `my-release`:

Direct install via oci://:
```shell
helm install my-release oci://harbor.crystalnet.org/charts/paperless-ngx
```

install using chartMuseum:
```shell
helm repo add crystalnet https://helm.crystalnet.org
helm install my-release crystalnet/paperless-ngx
```

These commands deploy paperless-ngx on the Kubernetes cluster in the default configuration.
The Parameters section lists the parameters that can be configured during installation.

> **Tip:** List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```shell
helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters

### Global parameters

| Key | Description | Default |
|-----|-------------|---------|
| `global.commonLabels` |  Labels to apply to all resources. | `{}` |
| `global.imagePullSecrets` |  Reference to one or more secrets to be used when pulling images    ([kubernetes.io/docs](https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/)) | `[]` |

### Common parameters

| Key | Description | Default |
|-----|-------------|---------|
| `fullnameOverride` | String to fully override `common.names.fullname` template | `""` |
| `nameOverride` | String to partially override `common.names.fullname` template (will maintain the release name) | `""` |

### Paperless Ngx parameters

| Key | Description | Default |
|-----|-------------|---------|
| `config.auth.email` | default email for the admin user | `"no@mail.cf"` |
| `config.auth.existing_secret` | use an pre-existing secret to provide credentials    it should contain the keys paperless-user, paperless-mail and paperless-pass | `nil` |
| `config.auth.password` | default password for the admin user | `"admin"` |
| `config.auth.username` | default username for the admin user | `"admin"` |
| `config.consumer.recursive` | let the consumer recurse into subdirectories for new documents | `true` |
| `config.ftpd.enabled` | set to true to enable builtin ftpd that uses the paperless database for authentication | `false` |
| `config.ftpd.public_ip` | Public IP used for the embedded FTPD for passive mode (usually your loadbalancer IP) | `"127.0.0.1"` |
| `config.ftpd.service_type` | loadbalancer for ease of use, you could potentially also use clusterip with an nginx tcp-services configmap | `"LoadBalancer"` |
| `config.ocr_languages` | Languages to be used for ocr (only pre-installed languages are supported) | `["deu","eng"]` |
| `config.paperless_url` | Url where paperless is reachable via browser (including http(s)://) | `"https://paperless.domain"` |
| `image.pullPolicy` | pull policy, if you set tag to latest, this should be set to Always to not end up with stale builds | `"IfNotPresent"` |
| `image.repository` | referencing the docker image to use for the deployment | `"ghcr.io/paperless-ngx/paperless-ngx"` |
| `image.tag` | Overrides the image tag whose default is the chart appVersion. | `""` |

### Security parameters

| Key | Description | Default |
|-----|-------------|---------|
| `podSecurityContext.fsGroup` | set filesystem group access to the same as runAsGroup | `1000` |
| `podSecurityContext.fsGroupChangePolicy` | change fs mount permissions if they are not matching desired fsGroup | `"OnRootMismatch"` |
| `podSecurityContext.runAsGroup` | run the deployment as a group with this GID, should match fsGroup above | `1000` |
| `podSecurityContext.runAsNonRoot` | ensure the container dosnt run with not-needed root permissions | `true` |
| `podSecurityContext.runAsUser` | run the deployment as a user with this UID | `1000` |
| `podSecurityContext.seccompProfile.type` | secure computing mode - see: [kubernetes.io/docs](https://kubernetes.io/docs/tutorials/security/seccomp/) | `"RuntimeDefault"` |
| `securityContext.allowPrivilegeEscalation` | Controls whether a process can gain more privileges than its parent process | `false` |
| `securityContext.capabilities.drop` | drop unneccessary permissions | `["ALL"]` |
| `securityContext.readOnlyRootFilesystem` | mount / as readonly, writeable directorys are explicitely mounted | `true` |

### Deployment/Statefulset parameters

| Key | Description | Default |
|-----|-------------|---------|
| `affinity` | define affinity, to have the pod run on the same node as other specific things | `{}` |
| `nodeSelector` | Define a subset of worker nodes where the deployment can be scheduled on | `{}` |
| `podAnnotations` | If needed, set some annotations to the deployed pods | `{}` |
| `resources` | Limit the pods ressources if needed | `{}` |
| `tolerations` | setup tolerations if you for example want to have a dedicated worker node that only runs paperless | `[]` |

### Network parameters

| Key | Description | Default |
|-----|-------------|---------|
| `ingress.annotations` | add annotations to the ingress object (for example to have certificates managed by cert-manager) | `{"nginx.ingress.kubernetes.io/proxy-body-size":"256m"}` |
| `ingress.className` | uses the default ingress class if not set | `""` |
| `ingress.enabled` | Enable creation of an ingress object for the deployment | `false` |
| `ingress.hosts[0]` | Hostname the ingress should react for | `{"host":"chart-example.local","paths":[{"path":"/","pathType":"ImplementationSpecific"}]}` |
| `ingress.tls` |  | `[]` |
| `service.type` | usually ClusterIP if you have an ingress in place,    could also be set to LoadBalancer if for example metallb is in place | `"ClusterIP"` |
| `serviceAccount.annotations` | Annotations to add to the service account | `{}` |
| `serviceAccount.create` | Specifies whether a service account should be created | `true` |
| `serviceAccount.name` | The name of the service account to use.    If not set and create is true, a name is generated using the fullname template | `""` |

### Persistence parameters

| Key | Description | Default |
|-----|-------------|---------|
| `persistence.consume.enabled` | Enable paperless consume dir persistence using `PVC`. If false, use emptyDir (usually not needed) | `false` |
| `persistence.consume.volumeClaimSpec.accessModes[0]` |  | `"ReadWriteOnce"` |
| `persistence.consume.volumeClaimSpec.resources.requests.storage` |  | `"2Gi"` |
| `persistence.data.enabled` | Enable paperless data persistence using `PVC`. (search index, SQLite database, classification model, etc) | `true` |
| `persistence.data.volumeClaimSpec.accessModes[0]` |  | `"ReadWriteOnce"` |
| `persistence.data.volumeClaimSpec.resources.requests.storage` |  | `"10Gi"` |
| `persistence.log.enabled` | Enable paperless data persistence using `PVC`. (search index, SQLite database, classification model, etc) | `true` |
| `persistence.log.volumeClaimSpec.accessModes[0]` |  | `"ReadWriteOnce"` |
| `persistence.log.volumeClaimSpec.resources.requests.storage` |  | `"1Gi"` |

### Database parameters

| Key | Description | Default |
|-----|-------------|---------|
| `config.database.mariadb` | only needed when type is mariadb and mariadb.enabled is set to false    meaning you would use an external already existing mariadb instance | See [values.yaml](./values.yaml) |
| `config.database.mariadb.existing_secret` | use an pre-existing secret to provide credentials    it should contain the keys mysql-user and mysql-pass | `nil` |
| `config.database.mariadb.host` | hostname where your external mariadb is reachable | `"localhost"` |
| `config.database.mariadb.pass` | mariadb password to use for our connection | `"password"` |
| `config.database.mariadb.port` | port to connect to | `3306` |
| `config.database.mariadb.schema` | database schema that holds the paperless tables | `"paperless"` |
| `config.database.mariadb.user` | mariadb user to use for our connection | `"paperless-user"` |
| `config.database.type` | type can either be mariadb, postgresql or sqlite | `"postgresql"` |
| `mariadb.auth.database` | define database schema name that should be available | `"paperless"` |
| `mariadb.auth.password` | password to connect to the database | `"changeme"` |
| `mariadb.auth.rootPassword` | dedicated root password for the database (normally not used but needed for creation of schemas etc.) | `"changeme"` |
| `mariadb.auth.username` | username to connect to the database | `"paperless"` |
| `mariadb.enabled` | provision an instance of the mariadb sub-chart | `false` |
| `mariadb.primary.persistence.enabled` | enable to not loose your database contents on updates | `false` |

### redis parameters

| Key | Description | Default |
|-----|-------------|---------|
| `redis.architecture` | can be set to replication to spawn a full redis cluster with 3 nodes instead | `"standalone"` |
| `redis.auth.enabled` | enable redis authentication mode | `true` |
| `redis.auth.password` | password that gets used for the connection between paperless and redis | `"changeme"` |
| `redis.enabled` | provision an instance of the redis sub-chart | `true` |
| `redis.redisPort` | default port for redis to listen on | `6379` |
### Other parameters

| Key | Description | Default |
|-----|-------------|---------|
| `ftpd_image.pullPolicy` | pull policy, if you set tag to latest, this should be set to Always to not end up with stale builds | `"IfNotPresent"` |
| `ftpd_image.repository` | referencing the docker image to use for the ftpd component | `"harbor.crystalnet.org/library/paperless-ftpd"` |
| `ftpd_image.tag` | Overrides the image tag whose default is the chart appVersion. | `"0.2.3"` |
| `mediaVolume` | The list of additional volumes that will be mounted inside paperless pod, this one to `/paperless/library`. | See [values.yaml](./values.yaml) |
| `postgresql.auth.database` | define database schema name that should be available | `"paperless"` |
| `postgresql.auth.password` | password to connect to the database | `"changeme"` |
| `postgresql.auth.username` | username to connect to the database | `"paperless"` |
| `postgresql.enabled` | provision an instance of the postgresql sub-chart | `true` |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```shell
helm install my-release --set fullnameOverride=my-paperless-ngx oci://harbor.crystalnet.org/charts/paperless-ngx
```

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```shell
helm install my-release -f values.yaml oci://harbor.crystalnet.org/charts/paperless-ngx
```

> **Tip:** You can use the default values.yaml

## License

Licensed under the GNU General Public License v3.0 (the "License"); you may not use this file except in compliance with
the License. You may obtain a copy of the License at

```
TBD
```

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an
"AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific
language governing permissions and limitations under the License.

