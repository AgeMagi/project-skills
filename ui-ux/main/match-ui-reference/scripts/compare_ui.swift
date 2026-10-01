#!/usr/bin/env swift
import AppKit
import Darwin
import Foundation
import ImageIO
import UniformTypeIdentifiers

struct ComparisonFailure: Error, CustomStringConvertible {
  let description: String
}

struct PixelRect: Codable {
  let x: Int
  let y: Int
  let width: Int
  let height: Int

  func contains(x candidateX: Int, y candidateY: Int) -> Bool {
    candidateX >= x && candidateX < x + width && candidateY >= y && candidateY < y + height
  }
}

struct RGBColor {
  let red: Int
  let green: Int
  let blue: Int

  var channels: [Int] { [red, green, blue] }
}

enum AcceptanceMode: String {
  case rgb
  case featureGeometry = "feature-geometry"
}

struct FeatureMeasurement {
  let bounds: PixelRect
  let rawMatchedPixels: Int
  let retainedPixels: Int
  let retainedComponents: Int
  let largestComponentPixels: Int
  let mask: PixelImage
}

struct PixelImage {
  let width: Int
  let height: Int
  var pixels: [UInt8]

  func cropped(to rect: PixelRect) throws -> PixelImage {
    guard rect.x >= 0, rect.y >= 0, rect.width > 0, rect.height > 0,
      rect.x + rect.width <= width, rect.y + rect.height <= height
    else {
      throw ComparisonFailure(
        description:
          "Crop \(rect.x),\(rect.y),\(rect.width),\(rect.height) is outside \(width)x\(height)"
      )
    }

    var result = [UInt8](repeating: 0, count: rect.width * rect.height * 4)
    for targetY in 0..<rect.height {
      let sourceStart = ((rect.y + targetY) * width + rect.x) * 4
      let targetStart = targetY * rect.width * 4
      result.replaceSubrange(
        targetStart..<(targetStart + rect.width * 4),
        with: pixels[sourceStart..<(sourceStart + rect.width * 4)]
      )
    }
    return PixelImage(width: rect.width, height: rect.height, pixels: result)
  }

  func resized(to targetWidth: Int, _ targetHeight: Int) -> PixelImage {
    guard targetWidth != width || targetHeight != height else { return self }
    var result = [UInt8](repeating: 0, count: targetWidth * targetHeight * 4)

    for targetY in 0..<targetHeight {
      let sourceY = (Double(targetY) + 0.5) * Double(height) / Double(targetHeight) - 0.5
      let y0 = max(0, min(height - 1, Int(floor(sourceY))))
      let y1 = max(0, min(height - 1, y0 + 1))
      let yWeight = max(0, min(1, sourceY - Double(y0)))

      for targetX in 0..<targetWidth {
        let sourceX = (Double(targetX) + 0.5) * Double(width) / Double(targetWidth) - 0.5
        let x0 = max(0, min(width - 1, Int(floor(sourceX))))
        let x1 = max(0, min(width - 1, x0 + 1))
        let xWeight = max(0, min(1, sourceX - Double(x0)))

        for channel in 0..<4 {
          let topLeft = Double(pixels[(y0 * width + x0) * 4 + channel])
          let topRight = Double(pixels[(y0 * width + x1) * 4 + channel])
          let bottomLeft = Double(pixels[(y1 * width + x0) * 4 + channel])
          let bottomRight = Double(pixels[(y1 * width + x1) * 4 + channel])
          let top = topLeft + (topRight - topLeft) * xWeight
          let bottom = bottomLeft + (bottomRight - bottomLeft) * xWeight
          result[(targetY * targetWidth + targetX) * 4 + channel] = UInt8(
            max(0, min(255, Int((top + (bottom - top) * yWeight).rounded())))
          )
        }
      }
    }

    return PixelImage(width: targetWidth, height: targetHeight, pixels: result)
  }
}

struct Options {
  var referencePath: String?
  var actualPath: String?
  var outputDirectory: String?
  var referenceCrop: PixelRect?
  var actualCrop: PixelRect?
  var ignoreRects: [PixelRect] = []
  var maskPath: String?
  var acceptance = AcceptanceMode.rgb
  var referenceFeatureColor: RGBColor?
  var actualFeatureColor: RGBColor?
  var featureColorTolerance = 24
  var minimumFeaturePixels = 4
  var geometryTolerance = 1
  var minimumFeatureIoU = 0.8
  var exactFeatureMatch = false
  var channelTolerance = 8
  var minimumPassRate = 0.99
  var resizeActual = false
}

