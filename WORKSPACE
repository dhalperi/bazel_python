workspace(
    name = "bazel_python",
)

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

## Load custom python interpreter
load("//python/interpreter:repo.bzl", "python_repo")

python_repo(name = "python_interpreter")

register_toolchains("//python/interpreter:py_toolchain")

http_archive(
    name = "rules_python",
    sha256 = "95ee649313caeb410b438b230f632222fb5d2053e801fe4ae0572eb1d71e95b8",
    strip_prefix = "rules_python-c8c79aae9aa1b61d199ad03d5fe06338febd0774",
    url = "https://github.com/bazelbuild/rules_python/archive/c8c79aae9aa1b61d199ad03d5fe06338febd0774.tar.gz",
)

load("@rules_python//python:repositories.bzl", "py_repositories")

py_repositories()

load("@rules_python//python:pip.bzl", "pip_install")

pip_install(
    python_interpreter_target = "@python_interpreter//python_install/bin:python3",
    requirements = "//:requirements.txt",
)
