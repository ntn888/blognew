.PHONY: pages clean publish

pages: clean
	./build.sh

clean:
	rm -rf public/

publish: pages
	@echo "🚀 Deploying to GitHub Pages..."
	@mkdir -p gh-pages-deploy
	@cp -r public/. gh-pages-deploy/
	@cd gh-pages-deploy && git init
	@cd gh-pages-deploy && git add .
	@cd gh-pages-deploy && git commit -m "Publish site $(shell date '+%Y-%m-%d %H:%M')"
	@cd gh-pages-deploy && git remote add origin git@github.com:ntn888/ntn888.github.io.git
	@cd gh-pages-deploy && git push --force origin main
	@rm -rf gh-pages-deploy
	@echo "✅ Deployment complete!"