func usage() {
  print(
    """
    Usage: compare_ui.swift --reference PATH --actual PATH --output-dir DIR [options]

      --reference-crop X,Y,W,H
      --actual-crop X,Y,W,H
      --ignore X,Y,W,H          May be repeated; coordinates use comparison canvas
      --mask PATH               Light/opaque pixels compare; black/transparent ignore
      --acceptance MODE         rgb (default) or feature-geometry
      --reference-feature-color R,G,B
      --actual-feature-color R,G,B
      --feature-color-tolerance N
                                Maximum per-channel feature-color delta, default 24
      --minimum-feature-pixels N
                                Drop connected components smaller than N, default 4
      --geometry-tolerance N    Maximum x/y/width/height bound delta, default 1
      --minimum-feature-iou RATE
                                Required binary silhouette overlap, default 0.8
      --exact-feature-match     Select feature-geometry, require zero bound delta,
                                and require silhouette IoU strictly greater than 0.95
      --channel-tolerance N     0...255, default 8
      --minimum-pass-rate RATE  0...1, default 0.99
      --resize-actual           Bilinear resize after cropping; explicit normalization only

    Exit 0 means the selected pass-rate threshold was met, 1 means it was not,
    and 2 means the input or comparison setup was invalid.
    """)
}

func parseRect(_ value: String, option: String) throws -> PixelRect {
  let parts = value.split(separator: ",", omittingEmptySubsequences: false)
  guard parts.count == 4, let x = Int(parts[0]), let y = Int(parts[1]),
    let width = Int(parts[2]), let height = Int(parts[3]),
    x >= 0, y >= 0, width > 0, height > 0
  else {
    throw ComparisonFailure(
      description: "\(option) must be X,Y,W,H with non-negative origin and positive size")
  }
  return PixelRect(x: x, y: y, width: width, height: height)
}

func parseColor(_ value: String, option: String) throws -> RGBColor {
  let parts = value.split(separator: ",", omittingEmptySubsequences: false)
  guard parts.count == 3, let red = Int(parts[0]), let green = Int(parts[1]),
    let blue = Int(parts[2]), (0...255).contains(red), (0...255).contains(green),
    (0...255).contains(blue)
  else {
    throw ComparisonFailure(description: "\(option) must be R,G,B with values from 0 through 255")
  }
  return RGBColor(red: red, green: green, blue: blue)
}

func requireValue(_ arguments: [String], _ index: inout Int, option: String) throws -> String {
  index += 1
  guard index < arguments.count else {
    throw ComparisonFailure(description: "\(option) requires a value")
  }
  return arguments[index]
}

