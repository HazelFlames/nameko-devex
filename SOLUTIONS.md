# CUSTOMIZATIONS

## _conda_/_mamba_ environment

- Fixed the version of _importlib-metadata_ to 4.13.0 because from v5.0.0 onwards the compatibility with Python 3.7 has been broken.
- Fixed the version of _alembic_ to 1.9.3 because of importing issues with the old one.

# TESTING OUTPUT

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

# DEPLOYMENT

## 1. Docker installation

### 1.1 WSL2

## 2. _kubectl_ installation

## 3. Cluster creation

### 3.1 K3d

## 4. Epinio installation

### 4.1 Epinio setup

## 5. Application deployment
