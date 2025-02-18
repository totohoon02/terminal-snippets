# docker 
alias up="docker compose up -d"
alias down="docker compose down"

pydocker(){
	echo 'FROM python:3.10-slim' > Dockerfile
	echo '' >> Dockerfile
	echo 'WORKDIR /app' >> Dockerfile
	echo '' >> Dockerfile
	echo 'COPY requirements.txt .' >> Dockerfile
	echo '' >> Dockerfile
	echo 'RUN pip install -r requirements.txt' >> Dockerfile
	echo '' >> Dockerfile
	echo 'COPY . .' >> Dockerfile
	echo '' >> Dockerfile
	echo 'EXPOSE 8000' >> Dockerfile
	echo '' >> Dockerfile
	echo 'CMD ["uvicorn", "main:app", "host", "0.0.0.0"]' >> Dockerfile
}

jdocker() {
	name=${1:-app}

	echo 'FROM openjdk:21-jdk-slim' > Dockerfile
	echo '' >> Dockerfile
	echo 'WORKDIR /app' >> Dockerfile
	echo '' >> Dockerfile
	echo "ARG JAR_FILE=target/${name}.jar" >> Dockerfile
	echo '' >> Dockerfile
	echo 'COPY ${JAR_FILE} app.jar' >> Dockerfile
	echo '' >> Dockerfile
	echo 'EXPOSE 8080' >> Dockerfile
	echo '' >> Dockerfile
	echo 'ENTRYPOINT ["java", "-jar", "app.jar"]' >> Dockerfile
}

build(){
	docker build -t "$@" .
}

rmi(){
	for image_id in $(docker images --filter "dangling=true" -q); do
		docker rmi "$image_id"
	done
}

# python 

venv(){
	version=${1:-3.10}

	if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]]; then
		py -$version -m venv .venv
	else
		python$version -m venv .venv
	fi

	pip install ruff

	activate
}

activate(){
	if [ -d "./.venv/Scripts/" ]; then
		. .venv/Scripts/activate
	else
		. .venv/bin/activate
	fi
}

requirements(){
	pip install -r requirements.txt
}

freeze(){
	pip freeze > requirements.txt
}

fast(){
	venv
	activate
	pip install fastapi uvicorn ruff injector
	freeze

	# gen dir
	mkdir controller
	mkdir service
	mkdir service/inf
	mkdir tests

	# DI Config
	echo 'from injector import Injector, Module, singleton, provider' > config.py
	echo '' >> config.py
	echo '# inf' >> config.py
	echo 'from service.inf.sampleService import SampleService' >> config.py
	echo '' >> config.py
	echo '# static' >> config.py
	echo 'from service.sampleServiceImpl import SampleServiceImpl' >> config.py
	echo '' >> config.py
	echo '' >> config.py
	echo 'class ServiceModule(Module):' >> config.py
	echo '    @singleton' >> config.py
	echo '    @provider' >> config.py
	echo '    def sampleService(self) -> SampleService:' >> config.py
	echo '        return SampleServiceImpl()' >> config.py
	echo '' >> config.py
	echo '' >> config.py
	echo 'injector = Injector([ServiceModule()])' >> config.py

	# sample controller
	echo 'from fastapi import APIRouter' > controller/sampleController.py
	echo 'from config import injector' >> controller/sampleController.py
	echo 'from service.inf.sampleService import SampleService' >> controller/sampleController.py
	echo '' >> controller/sampleController.py
	echo 'router = APIRouter(prefix="/hello", tags=["hello"])' >> controller/sampleController.py
	echo '' >> controller/sampleController.py
	echo '# service' >> controller/sampleController.py
	echo 'sampleService = injector.get(SampleService)' >> controller/sampleController.py
	echo '' >> controller/sampleController.py
	echo '' >> controller/sampleController.py
	echo '@router.get("")' >> controller/sampleController.py
	echo 'def hello():' >> controller/sampleController.py
	echo '    return sampleService.hello()' >> controller/sampleController.py

	# sample service
	echo 'from abc import ABC, abstractmethod' > service/inf/sampleService.py
	echo '' >> service/inf/sampleService.py
	echo '' >> service/inf/sampleService.py
	echo 'class SampleService(ABC):' >> service/inf/sampleService.py
	echo '    @abstractmethod' >> service/inf/sampleService.py
	echo '    def hello(self):' >> service/inf/sampleService.py
	echo '        pass' >> service/inf/sampleService.py

	# sample serviceImpl
	echo 'from .inf.sampleService import SampleService' > service/sampleServiceImpl.py
	echo '' >> service/sampleServiceImpl.py
	echo '' >> service/sampleServiceImpl.py
	echo 'class SampleServiceImpl(SampleService):' >> service/sampleServiceImpl.py
	echo '    def __init__(self):' >> service/sampleServiceImpl.py
	echo '        super().__init__()' >> service/sampleServiceImpl.py
	echo '' >> service/sampleServiceImpl.py
	echo '    def hello(self):' >> service/sampleServiceImpl.py
	echo '        return {"Hello": "World!"}' >> service/sampleServiceImpl.py

	# main.py
	echo 'from fastapi import FastAPI' > main.py
	echo 'from controller import sampleController' >> main.py
	echo '' >> main.py
	echo 'app = FastAPI()' >> main.py
	echo '' >> main.py
	echo 'app.include_router(sampleController.router)' >> main.py

	# sample test
	echo 'class Test_SampleService:' > tests/test_sample.py
	echo '    # this will be succeeded' >> tests/test_sample.py
	echo '    def test_hello_success(self):' >> tests/test_sample.py
	echo '        world = "hello!"' >> tests/test_sample.py
	echo '        assert "hell" in world' >> tests/test_sample.py
	echo '' >> tests/test_sample.py
	echo '    # this will be failed' >> tests/test_sample.py
	echo '    def test_hello_fail(self):' >> tests/test_sample.py
	echo '        world = "hello!"' >> tests/test_sample.py
	echo '        assert "hell" not in world' >> tests/test_sample.py

	rr
}