func parseOptions() throws -> Options {
  let arguments = Array(CommandLine.arguments.dropFirst())
  var options = Options()
  var index = 0

  while index < arguments.count {
    let argument = arguments[index]
    switch argument {
    case "-h", "--help":
      usage()
      Darwin.exit(0)
    case "--reference":
      options.referencePath = try requireValue(arguments, &index, option: argument)
    case "--actual":
      options.actualPath = try requireValue(arguments, &index, option: argument)
    case "--output-dir":
      options.outputDirectory = try requireValue(arguments, &index, option: argument)
    case "--reference-crop":
      options.referenceCrop = try parseRect(
        try requireValue(arguments, &index, option: argument),
        option: argument
      )
    case "--actual-crop":
      options.actualCrop = try parseRect(
        try requireValue(arguments, &index, option: argument),
        option: argument
      )
    case "--ignore":
      options.ignoreRects.append(
        try parseRect(try requireValue(arguments, &index, option: argument), option: argument)
      )
    case "--mask":
      options.maskPath = try requireValue(arguments, &index, option: argument)
    case "--acceptance":
      let value = try requireValue(arguments, &index, option: argument)
      guard let acceptance = AcceptanceMode(rawValue: value) else {
        throw ComparisonFailure(description: "--acceptance must be rgb or feature-geometry")
      }
      options.acceptance = acceptance
    case "--reference-feature-color":
      options.referenceFeatureColor = try parseColor(
        try requireValue(arguments, &index, option: argument), option: argument)
    case "--actual-feature-color":
      options.actualFeatureColor = try parseColor(
        try requireValue(arguments, &index, option: argument), option: argument)
    case "--feature-color-tolerance":
      let value = try requireValue(arguments, &index, option: argument)
      guard let tolerance = Int(value), (0...255).contains(tolerance) else {
        throw ComparisonFailure(
          description: "--feature-color-tolerance must be an integer from 0 through 255")
      }
      options.featureColorTolerance = tolerance
    case "--minimum-feature-pixels":
      let value = try requireValue(arguments, &index, option: argument)
      guard let count = Int(value), count > 0 else {
        throw ComparisonFailure(description: "--minimum-feature-pixels must be a positive integer")
      }
      options.minimumFeaturePixels = count
    case "--geometry-tolerance":
      let value = try requireValue(arguments, &index, option: argument)
      guard let tolerance = Int(value), tolerance >= 0 else {
        throw ComparisonFailure(description: "--geometry-tolerance must be a non-negative integer")
      }
      options.geometryTolerance = tolerance
    case "--minimum-feature-iou":
      let value = try requireValue(arguments, &index, option: argument)
      guard let rate = Double(value), rate >= 0, rate <= 1 else {
        throw ComparisonFailure(description: "--minimum-feature-iou must be from 0 through 1")
      }
      options.minimumFeatureIoU = rate
    case "--exact-feature-match":
      options.exactFeatureMatch = true
    case "--channel-tolerance":
      let value = try requireValue(arguments, &index, option: argument)
      guard let tolerance = Int(value), (0...255).contains(tolerance) else {
        throw ComparisonFailure(
          description: "--channel-tolerance must be an integer from 0 through 255")
      }
      options.channelTolerance = tolerance
    case "--minimum-pass-rate":
      let value = try requireValue(arguments, &index, option: argument)
      guard let rate = Double(value), rate >= 0, rate <= 1 else {
        throw ComparisonFailure(description: "--minimum-pass-rate must be from 0 through 1")
      }
      options.minimumPassRate = rate
    case "--resize-actual":
      options.resizeActual = true
    default:
      throw ComparisonFailure(description: "Unknown option: \(argument)")
    }
    index += 1
  }

  guard options.referencePath != nil else {
    throw ComparisonFailure(description: "--reference is required")
  }
  guard options.actualPath != nil else {
    throw ComparisonFailure(description: "--actual is required")
  }
  guard options.outputDirectory != nil else {
    throw ComparisonFailure(description: "--output-dir is required")
  }
  if options.exactFeatureMatch {
    options.acceptance = .featureGeometry
    options.geometryTolerance = 0
    options.minimumFeatureIoU = 0.95
  }
  if options.acceptance == .featureGeometry
    && (options.referenceFeatureColor == nil || options.actualFeatureColor == nil)
  {
    throw ComparisonFailure(
      description:
        "feature-geometry acceptance requires --reference-feature-color and --actual-feature-color"
    )
  }
  if (options.referenceFeatureColor == nil) != (options.actualFeatureColor == nil) {
    throw ComparisonFailure(
      description:
        "pass both --reference-feature-color and --actual-feature-color, or pass neither"
    )
  }
  return options
}

func loadImage(path: String) throws -> PixelImage {
  guard let image = NSImage(contentsOfFile: path) else {
    throw ComparisonFailure(description: "Cannot decode image: \(path)")
  }
  var proposedRect = NSRect(origin: .zero, size: image.size)
  guard let cgImage = image.cgImage(forProposedRect: &proposedRect, context: nil, hints: nil) else {
    throw ComparisonFailure(description: "Cannot create pixel image: \(path)")
  }

  let width = cgImage.width
  let height = cgImage.height
  var pixels = [UInt8](repeating: 0, count: width * height * 4)
  let colorSpace = CGColorSpaceCreateDeviceRGB()
  let bitmapInfo =
    CGBitmapInfo.byteOrder32Big.rawValue
    | CGImageAlphaInfo.premultipliedLast.rawValue

  guard
    let context = CGContext(
      data: &pixels,
      width: width,
      height: height,
      bitsPerComponent: 8,
      bytesPerRow: width * 4,
      space: colorSpace,
      bitmapInfo: bitmapInfo
    )
  else {
    throw ComparisonFailure(description: "Cannot allocate image buffer for: \(path)")
  }

  context.setBlendMode(.copy)
  context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
  return PixelImage(width: width, height: height, pixels: pixels)
}

