# SimradEK60.jl

[![Build Status](https://travis-ci.org/EchoJulia/SimradEK80.jl.svg?branch=master)](https://travis-ci.org/EchoJulia/SimradEK80.jl)

[![Coverage Status](https://coveralls.io/repos/EchoJulia/SimradEK80.jl/badge.svg?branch=master&service=github)](https://coveralls.io/github/EchoJulia/SimradEK80.jl?branch=master)

[![codecov.io](http://codecov.io/github/EchoJulia/SimradEK80.jl/coverage.svg?branch=master)](http://codecov.io/github/EchoJulia/SimradEK80.jl?branch=master)

## Introduction

Based on SimradRaw.jl, this project reads and intepretes Simrad EK80
RAW files. WARNING it's little more than a prototype at the moment,
and not nearly as mature as the EK60 sister project.


## Example

```
using SimradEK80

filename = "EK80_SimradEcho_WC381_Sequential-D20150513-T090935.raw"
ps = SimradEK80.load(filename)
ps[1]

```
