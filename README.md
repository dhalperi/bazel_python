# Example bazel+python repository

This repository is an attempt to model a useful, hermetic Bazel + Python installation.

* Provide a custom interpreter in `//interpreter`, derived from the instructions in a variety of places.
* Use the new `rules_python` functionality based on `rules_python_external` to include transitive Python dependencies and use the custom interpreter.
* Demonstrate Jupyter notebook integration in `//notebook`.
* Pin python requirements using `pip-compile`, `requirements.in`, and `requirements.txt`.

# Known issues:
* When running jupyter notebook (`bazel run //notebook`), you cannot download any notebook. It fails with a `500 Internal Server` error in the browser, and the following console output:

    ```
    HTTPServerRequest(protocol='http', host='localhost:8888', method='GET', uri='/nbconvert/pdf/test.ipynb?download=true', version='HTTP/1.1', remote_ip='::1')
    Traceback (most recent call last):
      File "/private/var/tmp/_bazel_dan/86075a8c64916cc92a0fec233d0053c0/execroot/bazel_python/bazel-out/darwin-fastbuild/bin/notebook/notebook.runfiles/pip/pypi__traitlets/traitlets/traitlets.py", line 535, in get
        value = obj._trait_values[self.name]
    KeyError: 'template_paths'

    During handling of the above exception, another exception occurred:

    Traceback (most recent call last):
      File "/private/var/tmp/_bazel_dan/86075a8c64916cc92a0fec233d0053c0/execroot/bazel_python/bazel-out/darwin-fastbuild/bin/notebook/notebook.runfiles/pip/pypi__tornado/tornado/web.py", line 1704, in _execute
        result = await result
      File "/private/var/tmp/_bazel_dan/86075a8c64916cc92a0fec233d0053c0/execroot/bazel_python/bazel-out/darwin-fastbuild/bin/notebook/notebook.runfiles/pip/pypi__tornado/tornado/gen.py", line 234, in wrapper
        yielded = ctx_run(next, result)
      File "/private/var/tmp/_bazel_dan/86075a8c64916cc92a0fec233d0053c0/execroot/bazel_python/bazel-out/darwin-fastbuild/bin/notebook/notebook.runfiles/pip/pypi__notebook/notebook/nbconvert/handlers.py", line 92, in get
        exporter = get_exporter(format, config=self.config, log=self.log)
      File "/private/var/tmp/_bazel_dan/86075a8c64916cc92a0fec233d0053c0/execroot/bazel_python/bazel-out/darwin-fastbuild/bin/notebook/notebook.runfiles/pip/pypi__notebook/notebook/nbconvert/handlers.py", line 67, in get_exporter
        Exporter = get_exporter(format)
      File "/private/var/tmp/_bazel_dan/86075a8c64916cc92a0fec233d0053c0/execroot/bazel_python/bazel-out/darwin-fastbuild/bin/notebook/notebook.runfiles/pip/pypi__nbconvert/nbconvert/exporters/base.py", line 102, in get_exporter
        if getattr(exporter(config=config), 'enabled', True):
      File "/private/var/tmp/_bazel_dan/86075a8c64916cc92a0fec233d0053c0/execroot/bazel_python/bazel-out/darwin-fastbuild/bin/notebook/notebook.runfiles/pip/pypi__nbconvert/nbconvert/exporters/templateexporter.py", line 325, in __init__
        super().__init__(config=config, **kw)
      File "/private/var/tmp/_bazel_dan/86075a8c64916cc92a0fec233d0053c0/execroot/bazel_python/bazel-out/darwin-fastbuild/bin/notebook/notebook.runfiles/pip/pypi__nbconvert/nbconvert/exporters/exporter.py", line 114, in __init__
        self._init_preprocessors()
      File "/private/var/tmp/_bazel_dan/86075a8c64916cc92a0fec233d0053c0/execroot/bazel_python/bazel-out/darwin-fastbuild/bin/notebook/notebook.runfiles/pip/pypi__nbconvert/nbconvert/exporters/templateexporter.py", line 491, in _init_preprocessors
        conf = self._get_conf()
      File "/private/var/tmp/_bazel_dan/86075a8c64916cc92a0fec233d0053c0/execroot/bazel_python/bazel-out/darwin-fastbuild/bin/notebook/notebook.runfiles/pip/pypi__nbconvert/nbconvert/exporters/templateexporter.py", line 507, in _get_conf
        for path in map(Path, self.template_paths):
      File "/private/var/tmp/_bazel_dan/86075a8c64916cc92a0fec233d0053c0/execroot/bazel_python/bazel-out/darwin-fastbuild/bin/notebook/notebook.runfiles/pip/pypi__traitlets/traitlets/traitlets.py", line 575, in __get__
        return self.get(obj, cls)
      File "/private/var/tmp/_bazel_dan/86075a8c64916cc92a0fec233d0053c0/execroot/bazel_python/bazel-out/darwin-fastbuild/bin/notebook/notebook.runfiles/pip/pypi__traitlets/traitlets/traitlets.py", line 538, in get
        default = obj.trait_defaults(self.name)
      File "/private/var/tmp/_bazel_dan/86075a8c64916cc92a0fec233d0053c0/execroot/bazel_python/bazel-out/darwin-fastbuild/bin/notebook/notebook.runfiles/pip/pypi__traitlets/traitlets/traitlets.py", line 1578, in trait_defaults
        return self._get_trait_default_generator(names[0])(self)
      File "/private/var/tmp/_bazel_dan/86075a8c64916cc92a0fec233d0053c0/execroot/bazel_python/bazel-out/darwin-fastbuild/bin/notebook/notebook.runfiles/pip/pypi__traitlets/traitlets/traitlets.py", line 975, in __call__
        return self.func(*args, **kwargs)
      File "/private/var/tmp/_bazel_dan/86075a8c64916cc92a0fec233d0053c0/execroot/bazel_python/bazel-out/darwin-fastbuild/bin/notebook/notebook.runfiles/pip/pypi__nbconvert/nbconvert/exporters/templateexporter.py", line 518, in _template_paths
        template_names = self.get_template_names()
      File "/private/var/tmp/_bazel_dan/86075a8c64916cc92a0fec233d0053c0/execroot/bazel_python/bazel-out/darwin-fastbuild/bin/notebook/notebook.runfiles/pip/pypi__nbconvert/nbconvert/exporters/templateexporter.py", line 601, in get_template_names
        raise ValueError('No template sub-directory with name %r found in the following paths:\n\t%s' % (base_template, paths))
    ValueError: No template sub-directory with name 'latex' found in the following paths:
      /Users/dan/Library/Jupyter
      /private/var/tmp/_bazel_dan/86075a8c64916cc92a0fec233d0053c0/external/python_interpreter/python_install/share/jupyter
      /usr/local/share/jupyter
      /usr/share/jupyter
    ```

    It seems that the paths are not properly set up for nbconvert to find its plugins.

