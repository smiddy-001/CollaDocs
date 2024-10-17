API_DIR = services/colladocs-api
DATABASE_DIR = services/database
FRONTEND_DIR = services/frontend
START_SCRIPT = bash ./start.sh
ENV_TYPE = test  # from config.yaml
API_DOCS_DIR = docs/api
SH_FLAGS = --mode $(ENV_TYPE)

.PHONY: 
all: backend frontend
	@echo "🐸🛀🧨 Starting the entire app (Backend + Frontend)..."

.PHONY: database
database:
	@echo "🧨 Starting the database..."
	cd $(DATABASE_DIR) && $(START_SCRIPT)

.PHONY: api
api:
	@echo "🐸 Starting the API..."
	cd $(API_DIR) && $(START_SCRIPT)

.PHONY: api-docs
api-docs:
	@echo "🥬 Starting the api documentation swagger as a webpage..."
	npm install -g http-server
	cd $(API_DOCS_DIR) && http-server

.PHONY: database
frontend:
	@echo "🛀 Starting the frontend..."
	cd $(FRONTEND_DIR) && $(START_SCRIPT)

.PHONY: database
backend: database api
	@echo "🐸🧨 Backend (API + Database) started."

.PHONY: stop
stop:
	@echo "Stopping the application..."
	# Add stop commands for each component here

.PHONY: clean
clean:
	@echo "Cleaning up..."
