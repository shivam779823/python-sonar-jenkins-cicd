from main import app

def test_main():
    response = app.test_client().get('/')
    assert b"MY TECH WORLD!" in response.data
    assert response.status_code == 200


def test_login():
    response = app.test_client().get('/login')

    assert response.status_code == 200

def test_fun():
    response = app.test_client().get('/fact')
    assert b"Redirecting" in response.data
    assert response.status_code == 308

def test_data():
    response = app.test_client().get('/Data')
    assert b"name" in response.data
    assert response.status_code == 200

