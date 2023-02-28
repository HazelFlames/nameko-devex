# CUSTOMIZATIONS

## _conda_/_mamba_ environment

- Upgraded and locked the version of _importlib-metadata_ to 4.13.0 because from v5.0.0 upwards the compatibility with Python 3.7 has been broken.
- Upgraded and locked the version of _alembic_ to 1.9 because of class importing issues with the _sqlalchemy_ and _nameko-sqlalchemy_ versions.

---

# TESTING OUTPUT

## _nex-smoketest_

```sh
◈ ./test/nex-smoketest.sh local
Local Smoke Test
STD_APP_URL=http://localhost:8000
=== Creating a product id: the_odyssey ===
{"id": "the_odyssey"}127.0.0.1 - - [13/Feb/2023 14:03:12] "POST /products HTTP/1.1" 200 129 0.050800

=== Getting product id: the_odyssey ===
127.0.0.1 - - [13/Feb/2023 14:03:12] "GET /products/the_odyssey HTTP/1.1" 200 217 0.042636
{
  "id": "the_odyssey",
  "title": "The Odyssey",
  "in_stock": 10,
  "maximum_speed": 5,
  "passenger_capacity": 101
}
=== Creating Order ===
127.0.0.1 - - [13/Feb/2023 14:03:12] "POST /orders HTTP/1.1" 200 116 0.127800
{"id": 1}
=== Getting Order ===
127.0.0.1 - - [13/Feb/2023 14:03:13] "GET /orders/1 HTTP/1.1" 200 400 0.055583
{
  "id": 1,
  "order_details": [
    {
      "id": 1,
      "product_id": "the_odyssey",
      "quantity": 1,
      "price": "100000.99",
      "image": "http://www.example.com/airship/images/the_odyssey.jpg",
      "product": {
        "id": "the_odyssey",
        "title": "The Odyssey",
        "in_stock": 9,
        "maximum_speed": 5,
        "passenger_capacity": 101
      }
    }
  ]
}
(nameko-devex) matt in nameko-devex on  master [!]
```

## _dev_pytest_

After running ./dev_pytest.sh, the output is the following:

