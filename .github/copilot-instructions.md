# Copilot Instructions

## Style

### Commits
* When creating new commits in automatic agent mode, always prefix commit with `[COPILOT]`.

### Cohesion with Existing Code
* New work should be cohesive with existing code.
* Refer to the same game files when possible.
* Use similar approaches to existing implementations.

## Workflow

### Developer
Developers use `build.compose.yml` to build and push Docker images:
```bash
docker compose -f build.compose.yml build
docker compose -f build.compose.yml push
```

### End User
End users only need the single `docker-compose.yml` file. They don't clone the repository:
```bash
curl -O https://raw.githubusercontent.com/AbbyNode/minecraft-modpack-docker/main/docker-compose.yml
docker compose pull
docker compose up -d
```
