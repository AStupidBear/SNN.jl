@snn_kw struct NoisyIFParameter <: AbstractIFParameter
    σ::Float32 = 0
end

@snn_kw mutable struct NoisyIF <: AbstractIF
    param::NoisyIFParameter = NoisyIFParameter()
    randncache::Vector{Float32} = randn(N)
end

function integrate!(p::NoisyIF, param::NoisyIFParameter, dt::Float32)
    randn!(randncache)
    @inbounds for i = 1:N
        v[i] += dt * (ge[i] + gi[i] - (v[i] - El) + I[i] + σ / √dt * randncache[i]) / τm
        ge[i] += dt * -ge[i] / τe
        gi[i] += dt * -gi[i] / τi
    end
    @inbounds for i = 1:N
        fire[i] = v[i] > Vt
        v[i] = ifelse(fire[i], Vr, v[i])
    end
end