```sh
◈ ./dev_pytest.sh
=========================================== test session starts ============================================
platform linux -- Python 3.7.12, pytest-4.5.0, py-1.11.0, pluggy-0.13.1
rootdir: /home/matt/Desenvolvimento/nameko-devex/gateway
plugins: anyio-3.6.2, nameko-sqlalchemy-1.5.0, apiritif-1.1.3, nameko-3.0.0rc9
collected 16 items

gateway/test/interface/test_service.py ...........                                                   [ 68%]
gateway/test/unit/test_entrypoints.py .....                                                          [100%]

============================================= warnings summary =============================================
/home/matt/Aplicativos/mambaforge/envs/nameko-devex/lib/python3.7/site-packages/marshmallow/__init__.py:19
  /home/matt/Aplicativos/mambaforge/envs/nameko-devex/lib/python3.7/site-packages/marshmallow/__init__.py:19: DeprecationWarning: distutils Version classes are deprecated. Use packaging.version instead.
    __version_info__ = tuple(LooseVersion(__version__).version)

/home/matt/Aplicativos/mambaforge/envs/nameko-devex/lib/python3.7/site-packages/kombu/utils/compat.py:93
  /home/matt/Aplicativos/mambaforge/envs/nameko-devex/lib/python3.7/site-packages/kombu/utils/compat.py:93: DeprecationWarning: SelectableGroups dict interface is deprecated. Use select.
    for ep in importlib_metadata.entry_points().get(namespace, [])

/home/matt/Aplicativos/mambaforge/envs/nameko-devex/lib/python3.7/site-packages/nameko/messaging.py:38
  /home/matt/Aplicativos/mambaforge/envs/nameko-devex/lib/python3.7/site-packages/nameko/messaging.py:38: DeprecationWarning: invalid escape sequence \.
    re.sub("^{}\.".format(prefix), "", key): value

-- Docs: https://docs.pytest.org/en/latest/warnings.html
================================== 16 passed, 3 warnings in 6.81 seconds ===================================
=========================================== test session starts ============================================
platform linux -- Python 3.7.12, pytest-4.5.0, py-1.11.0, pluggy-0.13.1
rootdir: /home/matt/Desenvolvimento/nameko-devex/orders
plugins: anyio-3.6.2, nameko-sqlalchemy-1.5.0, apiritif-1.1.3, nameko-3.0.0rc9
collected 7 items

orders/test/interface/test_service.py .....                                                          [ 71%]
orders/test/unit/test_models.py ..E                                                                  [100%]

================================================== ERRORS ==================================================
____________________________ ERROR at teardown of test_can_create_order_detail _____________________________

tp = <class 'TypeError'>, value = None, tb = None

    def reraise(tp, value, tb=None):
        try:
            if value is None:
                value = tp()
            if value.__traceback__ is not tb:
                raise value.with_traceback(tb)
>           raise value

../../Aplicativos/mambaforge/envs/nameko-devex/lib/python3.7/site-packages/six.py:719:
_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
../../Aplicativos/mambaforge/envs/nameko-devex/lib/python3.7/site-packages/six.py:719: in reraise
    raise value
../../Aplicativos/mambaforge/envs/nameko-devex/lib/python3.7/site-packages/six.py:719: in reraise
    raise value
_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _

db_url = 'sqlite:///orders.sql', model_base = <class 'sqlalchemy.orm.decl_api.Base'>, db_engine_options = {}

    @pytest.yield_fixture(scope='session')
    def db_connection(db_url, model_base, db_engine_options):
        engine = create_engine(db_url, **db_engine_options)
        model_base.metadata.create_all(engine)
        connection = engine.connect()
        model_base.metadata.bind = engine

        yield connection

>       model_base.metadata.drop_all()
E       TypeError: drop_all() missing 1 required positional argument: 'bind'

../../Aplicativos/mambaforge/envs/nameko-devex/lib/python3.7/site-packages/nameko_sqlalchemy/pytest_fixtures.py:127: TypeError
============================================= warnings summary =============================================
/home/matt/Aplicativos/mambaforge/envs/nameko-devex/lib/python3.7/site-packages/kombu/utils/compat.py:93
  /home/matt/Aplicativos/mambaforge/envs/nameko-devex/lib/python3.7/site-packages/kombu/utils/compat.py:93: DeprecationWarning: SelectableGroups dict interface is deprecated. Use select.
    for ep in importlib_metadata.entry_points().get(namespace, [])

/home/matt/Aplicativos/mambaforge/envs/nameko-devex/lib/python3.7/site-packages/marshmallow/__init__.py:19
  /home/matt/Aplicativos/mambaforge/envs/nameko-devex/lib/python3.7/site-packages/marshmallow/__init__.py:19: DeprecationWarning: distutils Version classes are deprecated. Use packaging.version instead.
    __version_info__ = tuple(LooseVersion(__version__).version)

test/interface/test_service.py::test_get_order
test/interface/test_service.py::test_will_raise_when_order_not_found
test/interface/test_service.py::test_can_create_order
test/interface/test_service.py::test_can_update_order
test/interface/test_service.py::test_can_delete_order
  /home/matt/Aplicativos/mambaforge/envs/nameko-devex/lib/python3.7/site-packages/nameko/containers.py:163: DeprecationWarning: Use ``nameko.config`` instead.
    warnings.warn("Use ``nameko.config`` instead.", DeprecationWarning)

test/interface/test_service.py::test_get_order
test/interface/test_service.py::test_will_raise_when_order_not_found
  /home/matt/Desenvolvimento/nameko-devex/orders/orders/service.py:18: LegacyAPIWarning: The Query.get() method is considered legacy as of the 1.x series of SQLAlchemy and becomes a legacy construct in 2.0. The method is now available as Session.get() (deprecated since: 2.0) (Background on SQLAlchemy 2.0 at: https://sqlalche.me/e/b8d9)
    order = self.db.query(Order).get(order_id)

test/interface/test_service.py::test_can_update_order
  /home/matt/Desenvolvimento/nameko-devex/orders/orders/service.py:55: LegacyAPIWarning: The Query.get() method is considered legacy as of the 1.x series of SQLAlchemy and becomes a legacy construct in 2.0. The method is now available as Session.get() (deprecated since: 2.0) (Background on SQLAlchemy 2.0 at: https://sqlalche.me/e/b8d9)
    order = self.db.query(Order).get(order['id'])

test/interface/test_service.py::test_can_delete_order
  /home/matt/Desenvolvimento/nameko-devex/orders/orders/service.py:66: LegacyAPIWarning: The Query.get() method is considered legacy as of the 1.x series of SQLAlchemy and becomes a legacy construct in 2.0. The method is now available as Session.get() (deprecated since: 2.0) (Background on SQLAlchemy 2.0 at: https://sqlalche.me/e/b8d9)
    order = self.db.query(Order).get(order_id)

-- Docs: https://docs.pytest.org/en/latest/warnings.html
============================== 7 passed, 11 warnings, 1 error in 5.76 seconds ==============================
=========================================== test session starts ============================================
platform linux -- Python 3.7.12, pytest-4.5.0, py-1.11.0, pluggy-0.13.1
rootdir: /home/matt/Desenvolvimento/nameko-devex/products
plugins: anyio-3.6.2, nameko-sqlalchemy-1.5.0, apiritif-1.1.3, nameko-3.0.0rc9
collected 25 items

products/test/test_dependencies.py .....                                                             [ 20%]
products/test/test_service.py ....................                                                   [100%]

============================================= warnings summary =============================================
/home/matt/Aplicativos/mambaforge/envs/nameko-devex/lib/python3.7/site-packages/marshmallow/__init__.py:19
  /home/matt/Aplicativos/mambaforge/envs/nameko-devex/lib/python3.7/site-packages/marshmallow/__init__.py:19: DeprecationWarning: distutils Version classes are deprecated. Use packaging.version instead.
    __version_info__ = tuple(LooseVersion(__version__).version)

/home/matt/Aplicativos/mambaforge/envs/nameko-devex/lib/python3.7/site-packages/kombu/utils/compat.py:93
  /home/matt/Aplicativos/mambaforge/envs/nameko-devex/lib/python3.7/site-packages/kombu/utils/compat.py:93: DeprecationWarning: SelectableGroups dict interface is deprecated. Use select.
    for ep in importlib_metadata.entry_points().get(namespace, [])

-- Docs: https://docs.pytest.org/en/latest/warnings.html
================================== 25 passed, 2 warnings in 15.33 seconds ==================================
(nameko-devex) matt in nameko-devex on  master [!] took 35s
```