func savePNG(_ image: PixelImage, path: String) throws {
  let data = Data(image.pixels) as CFData
  guard let provider = CGDataProvider(data: data) else {
    throw ComparisonFailure(description: "Cannot create PNG provider: \(path)")
  }
  let colorSpace = CGColorSpaceCreateDeviceRGB()
  let bitmapInfo = CGBitmapInfo.byteOrder32Big.union(
    CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
  )
  guard
    let cgImage = CGImage(
      width: image.width,
      height: image.height,
      bitsPerComponent: 8,
      bitsPerPixel: 32,
      bytesPerRow: image.width * 4,
      space: colorSpace,
      bitmapInfo: bitmapInfo,
      provider: provider,
      decode: nil,
      shouldInterpolate: false,
      intent: .defaultIntent
    )
  else {
    throw ComparisonFailure(description: "Cannot create PNG image: \(path)")
  }

  let url = URL(fileURLWithPath: path) as CFURL
  guard
    let destination = CGImageDestinationCreateWithURL(
      url,
      UTType.png.identifier as CFString,
      1,
      nil
    )
  else {
    throw ComparisonFailure(description: "Cannot open PNG destination: \(path)")
  }
  CGImageDestinationAddImage(destination, cgImage, nil)
  guard CGImageDestinationFinalize(destination) else {
    throw ComparisonFailure(description: "Cannot write PNG: \(path)")
  }
}

func dictionary(for rect: PixelRect?) -> Any {
  guard let rect else { return NSNull() }
  return ["x": rect.x, "y": rect.y, "width": rect.width, "height": rect.height]
}

func standardizedPath(_ path: String) -> String {
  URL(fileURLWithPath: path).standardizedFileURL.path
}

func colorDictionary(_ color: RGBColor) -> [String: Int] {
  ["red": color.red, "green": color.green, "blue": color.blue]
}

func featureDictionary(_ measurement: FeatureMeasurement) -> [String: Any] {
  [
    "bounds": dictionary(for: measurement.bounds),
    "raw_matched_pixels": measurement.rawMatchedPixels,
    "retained_pixels": measurement.retainedPixels,
    "retained_components": measurement.retainedComponents,
    "largest_component_pixels": measurement.largestComponentPixels,
  ]
}

