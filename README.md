# Projet Kubernetes - Déploiement Automatisé avec Minikube, Kubernetes, Prometheus et Grafana

Ce projet utilise **Minikube**, **Kubernetes**, **Prometheus**, **Grafana** et d'autres outils pour déployer une application de backend et de frontend avec un système de monitoring et d'autoscaling.

## Prérequis

Avant d'exécuter le script, assurez-vous que vous avez installé et configuré les éléments suivants :

1. **Minikube** : Utilisé pour créer un cluster Kubernetes localement.
2. **Kubernetes (kubectl)** : Utilisé pour interagir avec votre cluster Kubernetes.
3. **Helm** : Utilisé pour déployer les stacks Prometheus et Grafana via les charts Helm.
4. **Docker** : Nécessaire si Minikube est configuré avec le driver Docker.
5. **Accès administrateur ou droits pour installer des packages** : Pour certaines étapes, vous aurez besoin d'avoir des droits d'installation de packages sur votre machine.

### Prérequis supplémentaires pour Minikube

- Si vous utilisez Minikube avec le driver Docker, assurez-vous d'être dans un utilisateur non-root et ajoutez cet utilisateur au groupe Docker :
  ```bash
  sudo usermod -ag docker <user> && newgrp docker
