import Foundation

/// Simple Perlin Noise implementation for 2D noise generation
/// Reference: fast_noise package for Flutter
public class PerlinNoise {
    private let permutation: [Int]
    
    public init() {
        // 使用经典的 Perlin Noise 排列数组
        let p = [
            151, 160, 137, 91, 90, 15, 131, 13, 201, 95, 96, 53, 194, 233, 7, 225,
            140, 36, 103, 30, 69, 142, 8, 99, 37, 240, 21, 10, 23, 190, 6, 148,
            247, 120, 234, 75, 0, 26, 197, 62, 94, 252, 219, 203, 117, 35, 11, 32,
            57, 177, 33, 88, 237, 149, 56, 87, 174, 20, 125, 136, 171, 168, 68, 175,
            74, 165, 71, 134, 139, 48, 27, 166, 77, 146, 158, 231, 83, 111, 229, 122,
            60, 211, 133, 230, 220, 105, 92, 41, 55, 46, 245, 40, 244, 102, 143, 54,
            65, 25, 63, 161, 1, 216, 80, 73, 209, 76, 132, 187, 208, 89, 18, 169,
            200, 196, 135, 130, 116, 188, 159, 86, 164, 100, 109, 198, 173, 186, 3, 64,
            52, 217, 226, 250, 124, 123, 5, 202, 38, 147, 118, 126, 255, 82, 85, 212,
            207, 206, 59, 227, 47, 16, 58, 17, 182, 189, 28, 42, 223, 183, 170, 213,
            119, 248, 152, 2, 44, 154, 163, 70, 221, 153, 101, 155, 167, 43, 172, 9,
            129, 22, 39, 253, 19, 98, 108, 110, 79, 113, 224, 232, 178, 185, 112, 104,
            218, 246, 97, 228, 251, 34, 242, 193, 238, 210, 144, 12, 191, 179, 162, 241,
            81, 51, 145, 235, 249, 14, 239, 107, 49, 192, 214, 31, 181, 199, 106, 157,
            184, 84, 204, 176, 115, 121, 50, 45, 127, 4, 150, 254, 138, 236, 205, 93,
            222, 114, 67, 29, 24, 72, 243, 141, 128, 195, 78, 66, 215, 61, 156, 180
        ]
        // 创建 512 元素的排列数组（原数组重复两次）
        permutation = p + p
    }
    
    /// Get 2D noise value at position (x, y)
    /// Returns a value between -1.0 and 1.0 (similar to fast_noise)
    public func getNoise2(_ x: Double, _ y: Double) -> Double {
        // 使用简化但有效的 Perlin Noise 算法
        return simplifiedPerlin2D(x, y)
    }
    
    /// Simplified 2D Perlin Noise implementation
    private func simplifiedPerlin2D(_ x: Double, _ y: Double) -> Double {
        // 使用多层 octave 的简化实现（类似 fast_noise）
        var value: Double = 0.0
        var amplitude: Double = 1.0
        var frequency: Double = 0.01
        var maxValue: Double = 0.0
        
        let octaves = 4
        
        for _ in 0..<octaves {
            value += amplitude * interpolatedNoise(x * frequency, y * frequency)
            maxValue += amplitude
            amplitude *= 0.5
            frequency *= 2.0
        }
        
        return value / maxValue
    }
    
    /// Interpolated noise function (core Perlin Noise algorithm)
    private func interpolatedNoise(_ x: Double, _ y: Double) -> Double {
        let xi = Int(floor(x)) & 255
        let yi = Int(floor(y)) & 255
        
        let xf = x - floor(x)
        let yf = y - floor(y)
        
        let u = fade(xf)
        let v = fade(yf)
        
        let a = permutation[permutation[xi] + yi]
        let b = permutation[permutation[xi + 1] + yi]
        let c = permutation[permutation[xi] + yi + 1]
        let d = permutation[permutation[xi + 1] + yi + 1]
        
        let gradA = grad(a, xf, yf)
        let gradB = grad(b, xf - 1, yf)
        let gradC = grad(c, xf, yf - 1)
        let gradD = grad(d, xf - 1, yf - 1)
        
        let x1 = lerp(u, gradA, gradB)
        let x2 = lerp(u, gradC, gradD)
        
        return lerp(v, x1, x2)
    }
    
    /// Fade function for smooth interpolation (6t^5 - 15t^4 + 10t^3)
    private func fade(_ t: Double) -> Double {
        return t * t * t * (t * (t * 6 - 15) + 10)
    }
    
    /// Linear interpolation
    private func lerp(_ t: Double, _ a: Double, _ b: Double) -> Double {
        return a + t * (b - a)
    }
    
    /// Gradient function for Perlin Noise
    private func grad(_ hash: Int, _ x: Double, _ y: Double) -> Double {
        let h = hash & 3
        let u = h < 2 ? x : y
        let v = h < 2 ? y : x
        return ((h & 1) == 0 ? u : -u) + ((h & 2) == 0 ? v : -v)
    }
}

