using SimradEK80

filename = "/home/reb/Dropbox/phd/data/simrad/EK80_SimradEcho_WC381_Sequential-D20150513-T090935.raw"
ps = SimradEK80.load(filename)
ps[1]
