IMG_NAME := quik-website
NAMESPACE := quik-website


.PHONY: website
website: content
	podman build -t $(IMG_NAME) .


.PHONY: fmt
fmt:
	./caddy fmt --overwrite Caddyfile


.PHONY: run
run:
	podman run --rm -p 8080:80 $(IMG_NAME)


.PHONY: pre-deploy
pre-deploy:
	kubectl create namespace $(NAMESPACE)


.PHONY: deploy-check
deploy-check:
	kubectl apply --dry-run=server --validate=strict -f deployment.yaml -n $(NAMESPACE)


.PHONY: deploy
deploy:
	kubectl apply --validate=strict -f deployment.yaml -n $(NAMESPACE)


.PHONY: post-deploy-check
post-deploy-check:
	kubectl rollout status deployment/quik-website -n $(NAMESPACE)
	NODE_IP=$$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[0].address}'); \
	NODE_HTTP_PORT=$$(kubectl get svc traefik -n traefik -o jsonpath='{.spec.ports[0].nodePort}'); \
	curl -H 'Host: irrationalidiom.com' http://$$NODE_IP:$$NODE_HTTP_PORT/quik | grep "Quik" || false
