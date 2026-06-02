import MetalKit
import SwiftUI

struct VoiceOrbView: UIViewRepresentable {
    let state: VoiceOrbState
    let variant: VoiceOrbVariant
    var volume: Float = 0
    var reduceMotion: Bool = false
    var customColors: VariantColors?

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    func makeUIView(context: Context) -> MTKView {
        let view = MTKView(frame: .zero, device: context.coordinator.device)
        view.delegate = context.coordinator
        view.isOpaque = false
        view.backgroundColor = .clear
        view.clearColor = MTLClearColor(red: 0, green: 0, blue: 0, alpha: 0)
        view.framebufferOnly = false
        view.enableSetNeedsDisplay = false
        view.preferredFramesPerSecond = 0
        view.isPaused = reduceMotion
        context.coordinator.targetParams = OrbParams.stateMap[state]!
        context.coordinator.variantColors = customColors ?? VariantColors.map[variant]!
        return view
    }

    func updateUIView(_ view: MTKView, context: Context) {
        context.coordinator.targetParams = OrbParams.stateMap[state]!
        context.coordinator.variantColors = customColors ?? VariantColors.map[variant]!
        context.coordinator.volume = volume
        view.isPaused = reduceMotion
        if reduceMotion {
            view.draw()
        }
    }

    class Coordinator: NSObject, MTKViewDelegate {
        let device: MTLDevice
        private let commandQueue: MTLCommandQueue
        private let pipelineState: MTLRenderPipelineState

        var targetParams: OrbParams = .stateMap[.idle]!
        var currentParams: OrbParams = .stateMap[.idle]!
        var variantColors: VariantColors = .map[.default]!
        var volume: Float = 0
        private let startTime: CFTimeInterval

        override init() {
            guard let device = MTLCreateSystemDefaultDevice() else {
                fatalError("Metal not available")
            }
            self.device = device
            commandQueue = device.makeCommandQueue()!
            startTime = CACurrentMediaTime()

            let library = try! device.makeLibrary(source: Self.shaderSource, options: nil)
            let vertexFunction = library.makeFunction(name: "vertex_main")!
            let fragmentFunction = library.makeFunction(name: "fragment_main")!

            let descriptor = MTLRenderPipelineDescriptor()
            descriptor.vertexFunction = vertexFunction
            descriptor.fragmentFunction = fragmentFunction
            descriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
            descriptor.colorAttachments[0].isBlendingEnabled = true
            descriptor.colorAttachments[0].sourceRGBBlendFactor = .sourceAlpha
            descriptor.colorAttachments[0].destinationRGBBlendFactor = .oneMinusSourceAlpha
            descriptor.colorAttachments[0].sourceAlphaBlendFactor = .sourceAlpha
            descriptor.colorAttachments[0].destinationAlphaBlendFactor = .oneMinusSourceAlpha

            pipelineState = try! device.makeRenderPipelineState(descriptor: descriptor)
            super.init()
        }

        func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {}

        func draw(in view: MTKView) {
            let lerpFactor: Float = 0.045
            currentParams.speed += (targetParams.speed - currentParams.speed) * lerpFactor
            currentParams.amplitude += (targetParams.amplitude - currentParams.amplitude) * lerpFactor
            currentParams.glow += (targetParams.glow - currentParams.glow) * lerpFactor
            currentParams.brightness += (targetParams.brightness - currentParams.brightness) * lerpFactor
            currentParams.pulse += (targetParams.pulse - currentParams.pulse) * lerpFactor
            currentParams.saturation += (targetParams.saturation - currentParams.saturation) * lerpFactor

            let elapsed = Float(CACurrentMediaTime() - startTime)
            let scale = Float(view.contentScaleFactor)

            var u = OrbUniforms()
            u.u_time = elapsed
            u.u_speed = currentParams.speed + volume * 0.4
            u.u_amplitude = currentParams.amplitude + volume * 0.12
            u.u_glow = currentParams.glow + volume * 0.2
            u.u_brightness = currentParams.brightness
            u.u_pulse = currentParams.pulse
            u.u_saturation = currentParams.saturation
            u.u_dpr = scale
            u.u_color0_r = variantColors.color0.0
            u.u_color0_g = variantColors.color0.1
            u.u_color0_b = variantColors.color0.2
            u.u_color1_r = variantColors.color1.0
            u.u_color1_g = variantColors.color1.1
            u.u_color1_b = variantColors.color1.2
            u.u_color2_r = variantColors.color2.0
            u.u_color2_g = variantColors.color2.1
            u.u_color2_b = variantColors.color2.2

            guard let drawable = view.currentDrawable,
                  let descriptor = view.currentRenderPassDescriptor,
                  let buffer = commandQueue.makeCommandBuffer(),
                  let encoder = buffer.makeRenderCommandEncoder(descriptor: descriptor)
            else { return }

            encoder.setRenderPipelineState(pipelineState)
            encoder.setFragmentBytes(&u, length: MemoryLayout<OrbUniforms>.size, index: 0)
            encoder.drawPrimitives(type: .triangleStrip, vertexStart: 0, vertexCount: 4)
            encoder.endEncoding()

            buffer.present(drawable)
            buffer.commit()
        }