run() {
	port=${1:-8000}
	uvicorn main:app --reload --port=$port
}

rr(){
	ruff format
	ruff check
}

db(){
	# install package
	pip install sqlalchemy

	# create db.py
	echo 'from sqlalchemy import create_engine' > db.py
	echo 'from sqlalchemy.ext.declarative import declarative_base' >> db.py
	echo 'from sqlalchemy.orm import sessionmaker' >> db.py
	echo '' >> db.py
	echo 'SQLALCHEMY_DATABASE_URL = "sqlite:///./mydb.db"' >> db.py
	echo '' >> db.py
	echo 'engine = create_engine(' >> db.py
	echo '    SQLALCHEMY_DATABASE_URL, connect_args={"check_same_thread": False}' >> db.py
	echo ')' >> db.py
	echo '' >> db.py
	echo 'SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)' >> db.py
	echo '' >> db.py
	echo 'Base = declarative_base()' >> db.py

	# create models.py
	
	echo 'from db import Base' > models.py
	echo '' >> models.py
	echo 'class DummyModel(Base):' >> models.py
	echo '    pass' >> models.py
	
	# main.py
	echo 'import models' >> main.py
	echo 'from db import engine' >> main.py
	echo 'models.Base.metadata.create_all(bind=engine)' >> main.py
}

# bash
pk() {
	port=$1

	if [[ -z "$port" ]]; then
		echo "Usage: $0 <port>"
		exit 1
	fi

	pid_to_kill=$(netstat -tuln 2>/dev/null | grep ":$port" | awk '{print $7}' | cut -d'/' -f1)

	if [[ -n "$pid_to_kill" ]]; then
		echo "killed process on $port"
		kill -9 "$pid_to_kill"
	else
		echo "No process found on $port"
	fi
}

host() {
	if [ -z "$1" ]; then
		echo "Usage: host <port> [--secret]"
		return 1
	fi

	local port="$1"
	local url="http://localhost:$port"
	local browser_flag=""

	if [[ "$2" == "--secret" || "$2" == "-s" ]]; then
		case "$OSTYPE" in
			msys|cygwin|win32)
				browser_flag="--incognito" ;;
			darwin*)
				browser_flag="--incognito" ;;
			linux-gnu*)
				browser_flag="--incognito" ;; # 기본적으로 Chrome 기준
		esac
	fi

	if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" || "$OSTYPE" == "win32" ]]; then
		start chrome "$browser_flag" "$url"
	elif [[ "$OSTYPE" == "darwin"* ]]; then
		open -a "Google Chrome" --args "$browser_flag" "$url"
	elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
		xdg-open "$url" # xdg-open은 기본 브라우저를 사용함
	else
		echo "Unsupported operating system: $OSTYPE"
		return 1
	fi
}