* There's something funky about `Ctrl-C` handling in the Jupyter notebook.

    ```
    [I 11:57:14.524 NotebookApp] Serving notebooks from local directory: /Users/dan/notebooks
    [I 11:57:14.524 NotebookApp] Jupyter Notebook 6.2.0 is running at:
    [I 11:57:14.524 NotebookApp] http://localhost:8888/
    [I 11:57:14.524 NotebookApp] Use Control-C to stop this server and shut down all kernels (twice to skip confirmation).
    [I 11:57:23.425 NotebookApp] Kernel started: 35867f0e-b967-4f0e-9a16-97db96315b18, name: python3
    [I 11:57:26.806 NotebookApp] Kernel started: 520f7e76-5995-484b-aad8-85982ecd026f, name: python3
    [I 11:57:29.422 NotebookApp] Kernel started: 02f700af-54cd-4738-9901-a92063b997cf, name: python3
    ^C[I 11:57:32.600 NotebookApp] interrupted
    Serving notebooks from local directory: /Users/dan/notebooks
    3 active kernels
    Jupyter Notebook 6.2.0 is running at:
    http://localhost:8888/[I 11:57:32.601 NotebookApp] interrupted
    Serving notebooks from local directory: /Users/dan/notebooks
    3 active kernels
    Jupyter Notebook 6.2.0 is running at:
    http://localhost:8888/

    Shutdown this notebook server (y/[n])? Shutdown this notebook server (y/[n])?
    resuming operation...
    ^C[I 11:57:38.103 NotebookApp] interrupted
    Serving notebooks from local directory: /Users/dan/notebooks
    3 active kernels
    Jupyter Notebook 6.2.0 is running at:
    http://localhost:8888/
    Shutdown this notebook server (y/[n])? ^C[C 11:57:40.004 NotebookApp] received signal 2, stopping
    [I 11:57:40.005 NotebookApp] Shutting down 3 kernels
    No answer for 5s: resuming operation...
    [I 11:57:45.140 NotebookApp] Kernel shutdown: 35867f0e-b967-4f0e-9a16-97db96315b18
    [I 11:57:45.244 NotebookApp] Kernel shutdown: 520f7e76-5995-484b-aad8-85982ecd026f
    [I 11:57:45.347 NotebookApp] Kernel shutdown: 02f700af-54cd-4738-9901-a92063b997cf
    [I 11:57:45.348 NotebookApp] Shutting down 0 terminals
    [I 11:57:45.357 NotebookApp] KernelRestarter: restarting kernel (1/5), keep random ports
    WARNING:root:kernel 35867f0e-b967-4f0e-9a16-97db96315b18 restarted
    [I 11:57:45.370 NotebookApp] KernelRestarter: restarting kernel (1/5), keep random ports
    WARNING:root:kernel 02f700af-54cd-4738-9901-a92063b997cf restarted
    [I 11:57:45.415 NotebookApp] KernelRestarter: restarting kernel (1/5), keep random ports
    WARNING:root:kernel 520f7e76-5995-484b-aad8-85982ecd026f restarted
    (bazel-ide) ➜  bazel_python git:(master) ✗ [IPKernelApp] WARNING | Parent appears to have exited, shutting down.
    [IPKernelApp] WARNING | Parent appears to have exited, shutting down.
    [IPKernelApp] WARNING | Parent appears to have exited, shutting down.
    ```

    At `11:57:32.600`, I hit `Ctrl-C` once and it printed the message twice then recovered

    Then at `11:57:38.103` and `11:57:40.005` I hit it twice. It tried to `Shutting down 3 kernels`. Then it logs about `No answer for 5s: resuming operation`, followed by `Kernel shutdown`, then `Shutting down 0 terminals` immediately followed by `KernelRestart` logs trying to restart them. Then after I get my terminal back, `Parent appears to have exited, shutting down.`

    I'm doing something really wrong here.