        static let shaderSource = """
        #include <metal_stdlib>
        using namespace metal;

        struct VertexOut {
            float4 position [[position]];
            float2 uv;
        };

        struct OrbUniforms {
            float u_time;
            float u_speed;
            float u_amplitude;
            float u_glow;
            float u_brightness;
            float u_pulse;
            float u_saturation;
            float u_dpr;
            float u_color0_r;
            float u_color0_g;
            float u_color0_b;
            float u_color1_r;
            float u_color1_g;
            float u_color1_b;
            float u_color2_r;
            float u_color2_g;
            float u_color2_b;
        };

        vertex VertexOut vertex_main(uint vertexID [[vertex_id]]) {
            float2 positions[4] = {
                float2(-1.0f, -1.0f),
                float2( 1.0f, -1.0f),
                float2(-1.0f,  1.0f),
                float2( 1.0f,  1.0f)
            };
            VertexOut out;
            out.position = float4(positions[vertexID], 0.0f, 1.0f);
            out.uv = positions[vertexID] * 0.5f + 0.5f;
            return out;
        }

        float3 mod289(float3 x) {
            return x - floor(x / 289.0f) * 289.0f;
        }

        float4 mod289(float4 x) {
            return x - floor(x / 289.0f) * 289.0f;
        }

        float4 permute(float4 x) {
            return mod289((x * 34.0f + 1.0f) * x);
        }

        float4 taylorInvSqrt(float4 r) {
            return 1.79284291400159f - 0.85373472095314f * r;
        }

        float snoise(float3 v) {
            constexpr float2 C = float2(1.0f / 6.0f, 1.0f / 3.0f);

            float3 i  = floor(v + dot(v, float3(C.y)));
            float3 x0 = v - i + dot(i, float3(C.x));

            float3 g = step(x0.yzx, x0.xyz);
            float3 l = 1.0f - g;
            float3 i1 = min(g, l.zxy);
            float3 i2 = max(g, l.zxy);

            float3 x1 = x0 - i1 + C.x;
            float3 x2 = x0 - i2 + C.y;
            float3 x3 = x0 - 0.5f;

            i = mod289(i);
            float4 p = permute(permute(permute(
                i.z + float4(0.0f, i1.z, i2.z, 1.0f))
                + i.y + float4(0.0f, i1.y, i2.y, 1.0f))
                + i.x + float4(0.0f, i1.x, i2.x, 1.0f));

            float4 j = p - 49.0f * floor(p / 49.0f);
            float4 x_ = floor(j / 7.0f);
            float4 y_ = floor(j - 7.0f * x_);

            float4 x = (x_ * 2.0f + 0.5f) / 7.0f - 1.0f;
            float4 y = (y_ * 2.0f + 0.5f) / 7.0f - 1.0f;

            float4 h = 1.0f - abs(x) - abs(y);

            float4 b0 = float4(x.xy, y.xy);
            float4 b1 = float4(x.zw, y.zw);

            float4 s0 = floor(b0) * 2.0f + 1.0f;
            float4 s1 = floor(b1) * 2.0f + 1.0f;
            float4 sh = -step(h, float4(0.0f));

            float4 a0 = b0.xzyw + s0.xzyw * sh.xxyy;
            float4 a1 = b1.xzyw + s1.xzyw * sh.zzww;

            float3 g0 = float3(a0.xy, h.x);
            float3 g1 = float3(a0.zw, h.y);
            float3 g2 = float3(a1.xy, h.z);
            float3 g3 = float3(a1.zw, h.w);

            float4 norm = taylorInvSqrt(float4(dot(g0,g0), dot(g1,g1), dot(g2,g2), dot(g3,g3)));
            g0 *= norm.x;
            g1 *= norm.y;
            g2 *= norm.z;
            g3 *= norm.w;

            float4 m = max(0.6f - float4(dot(x0,x0), dot(x1,x1), dot(x2,x2), dot(x3,x3)), 0.0f);
            m = m * m;
            return 42.0f * dot(m * m, float4(dot(g0,x0), dot(g1,x1), dot(g2,x2), dot(g3,x3)));
        }

        fragment float4 fragment_main(
            VertexOut in [[stage_in]],
            constant OrbUniforms &u [[buffer(0)]]
        ) {
            float2 uv = in.uv * 2.0f - 1.0f;
            float dist = length(uv);
            float t = u.u_time * u.u_speed;

            float3 color0 = float3(u.u_color0_r, u.u_color0_g, u.u_color0_b);
            float3 color1 = float3(u.u_color1_r, u.u_color1_g, u.u_color1_b);
            float3 color2 = float3(u.u_color2_r, u.u_color2_g, u.u_color2_b);

            float radius = 0.44f;
            float circle = 1.0f - smoothstep(radius - 0.008f, radius + 0.008f, dist);

            if (circle < 0.001f) {
                float glowDist = dist - radius;
                float glow = exp(-glowDist * 12.0f) * u.u_glow * 0.4f;
                float3 glowColor = mix(color0, color1, 0.5f);
                return float4(glowColor * glow, glow);
            }

            float n1 = snoise(float3(uv * 2.0f, t * 0.6f)) * 0.5f + 0.5f;
            float n2 = snoise(float3(uv * 3.5f + 7.0f, t * 0.9f)) * 0.5f + 0.5f;
            float n3 = snoise(float3(uv * 1.5f - 3.0f, t * 0.4f + 10.0f)) * 0.5f + 0.5f;

            float2 distort = float2(
                snoise(float3(uv * 2.0f + 5.0f, t * 0.7f)),
                snoise(float3(uv * 2.0f + 15.0f, t * 0.7f))
            ) * u.u_amplitude * 2.0f;

            float n4 = snoise(float3((uv + distort) * 3.0f, t * 0.5f)) * 0.5f + 0.5f;

            float3 col = mix(color0, color1, n1);
            col = mix(col, color2, n2 * 0.5f);
            col = mix(col, color1 * 1.3f, n4 * 0.4f);

            float vein = pow(n3, 3.0f) * u.u_amplitude * 6.0f;
            col += vein * mix(color1, float3(1.0f), 0.3f);

            float centerDist = dist / radius;
            float depthShade = 1.0f - centerDist * centerDist * 0.4f;
            col *= depthShade;

            float rim = pow(centerDist, 4.0f) * 0.6f;
            col += rim * mix(color0, float3(1.0f), 0.5f);

            float2 lightPos = float2(-0.15f, -0.18f);
            float specDist = length(uv - lightPos);
            float spec = exp(-specDist * specDist * 30.0f) * 0.7f;
            col += spec * float3(1.0f);

            float2 lightPos2 = float2(0.2f, 0.25f);
            float spec2 = exp(-length(uv - lightPos2) * 8.0f) * 0.15f;
            col += spec2 * color1;

            float pulseFactor = 1.0f + u.u_pulse * sin(u.u_time * 3.5f) * 0.35f;
            float lum = dot(col, float3(0.299f, 0.587f, 0.114f));
            col = mix(float3(lum), col, u.u_saturation);
            col *= u.u_brightness * pulseFactor;

            return float4(col, circle);
        }
        """
    }
}

private struct OrbUniforms {
    var u_time: Float = 0
    var u_speed: Float = 0
    var u_amplitude: Float = 0
    var u_glow: Float = 0
    var u_brightness: Float = 0
    var u_pulse: Float = 0
    var u_saturation: Float = 0
    var u_dpr: Float = 0
    var u_color0_r: Float = 0
    var u_color0_g: Float = 0
    var u_color0_b: Float = 0
    var u_color1_r: Float = 0
    var u_color1_g: Float = 0
    var u_color1_b: Float = 0
    var u_color2_r: Float = 0
    var u_color2_g: Float = 0
    var u_color2_b: Float = 0
}