culst(){
	if [ -z "$1" ]; then
		echo "Usage: culst <port>"
		return 1
	fi

	local port="$1"
	curl "http://localhost:$port"
}


# git
ignore(){
	if [[ "$(uname)" == "Darwin" ]] || [[ "$(uname)" == "Linux" ]]; then
		language=$(echo "$1" | awk '{print toupper(substr($0,1,1)) tolower(substr($0,2))}')
	elif [[ "$(uname -o)" == "Msys" ]] || [[ "$(uname -o)" == "Cygwin" ]] || [[ "$(uname -o)" == "Windows_NT" ]]; then
		language=$(echo "$1" | sed -r "s/^./\U&/")
	fi

	if [[ "$language" == "Spring" ]]; then
		curl https://raw.githubusercontent.com/spring-projects/spring-framework/refs/heads/main/.gitignore > .gitignore
	elif  [[ "$language" == "Fastapi" ]]; then
		curl https://raw.githubusercontent.com/fastapi/fastapi/refs/heads/master/.gitignore > .gitignore
	elif  [[ "$language" == "Node" ]]; then
		curl https://raw.githubusercontent.com/github/gitignore/refs/heads/main/Node.gitignore > .gitignore
	else 
		curl https://raw.githubusercontent.com/github/gitignore/refs/heads/main/$language.gitignore > .gitignore
	fi
}

# help

list(){
	echo "###### DOCKER ######"
	echo "up"
	echo "down"
	echo "pydocker"
	echo "jdocker"
	echo "build <image:dev>"
	echo "rmi"
	echo ""
	echo "###### PYTHON ######"
	echo "venv <py:version>"
	echo "activate"
	echo "rr"
	echo "requirements"
	echo "freeze"
	echo "fast"
	echo "run <port>"
	echo "db"
	echo ""
	echo "###### BASH COMMAND ######"
	echo "pk <port>"
	echo "host <port>"
	echo "cost <port>"
	echo ""
	echo "###### github COMMAND ######"
	echo "ignore <language>"
	echo ""
	echo "###### util COMMAND ######"
	echo ct
	echo "rcopy <str>"
	echo "after <num>"
}


## utils
ct(){
	echo 'import sys' > codingTest.py
	echo '' >> codingTest.py
	echo 'input = sys.stdin.readline' >> codingTest.py
	echo '' >> codingTest.py
	echo 'def spt():' >> codingTest.py
	echo '    return input().split(" ")' >> codingTest.py
	echo '' >> codingTest.py
	echo '' >> codingTest.py
	echo 'def spt_map_int():' >> codingTest.py
	echo '    return list(map(int, input().split(" ")))' >> codingTest.py
	echo '' >> codingTest.py
	echo '' >> codingTest.py
	echo 'def assertEqual(a, b):' >> codingTest.py
	echo '    assert a == b' >> codingTest.py
}

rcopy(){
	reversed=$(echo $1 | awk '{ for(i=length; i>0; i--) printf "%s", substr($0, i, 1); print "" }')
	
	if [[ "$OSTYPE" == "linux-gnu"* ]]; then
		if command -v xclip &> /dev/null; then
			echo "$reversed" | xclip -selection clipboard
		else
			echo "xclip이 설치되어 있지 않습니다. 설치 후 사용하세요."
		fi
	elif [[ "$OSTYPE" == "darwin"* ]]; then
		echo "$reversed" | pbcopy
	elif [[ "$OSTYPE" == "cygwin" || "$OSTYPE" == "msys" ]]; then
		echo "$reversed" | clip
	else
		echo "Not supported OS"
	fi
}

after(){
	if [ -z "$1" ]; then
		echo "start 20 rest 8"
		return 1
	fi
	
	if [ -n "$2" ]; then
		year=$(date +%Y)
		base_date="$year-$2"
	else
		base_date=$(date +%Y-%m-%d)
	fi
	
	future_date=$(date -d "$base_date +$1 days" +%Y-%m-%d)
	echo $future_date
}
