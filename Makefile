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
	kubectl create namespace $(WEBSITE)


.PHONY: deploy
deploy:
	kubectl apply --validate=strict -f deployment.yaml -n $(WEBSITE)
