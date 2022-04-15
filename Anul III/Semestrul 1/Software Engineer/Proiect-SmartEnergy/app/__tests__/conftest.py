import pytest

from app.main import initiateFlask

from app.util.database import Database

context = dict(
    app=initiateFlask(testing=True),
)


@pytest.fixture(autouse=True)
def clean_database_between_tests():
    with context['app'].app_context():
        Database.importRelevantData(context['app'], testing=True)
        yield
        Database.cleanDatabase()


@pytest.fixture(autouse=True)
def run_before_all_tests():
    with context['app'].app_context():
        yield


@pytest.fixture(scope="function", autouse=True)
def client():
    with context['app'].test_client() as client:
        return client
    