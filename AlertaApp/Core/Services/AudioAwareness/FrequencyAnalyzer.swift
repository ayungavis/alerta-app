//
//  FrequencyAnalyzer.swift
//  AlertaApp
//
//  Created by Wahyu Kurniawan on 20/05/26.
//

import Accelerate
import AVFoundation
import Foundation

struct Frequenprimaryalyzer {
    private let fftSize: Int = 2048
    private let fft: FFTAccelerator

    init() {
        fft = FFTAccelerator(fftSize: fftSize)
    }

    func captureBaseline(from buffers: [AVAudioPCMBuffer]) -> FrequencyProfile {
        var accumulatedBands: [Float] = Array(repeating: 0, count: FrequencyBand.defaultBands.count)

        for buffer in buffers {
            let spectrum = analyze(buffer: buffer)
            for (index, band) in spectrum.bands.enumerated() {
                accumulatedBands[index] += band.energy
            }
        }

        let count = Float(max(buffers.count, 1))
        let averagedBands = zip(FrequencyBand.defaultBands, accumulatedBands).map { template, energy in
            FrequencyBand(name: template.name, range: template.range, energy: energy / count)
        }

        let baseline = FrequencySpectrum(
            bands: averagedBands,
            dominantFrequency: dominantFrequency(from: averagedBands),
            spectralCentroid: computeCentroid(bands: averagedBands)
        )

        return FrequencyProfile(baseline: baseline)
    }

    func analyze(buffer: AVAudioPCMBuffer) -> FrequencySpectrum {
        guard let channelData = buffer.floatChannelData,
              let format = buffer.format as? AVAudioFormat
        else {
            return .zero
        }

        let sampleRate = Float(format.sampleRate)
        let frameLength = Int(buffer.frameLength)
        let magnitudes = fft.computeMagnitudes(from: channelData[0], frameLength: frameLength)

        let bands = FrequencyBand.defaultBands.map { template in
            let bandEnergy = computeBandEnergy(
                magnitudes: magnitudes,
                sampleRate: sampleRate,
                range: template.range
            )
            return FrequencyBand(name: template.name, range: template.range, energy: bandEnergy)
        }

        return FrequencySpectrum(
            bands: bands,
            dominantFrequency: dominantFrequency(from: bands),
            spectralCentroid: computeCentroid(bands: bands)
        )
    }

    private func computeBandEnergy(magnitudes: [Float], sampleRate: Float, range: ClosedRange<Float>) -> Float {
        guard !magnitudes.isEmpty else { return 0 }

        var total: Float = 0
        var count = 0

        for index in 0 ..< magnitudes.count {
            let frequency = sampleRate * Float(index) / Float(fftSize)
            if range ~= frequency {
                total += magnitudes[index]
                count += 1
            }
        }

        return count > 0 ? total / Float(count) : 0
    }

    private func dominantFrequency(from bands: [FrequencyBand]) -> Float {
        guard let maxBand = bands.max(by: { $0.energy < $1.energy }), maxBand.energy > 0 else {
            return 0
        }
        return (maxBand.range.lowerBound + maxBand.range.upperBound) / 2
    }

    private func computeCentroid(bands: [FrequencyBand]) -> Float {
        var weightedSum: Float = 0
        var totalEnergy: Float = 0

        for band in bands {
            let centerFreq = (band.range.lowerBound + band.range.upperBound) / 2
            weightedSum += centerFreq * band.energy
            totalEnergy += band.energy
        }

        return totalEnergy > 0 ? weightedSum / totalEnergy : 0
    }
}

// MARK: - FFT Accelerator

private final class FFTAccelerator {
    private let fftSize: Int
    private let log2n: UInt
    private let setup: FFTSetup
    private let halfSize: Int

    init(fftSize: Int) {
        self.fftSize = fftSize
        log2n = UInt(round(log2(Float(fftSize))))
        halfSize = fftSize / 2
        // swiftlint:disable:next force_unwrapping
        setup = vDSP_create_fftsetup(log2n, FFTRadix(FFT_RADIX2))!
    }

    deinit {
        vDSP_destroy_fftsetup(setup)
    }

    func computeMagnitudes(from samples: UnsafePointer<Float>, frameLength: Int) -> [Float] {
        var padded = [Float](repeating: 0, count: fftSize)
        let copyCount = min(frameLength, fftSize)
        for index in 0 ..< copyCount {
            padded[index] = samples[index]
        }

        var realParts = [Float](repeating: 0, count: halfSize)
        var imagParts = [Float](repeating: 0, count: halfSize)

        padded.withUnsafeBufferPointer { paddedPtr in
            guard let baseAddress = paddedPtr.baseAddress else { return }
            let complexPtr = UnsafeRawPointer(baseAddress).assumingMemoryBound(to: DSPComplex.self)

            var splitComplex = DSPSplitComplex(
                realp: &realParts,
                imagp: &imagParts
            )

            vDSP_ctoz(complexPtr, 2, &splitComplex, 1, vDSP_Length(halfSize))

            vDSP_fft_zrip(setup, &splitComplex, 1, log2n, FFTDirection(FFT_FORWARD))

            var magnitudes = [Float](repeating: 0, count: halfSize)
            vDSP_zvmags(&splitComplex, 1, &magnitudes, 1, vDSP_Length(halfSize))

            let scale = Float(fftSize)
            var scaled = [Float](repeating: 0, count: halfSize)
            vDSP_vsdiv(magnitudes, 1, [scale], &scaled, 1, vDSP_Length(halfSize))

            for index in 0 ..< halfSize {
                realParts[index] = sqrt(scaled[index])
            }
        }

        return realParts
    }
}
