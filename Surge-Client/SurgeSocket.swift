//
//  SurgeSocket.swift
//  Surge-Client
//
//  Created by Dustin Guerrero on 5/21/15.
//  Copyright (c) 2015 Team-Surge. All rights reserved.
//

class SurgeSocket: NSObject {
  private var outputStream: NSOutputStream!
  private var inputStream: NSInputStream!
  private var host: String!
  private var port: Int!
  
  
  init(host: CFString, port: UInt32) {
    super.init()
    var readStream:  Unmanaged<CFReadStream>?
    var writeStream: Unmanaged<CFWriteStream>?
    
    CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault, host, port, &readStream, &writeStream)
    
    inputStream = readStream!.takeRetainedValue()
    outputStream = writeStream!.takeRetainedValue()
    
    inputStream.delegate = self
    outputStream.delegate = self
    
    inputStream.scheduleInRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
    outputStream.scheduleInRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
    
    inputStream.open()
    outputStream.open()
  }
  
  deinit {
    inputStream.close()
    outputStream.close()
  }
  
  func send(line: String) -> Int {
    let data = line.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
    return outputStream.write(UnsafePointer(data.bytes), maxLength: data.length)
  }
  
  func receive() -> String {
    var buffer = [UInt8](count: 4096, repeatedValue: 0)
    var output = ""
    while inputStream.hasBytesAvailable {
      var len = inputStream.read(&buffer, maxLength: buffer.count)
      if(len > 0){
        var line = NSString(bytes: &buffer, length: buffer.count, encoding: NSUTF8StringEncoding) as! String
        if (line != ""){
          output = output + line
        }
      }
    }
    return output
  }
  
}

extension SurgeSocket : NSStreamDelegate {
  func stream(stream: NSStream, handleEvent eventCode: NSStreamEvent) {
    switch eventCode {
    case NSStreamEvent.ErrorOccurred:
      break
    case NSStreamEvent.HasBytesAvailable:
      if stream == inputStream {
        println(receive())
      }
      break
    default:
      break
    }
  }
}
