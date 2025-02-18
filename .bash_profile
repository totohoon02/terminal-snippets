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