func measureFeature(
  image: PixelImage,
  color: RGBColor,
  tolerance: Int,
  minimumComponentPixels: Int,
  isExcluded: (Int, Int) -> Bool
) throws -> FeatureMeasurement {
  let pixelCount = image.width * image.height
  var candidates = [Bool](repeating: false, count: pixelCount)
  var rawMatchedPixels = 0
  let targetChannels = color.channels

  for y in 0..<image.height {
    for x in 0..<image.width where !isExcluded(x, y) {
      let pixelIndex = y * image.width + x
      let offset = pixelIndex * 4
      var maximumDelta = 0
      for channel in 0..<3 {
        maximumDelta = max(
          maximumDelta,
          abs(Int(image.pixels[offset + channel]) - targetChannels[channel])
        )
      }
      if maximumDelta <= tolerance {
        candidates[pixelIndex] = true
        rawMatchedPixels += 1
      }
    }
  }

  var visited = [Bool](repeating: false, count: pixelCount)
  var retained = [Bool](repeating: false, count: pixelCount)
  var retainedComponents = 0
  var retainedPixels = 0
  var largestComponentPixels = 0
  let neighbors = [
    (-1, -1), (0, -1), (1, -1),
    (-1, 0), (1, 0),
    (-1, 1), (0, 1), (1, 1),
  ]

  for start in 0..<pixelCount where candidates[start] && !visited[start] {
    var queue = [start]
    var component = [Int]()
    visited[start] = true
    var cursor = 0
    while cursor < queue.count {
      let current = queue[cursor]
      cursor += 1
      component.append(current)
      let x = current % image.width
      let y = current / image.width
      for (deltaX, deltaY) in neighbors {
        let candidateX = x + deltaX
        let candidateY = y + deltaY
        guard candidateX >= 0, candidateY >= 0, candidateX < image.width,
          candidateY < image.height
        else { continue }
        let candidate = candidateY * image.width + candidateX
        if candidates[candidate] && !visited[candidate] {
          visited[candidate] = true
          queue.append(candidate)
        }
      }
    }

    guard component.count >= minimumComponentPixels else { continue }
    retainedComponents += 1
    retainedPixels += component.count
    largestComponentPixels = max(largestComponentPixels, component.count)
    for pixel in component { retained[pixel] = true }
  }

  guard retainedPixels > 0 else {
    throw ComparisonFailure(
      description:
        "No feature component contains at least \(minimumComponentPixels) pixels within color tolerance \(tolerance)"
    )
  }

  var minimumX = image.width
  var minimumY = image.height
  var maximumX = -1
  var maximumY = -1
  var maskPixels = [UInt8](repeating: 0, count: image.pixels.count)
  for pixel in 0..<pixelCount where retained[pixel] {
    let x = pixel % image.width
    let y = pixel / image.width
    minimumX = min(minimumX, x)
    minimumY = min(minimumY, y)
    maximumX = max(maximumX, x)
    maximumY = max(maximumY, y)
    let offset = pixel * 4
    maskPixels[offset] = 255
    maskPixels[offset + 1] = 255
    maskPixels[offset + 2] = 255
    maskPixels[offset + 3] = 255
  }

  return FeatureMeasurement(
    bounds: PixelRect(
      x: minimumX,
      y: minimumY,
      width: maximumX - minimumX + 1,
      height: maximumY - minimumY + 1
    ),
    rawMatchedPixels: rawMatchedPixels,
    retainedPixels: retainedPixels,
    retainedComponents: retainedComponents,
    largestComponentPixels: largestComponentPixels,
    mask: PixelImage(width: image.width, height: image.height, pixels: maskPixels)
  )
}

func featureIntersectionOverUnion(
  reference: FeatureMeasurement,
  actual: FeatureMeasurement
) -> Double {
  var intersection = 0
  var union = 0
  for offset in stride(from: 3, to: reference.mask.pixels.count, by: 4) {
    let referenceSet = reference.mask.pixels[offset] > 0
    let actualSet = actual.mask.pixels[offset] > 0
    if referenceSet && actualSet { intersection += 1 }
    if referenceSet || actualSet { union += 1 }
  }
  return union == 0 ? 1 : Double(intersection) / Double(union)
}

