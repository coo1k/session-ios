
@objc public final class ContactParser : NSObject {
    private let data: Data
    
    @objc public init(data: Data) {
        self.data = data
    }
    
    @objc public func parseHexEncodedPublicKeys() -> [String] {
        var index = 0
        var result: [String] = []
        while index < data.endIndex {
            let uncheckedSize: UInt32? = try? data[index..<(index+4)].withUnsafeBytes { $0.pointee }
            guard let size = uncheckedSize else { break }
            let sizeAsInt = Int(size)
            index += 4
            let protoAsData = data[index..<(index+sizeAsInt)]
            guard let proto = try? SSKProtoContactDetails.parseData(protoAsData) else { break }
            index += sizeAsInt
            result.append(proto.number)
        }
        return result
    }
}
