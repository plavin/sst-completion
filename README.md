# SST-Completions

This project provides bash auto-complete suggestions for sst-info, which is a part of the [SST Simulator](https://sst-simulator.org/). As SST-Elements provides so many components, it can be difficult to parse through what is available. This command should make it easier to explore your installed components!

Hopefully, this will be integrated into [sst-core](https://github.com/sstsimulator/sst-core). Please open an issue if you have suggestions for how to improve this script or if you think some other sst command needs completions.

## Installation

You simply need to source the `sst-info-completions.bash` file. It will run sst-info to get a list of elements and components. If you add more components, you should re-run this script.

Add the following line to your .bashrc, after sst-info is available.

```source ~/sst-completion/sst-info-completion.bash```

## Usage

This tool provides suggestions for sst-info arguments in 2 steps:

1. It will first try to guess which element you want. As long as there is no period in the argument, this is what the tool thinks you want to do. For example, typing the letter `m` will bring up elements starting with `m`.

```
$ sst-info m<TAB><TAB>
memHierarchy  merlin  miranda
```

2. If you continue to hit tab, you will be prompted with the names of components and subcomponents in that element.
```
$ sst-info miranda.R<TAB><TAB>
miranda.RandomGenerator  miranda.ReverseSingleStreamGenerator
```

## TODOs

* Integrate this into the sst-core installation script, and make sure it is updated when new elements are added either through the sst-elements installation or sst-register. At the same time, make this script more robust by generating the elements and components names.

* Figure out how to properly install this, either in `~/.bash_completion` or in whatever [this guide](https://github.com/scop/bash-completion/blob/master/README.md#faq) says.

## Thanks

I used Lazarus Lazaridis's [guide](https://iridakos.com/programming/2018/03/01/bash[programmable-completion-tutorial) to create this script. There are some good link at the end of his post.
