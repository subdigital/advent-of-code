//
//  Shaders.metal
//  AdventOfCode2024
//
//  Created by Ben Scheirman on 12/16/24.
//

#include <metal_stdlib>
using namespace metal;

struct Vertex {
    float4 position [[position]];
    float2 texCoord;
};

vertex Vertex vertexShader(uint vertexID [[vertex_id]]) {
    float2 positions[4] = { {-0.9, -0.9}, {0.9, -0.9}, {-0.9, 0.9}, {0.9, 0.9} };
    float2 texCoords[4] = { {0.0, 0.0}, {1.0, 0.0}, {0.0, 1.0}, {1.0, 1.0} };

    Vertex out;
    out.position = float4(positions[vertexID], 0.0, 1.0);
    out.texCoord = texCoords[vertexID];
    return out;
}

fragment float4 fragmentShader(Vertex in [[stage_in]],
                               texture2d<float> texture [[texture(0)]]) {
    return texture.sample(sampler(coord::normalized), in.texCoord);
}