func compare(options: Options) throws -> Bool {
  let referencePath = options.referencePath!
  let actualPath = options.actualPath!
  let outputDirectory = URL(fileURLWithPath: options.outputDirectory!).standardizedFileURL.path
  try FileManager.default.createDirectory(
    atPath: outputDirectory,
    withIntermediateDirectories: true
  )

  let sourceReference = try loadImage(path: referencePath)
  let sourceActual = try loadImage(path: actualPath)
  let referenceCrop =
    options.referenceCrop
    ?? PixelRect(x: 0, y: 0, width: sourceReference.width, height: sourceReference.height)
  let actualCrop =
    options.actualCrop
    ?? PixelRect(x: 0, y: 0, width: sourceActual.width, height: sourceActual.height)
  let reference = try sourceReference.cropped(to: referenceCrop)
  var actual = try sourceActual.cropped(to: actualCrop)
  var didResizeActual = false

  if reference.width != actual.width || reference.height != actual.height {
    guard options.resizeActual else {
      throw ComparisonFailure(
        description: "Scoped dimensions differ: reference \(reference.width)x\(reference.height), "
          + "actual \(actual.width)x\(actual.height). Use explicit crops or --resize-actual."
      )
    }
    actual = actual.resized(to: reference.width, reference.height)
    didResizeActual = true
  }

  for rect in options.ignoreRects {
    guard rect.x + rect.width <= reference.width, rect.y + rect.height <= reference.height else {
      throw ComparisonFailure(
        description: "Ignore rectangle \(rect.x),\(rect.y),\(rect.width),\(rect.height) "
          + "is outside \(reference.width)x\(reference.height)"
      )
    }
  }

  let mask: PixelImage?
  if let maskPath = options.maskPath {
    let loadedMask = try loadImage(path: maskPath)
    guard loadedMask.width == reference.width, loadedMask.height == reference.height else {
      throw ComparisonFailure(
        description: "Mask is \(loadedMask.width)x\(loadedMask.height); expected "
          + "\(reference.width)x\(reference.height)"
      )
    }
    mask = loadedMask
  } else {
    mask = nil
  }

  func isExcluded(_ x: Int, _ y: Int) -> Bool {
    if options.ignoreRects.contains(where: { $0.contains(x: x, y: y) }) { return true }
    guard let mask else { return false }
    let offset = (y * reference.width + x) * 4
    let alpha = Int(mask.pixels[offset + 3])
    let luminance =
      (Int(mask.pixels[offset]) + Int(mask.pixels[offset + 1]) + Int(mask.pixels[offset + 2]))
      / 3
    return alpha < 128 || luminance < 128
  }

  let thresholds = Set([0, 4, 8, 16, options.channelTolerance]).sorted()
  var thresholdCounts = Dictionary(uniqueKeysWithValues: thresholds.map { ($0, 0) })
  var comparedPixels = 0
  var ignoredPixels = 0
  var sumAbsoluteDifference = 0.0
  var sumSquaredDifference = 0.0
  var maximumChannelDelta = 0
  var differencePixels = [UInt8](repeating: 0, count: reference.pixels.count)
  var overlayPixels = [UInt8](repeating: 0, count: reference.pixels.count)

  for y in 0..<reference.height {
    for x in 0..<reference.width {
      let offset = (y * reference.width + x) * 4
      if isExcluded(x, y) {
        ignoredPixels += 1
        differencePixels[offset] = 0
        differencePixels[offset + 1] = 0
        differencePixels[offset + 2] = 0
        differencePixels[offset + 3] = 0
        for channel in 0..<3 {
          overlayPixels[offset + channel] = UInt8(Double(actual.pixels[offset + channel]) * 0.32)
        }
        overlayPixels[offset + 3] = 255
        continue
      }

      comparedPixels += 1
      var maxDelta = 0
      for channel in 0..<3 {
        let delta = abs(
          Int(reference.pixels[offset + channel]) - Int(actual.pixels[offset + channel]))
        maxDelta = max(maxDelta, delta)
        maximumChannelDelta = max(maximumChannelDelta, delta)
        sumAbsoluteDifference += Double(delta)
        sumSquaredDifference += Double(delta * delta)
        differencePixels[offset + channel] = UInt8(min(255, delta * 4))
      }
      differencePixels[offset + 3] = 255

      for threshold in thresholds where maxDelta <= threshold {
        thresholdCounts[threshold, default: 0] += 1
      }

      if maxDelta > options.channelTolerance {
        overlayPixels[offset] = UInt8(
          min(255, Int(Double(actual.pixels[offset]) * 0.45 + 140))
        )
        overlayPixels[offset + 1] = UInt8(Double(actual.pixels[offset + 1]) * 0.35)
        overlayPixels[offset + 2] = UInt8(Double(actual.pixels[offset + 2]) * 0.35)
      } else {
        for channel in 0..<3 {
          overlayPixels[offset + channel] = UInt8(
            (Int(reference.pixels[offset + channel]) + Int(actual.pixels[offset + channel])) / 2
          )
        }
      }
      overlayPixels[offset + 3] = 255
    }
  }

  guard comparedPixels > 0 else {
    throw ComparisonFailure(
      description: "The crop, mask, and ignore rectangles exclude every pixel")
  }

  let comparedChannels = Double(comparedPixels * 3)
  let meanAbsoluteError = sumAbsoluteDifference / comparedChannels
  let rootMeanSquareError = sqrt(sumSquaredDifference / comparedChannels)
  let selectedPassRate =
    Double(thresholdCounts[options.channelTolerance, default: 0]) / Double(comparedPixels)
  let exactPixelRate = Double(thresholdCounts[0, default: 0]) / Double(comparedPixels)
  let rgbPassed = selectedPassRate >= options.minimumPassRate

  var referenceFeature: FeatureMeasurement?
  var actualFeature: FeatureMeasurement?
  var featureGeometryPassed: Bool?
  var geometryDeltas: [String: Int]?
  var featureIoU: Double?
  if let referenceColor = options.referenceFeatureColor,
    let actualColor = options.actualFeatureColor
  {
    referenceFeature = try measureFeature(
      image: reference,
      color: referenceColor,
      tolerance: options.featureColorTolerance,
      minimumComponentPixels: options.minimumFeaturePixels,
      isExcluded: isExcluded
    )
    actualFeature = try measureFeature(
      image: actual,
      color: actualColor,
      tolerance: options.featureColorTolerance,
      minimumComponentPixels: options.minimumFeaturePixels,
      isExcluded: isExcluded
    )
    let referenceBounds = referenceFeature!.bounds
    let actualBounds = actualFeature!.bounds
    let deltas = [
      "x": abs(referenceBounds.x - actualBounds.x),
      "y": abs(referenceBounds.y - actualBounds.y),
      "width": abs(referenceBounds.width - actualBounds.width),
      "height": abs(referenceBounds.height - actualBounds.height),
    ]
    geometryDeltas = deltas
    let intersectionOverUnion = featureIntersectionOverUnion(
      reference: referenceFeature!, actual: actualFeature!)
    featureIoU = intersectionOverUnion
    let intersectionOverUnionPassed =
      options.exactFeatureMatch
      ? intersectionOverUnion > options.minimumFeatureIoU
      : intersectionOverUnion >= options.minimumFeatureIoU
    featureGeometryPassed =
      deltas.values.allSatisfy { $0 <= options.geometryTolerance }
      && intersectionOverUnionPassed
  }

  let passed =
    switch options.acceptance {
    case .rgb: rgbPassed
    case .featureGeometry: featureGeometryPassed!
    }

  let referenceScopedPath = outputDirectory + "/reference-scoped.png"
  let actualScopedPath = outputDirectory + "/actual-scoped.png"
  let differencePath = outputDirectory + "/difference.png"
  let overlayPath = outputDirectory + "/threshold-overlay.png"
  let referenceFeatureMaskPath = outputDirectory + "/reference-feature-mask.png"
  let actualFeatureMaskPath = outputDirectory + "/actual-feature-mask.png"
  let reportPath = outputDirectory + "/comparison-report.json"
  try savePNG(reference, path: referenceScopedPath)
  try savePNG(actual, path: actualScopedPath)
  try savePNG(
    PixelImage(width: reference.width, height: reference.height, pixels: differencePixels),
    path: differencePath
  )
  try savePNG(
    PixelImage(width: reference.width, height: reference.height, pixels: overlayPixels),
    path: overlayPath
  )
  if let referenceFeature, let actualFeature {
    try savePNG(referenceFeature.mask, path: referenceFeatureMaskPath)
    try savePNG(actualFeature.mask, path: actualFeatureMaskPath)
  }

  let ratesByThreshold = Dictionary(
    uniqueKeysWithValues: thresholds.map {
      (String($0), Double(thresholdCounts[$0, default: 0]) / Double(comparedPixels))
    }
  )
  var artifacts = [
    "reference_scoped": referenceScopedPath,
    "actual_scoped": actualScopedPath,
    "difference": differencePath,
    "threshold_overlay": overlayPath,
  ]
  if referenceFeature != nil {
    artifacts["reference_feature_mask"] = referenceFeatureMaskPath
    artifacts["actual_feature_mask"] = actualFeatureMaskPath
  }
  var report: [String: Any] = [
    "passed": passed,
    "acceptance": options.acceptance.rawValue,
    "exact_feature_match": options.exactFeatureMatch,
    "rgb_passed": rgbPassed,
    "reference_path": standardizedPath(referencePath),
    "actual_path": standardizedPath(actualPath),
    "mask_path": options.maskPath.map(standardizedPath) ?? NSNull(),
    "source_reference_dimensions": [
      "width": sourceReference.width, "height": sourceReference.height,
    ],
    "source_actual_dimensions": ["width": sourceActual.width, "height": sourceActual.height],
    "reference_crop": dictionary(for: referenceCrop),
    "actual_crop": dictionary(for: actualCrop),
    "comparison_dimensions": ["width": reference.width, "height": reference.height],
    "actual_resized": didResizeActual,
    "ignore_rectangles": options.ignoreRects.map {
      ["x": $0.x, "y": $0.y, "width": $0.width, "height": $0.height]
    },
    "channels": "RGB; alpha ignored",
    "compared_pixels": comparedPixels,
    "ignored_pixels": ignoredPixels,
    "exact_pixel_rate": exactPixelRate,
    "channel_tolerance": options.channelTolerance,
    "within_tolerance_rate": selectedPassRate,
    "minimum_pass_rate": options.minimumPassRate,
    "rates_by_max_channel_threshold": ratesByThreshold,
    "mean_absolute_error": meanAbsoluteError,
    "normalized_mean_absolute_error": meanAbsoluteError / 255.0,
    "root_mean_square_error": rootMeanSquareError,
    "maximum_channel_delta": maximumChannelDelta,
    "artifacts": artifacts,
  ]
  if let referenceFeature, let actualFeature, let featureGeometryPassed, let geometryDeltas,
    let featureIoU,
    let referenceColor = options.referenceFeatureColor,
    let actualColor = options.actualFeatureColor
  {
    report["feature_geometry"] = [
      "passed": featureGeometryPassed,
      "exact_feature_match": options.exactFeatureMatch,
      "geometry_tolerance": options.geometryTolerance,
      "intersection_over_union": featureIoU,
      "intersection_over_union_operator": options.exactFeatureMatch ? ">" : ">=",
      "minimum_intersection_over_union": options.minimumFeatureIoU,
      "feature_color_tolerance": options.featureColorTolerance,
      "minimum_feature_pixels": options.minimumFeaturePixels,
      "reference_color": colorDictionary(referenceColor),
      "actual_color": colorDictionary(actualColor),
      "reference": featureDictionary(referenceFeature),
      "actual": featureDictionary(actualFeature),
      "absolute_bound_deltas": geometryDeltas,
    ]
  }
  let reportData = try JSONSerialization.data(
    withJSONObject: report, options: [.prettyPrinted, .sortedKeys])
  try reportData.write(to: URL(fileURLWithPath: reportPath), options: .atomic)

  let status = passed ? "PASS" : "FAIL"
  print(
    "\(status): \(reference.width)x\(reference.height), \(comparedPixels) compared, \(ignoredPixels) ignored"
  )
  if let referenceFeature, let actualFeature, let featureGeometryPassed, let geometryDeltas,
    let featureIoU
  {
    let geometryStatus = featureGeometryPassed ? "PASS" : "FAIL"
    let deltaX = geometryDeltas["x"]!
    let deltaY = geometryDeltas["y"]!
    let deltaWidth = geometryDeltas["width"]!
    let deltaHeight = geometryDeltas["height"]!
    print(
      "Feature bounds: reference \(referenceFeature.bounds.x),\(referenceFeature.bounds.y),"
        + "\(referenceFeature.bounds.width),\(referenceFeature.bounds.height); actual "
        + "\(actualFeature.bounds.x),\(actualFeature.bounds.y),\(actualFeature.bounds.width),"
        + "\(actualFeature.bounds.height)"
    )
    print(
      "Feature geometry \(geometryStatus): x \(deltaX), y \(deltaY), "
        + "width \(deltaWidth), height \(deltaHeight) "
        + "(maximum \(options.geometryTolerance))"
    )
    print(
      String(
        format: "Feature silhouette IoU: %.4f%% (required %@ %.4f%%)",
        featureIoU * 100,
        options.exactFeatureMatch ? ">" : ">=",
        options.minimumFeatureIoU * 100
      )
    )
  }
  print(String(format: "Exact pixels: %.4f%%", exactPixelRate * 100))
  print(
    String(
      format: "Within tolerance %d: %.4f%% (required %.4f%%)",
      options.channelTolerance,
      selectedPassRate * 100,
      options.minimumPassRate * 100
    )
  )
  print(
    String(
      format: "MAE: %.4f / 255, RMSE: %.4f / 255, max delta: %d", meanAbsoluteError,
      rootMeanSquareError, maximumChannelDelta))
  print("Report: \(reportPath)")
  return passed
}

do {
  let options = try parseOptions()
  Darwin.exit(try compare(options: options) ? 0 : 1)
} catch {
  fputs("Error: \(error)\n", stderr)
  fputs("Run with --help for usage.\n", stderr)
  Darwin.exit(2)
}
