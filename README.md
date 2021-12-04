# SST-Completions

This project provides bash auto-complete suggestions for sst-info, which is a part of the [SST Simulator](https://sst-simulator.org/). It provides information about the components you have installed. As SST-Elements provides so many components, it can be difficult to parse this list. This command should make it easier to explore your installed components!

Hopefully, this will be integrated into [sst-core](https://github.com/sstsimulator/sst-core). Please open an issue if you have suggestions for how to improve this script or if you think some other sst command needs completions.

## Installation

You simply need to source the `sst-info-completions.bash` file. It will run sst-info to get a list of elements and components. If you add more components, you should re-run this script.

Add the following line to your .bashrc, after sst-info is available.

```source ~/sst-completion/sst-info-completion.bash```

## TODOs

* Integrate this into the sst-core installation script, and make sure it is updated when new elements are added either throughy the sst-elements installation or sst-register.

* Test with zsh and ksh.

* Test with [shellcheck](https://www.shellcheck.net/).

* Figure out how to properly install this, either in `~/.bash_completion` or in whatever [this guide](https://github.com/scop/bash-completion/blob/master/README.md#faq) says.

* Fix weird cassini completion.


## Thanks

I used Lazarus Lazaridis's [guide](https://iridakos.com/programming/2018/03/01/bash-programmable-completion-tutorial) to create this script. There are some good link at the end of his post. [Archive](https://web.archive.org/web/20211027111231/https://iridakos.com/programming/2018/03/01/bash-programmable-completion-tutorial).
