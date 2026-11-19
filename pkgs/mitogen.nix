{
  lib,
  python3Packages,
  fetchFromGitHub,
  nix-update-script,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "mitogen";
  version = "0.3.55";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "mitogen-hq";
    repo = "mitogen";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3o8rsVKIMw2cwcQiHbPZMZ3xIyDpfokAIZQTQCDEDJc=";
  };

  build-system = [
    python3Packages.setuptools
  ];

  pythonImportsCheck = [
    "mitogen"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Distributed self-replicating programs in Python";
    homepage = "https://github.com/mitogen-hq/mitogen";
    changelog = "https://github.com/mitogen-hq/mitogen/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    mainProgram = "mitogen";
  };
})