## _nex-bzt_

- BlazeMeter [test output](https://a.blazemeter.com/app/?public-token=ANkzGzlqqf7gf6EsiOoAUQuFhnAkswi6zRjfAtMHxMKLImHHlT#reports/r-ext-63ea732122621101613580/summary).

## FastAPI

### Local Smoke Test:

```sh
◈ ./test/nex-smoketest.sh local
Local Smoke Test
STD_APP_URL=http://localhost:8000
=== Creating a product id: the_odyssey ===
{"id":"the_odyssey"}
=== Getting product id: the_odyssey ===
{
  "id": "the_odyssey",
  "title": "The Odyssey",
  "passenger_capacity": 101,
  "maximum_speed": 5,
  "in_stock": 10
}
=== Creating Order ===
{"id":268}
=== Getting Order ===
{
  "order_details": [
    {
      "quantity": 1,
      "id": 268,
      "product_id": "the_odyssey",
      "price": "100000.99",
      "product": {
        "id": "the_odyssey",
        "maximum_speed": 5,
        "title": "The Odyssey",
        "in_stock": 9,
        "passenger_capacity": 101
      },
      "image": "http://www.example.com/airship/images/the_odyssey.jpg"
    }
  ],
  "id": 268
}
```

### _nex-bzt_:

BlazeMeter [test output 2](https://a.blazemeter.com/app/?public-token=5if6RerrAkf6Vhhk2F5xH7sPiUwDrej2hf7RTJepv2UZQWSUQW#reports/r-ext-63ea773513245569842915/summary).

### Manual API testing

```sh
◈ curl http://localhost:8000/docs

    <!DOCTYPE html>
    <html>
    <head>
    <link type="text/css" rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swagger-ui-dist@3/swagger-ui.css">
    <link rel="shortcut icon" href="https://fastapi.tiangolo.com/img/favicon.png">
    <title>FastAPI - Swagger UI</title>
    </head>
    <body>
    <div id="swagger-ui">
    </div>
    <script src="https://cdn.jsdelivr.net/npm/swagger-ui-dist@3/swagger-ui-bundle.js"></script>
    <!-- `SwaggerUIBundle` is now available on the page -->
    <script>
    const ui = SwaggerUIBundle({
        url: '/openapi.json',
    oauth2RedirectUrl: window.location.origin + '/docs/oauth2-redirect',
        dom_id: '#swagger-ui',
        presets: [
        SwaggerUIBundle.presets.apis,
        SwaggerUIBundle.SwaggerUIStandalonePreset
        ],
        layout: "BaseLayout",
        deepLinking: true,
        showExtensions: true,
        showCommonExtensions: true
    })
    </script>
    </body>
    </html>
    %
(nameko-devex) matt in nameko-devex on  master
```

```sh
◈ curl http://localhost:8000/redoc

    <!DOCTYPE html>
    <html>
    <head>
    <title>FastAPI - ReDoc</title>
    <!-- needed for adaptive design -->
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link href="https://fonts.googleapis.com/css?family=Montserrat:300,400,700|Roboto:300,400,700" rel="stylesheet">

    <link rel="shortcut icon" href="https://fastapi.tiangolo.com/img/favicon.png">
    <!--
    ReDoc doesn't change outer page styles
    -->
    <style>
      body {
        margin: 0;
        padding: 0;
      }
    </style>
    </head>
    <body>
    <redoc spec-url="/openapi.json"></redoc>
    <script src="https://cdn.jsdelivr.net/npm/redoc@next/bundles/redoc.standalone.js"> </script>
    </body>
    </html>
    %
```

---

# DEPLOYMENT

I've customized the `Makefile` to keep using the single command automation with the new code.

## Docker + Compose

I've rewritten the `Dockerfile`(s) and the `docker-compose.yaml` to better reflect what I've tested in the previous exercise and ensure consistent behavior.

- In the `Dockerfile`, I chose to deploy a lightweight `micromamba` container based on `mamba` (which is an improved `conda` but without the science packages, and the engine is made in C++ instead of Python), and from there I can manage the versions, dependencies, and environments for the Python packages. As with `conda`, `micromamba` can cross-fetch dependencies and build packages.
- In the `docker-compose.yaml`, I've changed the names and versions of the images to be the same as in the testing environment.
- I've changed the network implementation in the `docker-compose.yaml` from `links` to `network` as recommended by the official documentation and created the respective aliases for each service.
- I had to add the `PYTHONPATH` variable in the `docker-compose.yaml` for the modules to be correctly initialized without altering the application source code.

### BlazeMeter

BlazeMeter [test output 3](https://a.blazemeter.com/app/?public-token=516OBeX57tmrvTvqs9YB3YNI1Ax0sqpQ93iL4hLugmfooHDYF3#reports/r-ext-63efca760ec3e714010604/summary)

## KinD + Helm

- After installation and setup of _KinD_, `kubectl` and _Helm_, the deployment is pretty straightforward. It's just a matter of passing a _Chart_ (with its respective `Values.yaml` and appropriate variables) file to _Helm_ and it does all the rest with magic!
- The Charts were updated to use the Docker images I created in the previous exercise.
- _Bash_ scripts were created to prepare all the underlying infrastructure in _KinD_ and _Helm_, with rollback steps in case of failure and they can all be called via make commands defined in the `k8s/Makefile`.
- The application images need to be cloned to KinD internal image registry and this is done by the `make deploy` step.

### BlazeMeter

BlazeMeter [test output 4](https://a.blazemeter.com/app/?public-token=516OBeX57tmrvTvqs9YB3YNI1Ax0sqpQ93iL4hLugmfooHDYF3#reports/r-ext-63efca760ec3e714010604/summary)

## Epinio

### Setup

- A K3d cluster was created as per Henrique's recommendations following the official documentation from Epinio.
- The creation is automated and can be called by the Makefile inside the `epinio` folder.
  - It deploys the K3d cluster, the internal database service, and then the application.

### Deployment

- The deployment of the services and the application can also be called by the Makefile and its options are set in the `manifest.yaml` file.
- The `nameko-devex` can't be deployed as is in Epinio (or in any other Buildpack-based solution whatsoever) because the builders can't handle different channels (like _conda-forge_ and _PyPI_) in the `conda` `environment.yml` file and the application is built upon this.
  - I've tried to convert it to a `pip` environment based application but it didn't work.
  - One solution to try to solve this issue is to make a customized `builder` image for this purpose.
  - I could use the ready-to-go application image built in the _Docker Compose_ exercise, but it kind of defeats the purpose of using a tool like Epinio, which can build the entire application from the source code directly.
- I then went with a simple "To-do list" application written in Go, that can be deployed in Epinio and connected to its available services while leveraging the same automated structure to install everything.
  - It leverages the _Services_ structure provided by Epinio to deploy a PostgreSQL database.
  - With Epinio CLI, the internal address that the application will use to connect to the service can be extracted and passed on to runtime via environment variables.
  - The database and the tables are created and verified by the application.

###

# UPDATE - Feb 28, 2023

Found the issue. The Python Paketo Bildpack can't resolve the *`pip`* part from the `enrionment.yml` directly. So it's a matter of installing the `pip` dependencies after the application is deployed in Epinio but before it initializes (which is still a little awkward).
