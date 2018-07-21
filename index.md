---
#
# By default, content added below the "---" mark will appear in the home page
# between the top bar and the list of recent posts.
# To change the home page layout, edit the _layouts/home.html file.
# See: https://jekyllrb.com/docs/themes/#overriding-theme-defaults
#
layout: home
---
The [duqt](https://github.com/mlxd/duqt) repo exists solely to install all quantum SDKs that
I can find (or at least have a public API, packages and/or hardware). 
While the majority of these are Python-based packages, some
work has gone into installing non pip/conda/src packages too.

The name is derived from duct-tape, with a Q to represent how I am attempting to tape all quantum SDKs together into a single environment (yes, it's an awful name, but that's fine). Things may break, things may fall over, but at least on my machines (Linux, MacOS, and Windows with the Linux subsystem), things seem to operate as expected. This installation script should be enough to acquire and install all packages, setup the environment, and give you access to [Strawberry Fields](https://strawberryfields.readthedocs.io/en/stable/), [Qiskit](https://qiskit.org/), [D-Wave Ocean](http://dw-docs.readthedocs.io/en/latest/), [ProjectQ](https://projectq.ch/), [MS QDK and Q#](https://www.microsoft.com/en-us/quantum/development-kit), [pyQuil](http://pyquil.readthedocs.io/en/latest/), [Cirq](https://cirq.readthedocs.io/en/latest/tutorial.html), as well as other packages such as [QuTiP](http://qutip.org/docs/latest/index.html), [QInfer](http://docs.qinfer.org/en/latest/) and [OpenFermion](http://openfermion.readthedocs.io/en/latest/openfermion.html).

Copy the following code into your terminal and give your machine about 10-15 minutes to do its thing: 
```bash
git clone https://github.com/mlxd/duqt && cd duqt
chmod +x ./CondInstall.sh && ./CondInstall.sh
source load_env.sh
jupyter notebook #or 'code' for Q# programming in VS Code
```

Things may break, but my hope is that this simplifies getting started with these many frameworks. Feel free to send suggestions, open PRs or just use the script to your own needs. Ideally, I aim for this project to develop an intermediate format to allow translation between each framework. Given a mapping between each new framework and the IL there is no need to require ports between each each newly added language/framework/hardware/etc. This is all time and funding dependent, and may require much more work than I can give.
