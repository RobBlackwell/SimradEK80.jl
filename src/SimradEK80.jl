module SimradEK80

using SimradRaw
using LibExpat

export pings, Sv, at, al

struct EK80Ping
    channelid::String
    q1::Vector{Complex{Float32}}
    q2::Vector{Complex{Float32}}
    q3::Vector{Complex{Float32}}
    q4::Vector{Complex{Float32}}
end


function pings(filename::AbstractString)
    pings([filename])
end

"""
    pings(filenames::Array{String,1})

`pings` returns an iterator over pings in the RAW files designated by
`filenames`.

"""
function pings(filenames::Array{String,1})

    function _it(chn1)

        transeivers = []
        
        for filename in filenames
            open(filename) do f
                while !eof(f)
                    offset = position(f)
                    datagram = readencapsulateddatagram(f)
                    if datagram.dgheader.datagramtype == "RAW3"

                        channelid = datagram.channelid
                        
                        s =  reinterpret(Float32, datagram.samples)
                        q1 = s[1:8:end] .+ s[2:8:end] * im
                        q2 = s[3:8:end] .+ s[4:8:end] * im
                        q3 = s[5:8:end] .+ s[6:8:end] * im
                        q4 = s[7:8:end] .+ s[8:8:end] * im
                        ping = EK80Ping(channelid, q1, q2, q3, q4)
                        put!(chn1, ping)
                    end

                    if datagram.dgheader.datagramtype == "XML0"
                        et = xp_parse(strip(datagram.text,[Char(0)]))

                        s = LibExpat.find(et, "/Configuration/Transceivers/Transceiver")
                        if length(s) > 0
                            transceivers = s
                        end

                    end

                end
            end
        end
    end

    return Channel(_it, ctype=EK80Ping)
end

function at(ping::EK80Ping)
    imag.(ping.q1 .- ping.q3)
end

function al(ping::EK80Ping)
    imag.(ping.q2 .- ping.q4)
end

function Sv(ping::EK80Ping)
    real.(ping.q1 .+ ping.q2.+ ping.q3 .+ ping.q4)
end

function Sv(pings::Array{EK80Ping,1})
    s = [Sv(ping) for ping in pings]
    hcat(s...)
end

function at(pings::Array{EK80Ping,1})
    s = [at(ping) for ping in pings]
    hcat(s...)
end

function al(pings::Array{EK80Ping,1})
    s = [al(ping) for ping in pings]
    hcat(s...)
end

end # module
