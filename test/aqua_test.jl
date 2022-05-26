using Test
using PolyBranch
using Aqua

@testset "Aqua tests" begin
    Aqua.test_all(PolyBranch; project_extras = false)
end