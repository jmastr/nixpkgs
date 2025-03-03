{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  setuptools-scm,
  wheel,
  colorama,
  configupdater,
  importlib-metadata,
  packaging,
  platformdirs,
  tomlkit,
  pre-commit,
  pyscaffoldext-cookiecutter,
  pyscaffoldext-custom-extension,
  pyscaffoldext-django,
  pyscaffoldext-dsproject,
  pyscaffoldext-markdown,
  pyscaffoldext-travis,
  virtualenv,
  build,
  certifi,
  flake8,
  pytest,
  pytest-cov,
  pytest-randomly,
  pytest-xdist,
  sphinx,
  tox,
}:

buildPythonPackage rec {
  pname = "pyscaffold";
  version = "4.6";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-QIW43pIAufMZ32+Op5lyiPFZqOSyhLBi2bKk1qnBI0w=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
    wheel
  ];

  postPatch = ''
    substituteInPlace setup.cfg --replace "platformdirs>=2,<4" "platformdirs"
  '';

  propagatedBuildInputs = [
    colorama
    configupdater
    importlib-metadata
    packaging
    platformdirs
    setuptools
    setuptools-scm
    tomlkit
  ];

  optional-dependencies = {
    all = [
      pre-commit
      pyscaffoldext-cookiecutter
      pyscaffoldext-custom-extension
      pyscaffoldext-django
      pyscaffoldext-dsproject
      pyscaffoldext-markdown
      pyscaffoldext-travis
      virtualenv
    ];
    ds = [ pyscaffoldext-dsproject ];
    md = [ pyscaffoldext-markdown ];
    testing = [
      build
      certifi
      flake8
      pre-commit
      pytest
      pytest-cov
      pytest-randomly
      pytest-xdist
      setuptools
      setuptools-scm
      sphinx
      tomlkit
      tox
      virtualenv
      wheel
    ];
  };

  pythonImportsCheck = [ "pyscaffold" ];

  meta = with lib; {
    description = "Template tool for putting up the scaffold of a Python project";
    mainProgram = "putup";
    homepage = "https://pypi.org/project/PyScaffold/";
    license = licenses.mit;
    maintainers = with maintainers; [ matthewcroughan ];
  };
}
