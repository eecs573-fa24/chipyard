# EECS 573 Instruction Setup
Follow usual steps needed to get chipyard setup.<br />
Make sure to be using the default (base) conda enviroment before running ./build-setup.sh<br />

When running ./build-setup.sh use the follow arguments: -s 5 -s 6 -s 7 -s 8 -s 9
* -s 5 is necessary as the CAM module dependencies are added in a later script causing compilation to fail

Source the env.sh file located in the chipyard directory<br />
Modify the following two file's heap size to 512K or larger depending on the test case you plan to run.
* Chipyard/.conda-env/riscv-tools/riscv64-unknown-elf/lib/htif.ld
* Chipyard/toolchains/libgloss/util/htif.ld

Navigate to Chipyard/scripts and run cam-setup.sh


![CHIPYARD](https://github.com/ucb-bar/chipyard/raw/main/docs/_static/images/chipyard-logo-full.png)

# Chipyard Framework [![Test](https://github.com/ucb-bar/chipyard/actions/workflows/chipyard-run-tests.yml/badge.svg)](https://github.com/ucb-bar/chipyard/actions)

## Quick Links

* **Latest Documentation**: https://chipyard.readthedocs.io/
* **User Question Forum**: https://groups.google.com/forum/#!forum/chipyard
* **Bugs and Feature Requests**: https://github.com/ucb-bar/chipyard/issues

## Using Chipyard

To get started using Chipyard, see the documentation on the Chipyard documentation site: https://chipyard.readthedocs.io/

## What is Chipyard

Chipyard is an open source framework for agile development of Chisel-based systems-on-chip.
It will allow you to leverage the Chisel HDL, Rocket Chip SoC generator, and other [Berkeley][berkeley] projects to produce a [RISC-V][riscv] SoC with everything from MMIO-mapped peripherals to custom accelerators.
Chipyard contains processor cores ([Rocket][rocket-chip], [BOOM][boom], [CVA6 (Ariane)][cva6]), vector units ([Saturn](saturn), [Ara](ara)), accelerators ([Gemmini][gemmini], [NVDLA][nvdla]), memory systems, and additional peripherals and tooling to help create a full featured SoC.
Chipyard supports multiple concurrent flows of agile hardware development, including software RTL simulation, FPGA-accelerated simulation ([FireSim][firesim]), automated VLSI flows ([Hammer][hammer]), and software workload generation for bare-metal and Linux-based systems ([FireMarshal][firemarshal]).
Chipyard is actively developed in the [Berkeley Architecture Research Group][ucb-bar] in the [Electrical Engineering and Computer Sciences Department][eecs] at the [University of California, Berkeley][berkeley].

## Resources

* Chipyard Documentation: https://chipyard.readthedocs.io/
* Chipyard (x FireSim) Tutorial: https://fires.im/tutorial-recent/
* Chipyard Basics slides: https://fires.im/asplos23-slides-pdf/02_chipyard_basics.pdf

## Need help?

* Join the Chipyard Mailing List: https://groups.google.com/forum/#!forum/chipyard
* If you find a bug or would like propose a feature, post an issue on this repo: https://github.com/ucb-bar/chipyard/issues

## Contributing

* See [CONTRIBUTING.md](/CONTRIBUTING.md)

## Attribution and Chipyard-related Publications

If used for research, please cite Chipyard by the following publication:

```
@article{chipyard,
  author={Amid, Alon and Biancolin, David and Gonzalez, Abraham and Grubb, Daniel and Karandikar, Sagar and Liew, Harrison and Magyar,   Albert and Mao, Howard and Ou, Albert and Pemberton, Nathan and Rigge, Paul and Schmidt, Colin and Wright, John and Zhao, Jerry and Shao, Yakun Sophia and Asanovi\'{c}, Krste and Nikoli\'{c}, Borivoje},
  journal={IEEE Micro},
  title={Chipyard: Integrated Design, Simulation, and Implementation Framework for Custom SoCs},
  year={2020},
  volume={40},
  number={4},
  pages={10-21},
  doi={10.1109/MM.2020.2996616},
  ISSN={1937-4143},
}
```

* **Chipyard**
    * A. Amid, et al. *IEEE Micro'20* [PDF](https://ieeexplore.ieee.org/document/9099108).
    * A. Amid, et al. *DAC'20* [PDF](https://ieeexplore.ieee.org/document/9218756).
    * A. Amid, et al. *ISCAS'21* [PDF](https://ieeexplore.ieee.org/abstract/document/9401515).

These additional publications cover many of the internal components used in Chipyard. However, for the most up-to-date details, users should refer to the Chipyard docs.

* **Generators**
    * **Rocket Chip**: K. Asanovic, et al., *UCB EECS TR*. [PDF](http://www2.eecs.berkeley.edu/Pubs/TechRpts/2016/EECS-2016-17.pdf).
    * **BOOM**: C. Celio, et al., *Hot Chips 30*. [PDF](https://old.hotchips.org/hc30/1conf/1.03_Berkeley_BROOM_HC30.Berkeley.Celio.v02.pdf).
      * **SonicBOOM (BOOMv3)**: J. Zhao, et al., *CARRV'20*. [PDF](https://carrv.github.io/2020/papers/CARRV2020_paper_15_Zhao.pdf).
      * **COBRA (BOOM Branch Prediction)**: J. Zhao, et al., *ISPASS'21*. [PDF](https://ieeexplore.ieee.org/document/9408173).
    * **Gemmini**: H. Genc, et al., *DAC'21*. [PDF](https://arxiv.org/pdf/1911.09925).
* **Sims**
    * **FireSim**: S. Karandikar, et al., *ISCA'18*. [PDF](https://sagark.org/assets/pubs/firesim-isca2018.pdf).
        * **FireSim Micro Top Picks**: S. Karandikar, et al., *IEEE Micro, Top Picks 2018*. [PDF](https://sagark.org/assets/pubs/firesim-micro-top-picks2018.pdf).
        * **FASED**: D. Biancolin, et al., *FPGA'19*. [PDF](https://people.eecs.berkeley.edu/~biancolin/papers/fased-fpga19.pdf).
        * **Golden Gate**: A. Magyar, et al., *ICCAD'19*. [PDF](https://davidbiancolin.github.io/papers/goldengate-iccad19.pdf).
        * **FirePerf**: S. Karandikar, et al., *ASPLOS'20*. [PDF](https://sagark.org/assets/pubs/fireperf-asplos2020.pdf).
        * **FireSim ISCA@50 Retrospective**: S. Karandikar, et al., *ISCA@50 Retrospective: 1996-2020*. [PDF](https://sites.coecis.cornell.edu/isca50retrospective/files/2023/06/Karandikar_2018_FireSim.pdf)
* **Tools**
    * **Chisel**: J. Bachrach, et al., *DAC'12*. [PDF](https://people.eecs.berkeley.edu/~krste/papers/chisel-dac2012.pdf).
    * **FIRRTL**: A. Izraelevitz, et al., *ICCAD'17*. [PDF](https://ieeexplore.ieee.org/document/8203780).
    * **Chisel DSP**: A. Wang, et al., *DAC'18*. [PDF](https://ieeexplore.ieee.org/document/8465790).
    * **FireMarshal**: N. Pemberton, et al., *ISPASS'21*. [PDF](https://ieeexplore.ieee.org/document/9408192).
* **VLSI**
    * **Hammer**: E. Wang, et al., *ISQED'20*. [PDF](https://www.isqed.org/English/Archives/2020/Technical_Sessions/113.html).
    * **Hammer**: H. Liew, et al., *DAC'22*. [PDF](https://dl.acm.org/doi/abs/10.1145/3489517.3530672).

## Acknowledgements

This work is supported by the NSF CCRI ENS Chipyard Award #2016662.

[hammer]:https://github.com/ucb-bar/hammer
[firesim]:https://fires.im
[ucb-bar]: http://bar.eecs.berkeley.edu
[eecs]: https://eecs.berkeley.edu
[berkeley]: https://berkeley.edu
[riscv]: https://riscv.org/
[rocket-chip]: https://github.com/freechipsproject/rocket-chip
[boom]: https://github.com/riscv-boom/riscv-boom
[firemarshal]: https://github.com/firesim/FireMarshal/
[cva6]: https://github.com/openhwgroup/cva6/
[gemmini]: https://github.com/ucb-bar/gemmini
[nvdla]: http://nvdla.org/
[saturn]: https://github.com/ucb-bar/saturn-vectors
[ara]: https://github.com/pulp-platform/ara
