API_DIR = services/colladocs-api
DATABASE_DIR = services/database
FRONTEND_DIR = services/frontend
START_SCRIPT = bash ./start.sh
ENV_TYPE = test  # from config.yaml
SH_FLAGS = --mode $(ENV_TYPE)

.PHONY: 
all: backend frontend
	@echo "🐸🛀🧨 Starting the entire app (Backend + Frontend)..."

.PHONY: database
database:
	@echo "🧨 Starting the database..."
	cd $(DATABASE_DIR) && $(START_SCRIPT)

.PHONY: database
api:
	@echo "🐸 Starting the API..."
	cd $(API_DIR) && $(START_SCRIPT)

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
