/*
 Copyright (C) 2016 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information

 Abstract:
 A struct for accessing generic password keychain items.
 */

import Foundation

struct KeychainPasswordItem {

   // MARK: - Types

   enum KeychainError: Error {
      case noPassword
      case unexpectedPasswordData
      case unexpectedItemData
      case unhandledError(status: OSStatus)
   }

   // MARK: - Properties

   let service: String
   private(set) var account: String
   let accessGroup: String?

   // MARK: - Initialization

   init(service: String, account: String, accessGroup: String? = nil) {
      self.service = service
      self.account = account
      self.accessGroup = accessGroup
   }

   // MARK: - Keychain Access

   func readPassword() throws -> String {

      let keychainData = try readData()

      // Parse the password string from the query result.
      guard let password = String(data: keychainData, encoding: .utf8) else {
         throw KeychainError.unexpectedPasswordData
      }

      return password
   }

   func readObject<T>() throws -> T where T: Decodable {

      let keychainData = try readData()

      // Parse the JSON object from the query result.
      let decoder = JSONDecoder()
      let object = try decoder.decode(T.self, from: keychainData)

      return object
   }

   func readData() throws -> Data {

      // Build a query to find the item that matches the service, account and
      // access group.
      var query = KeychainPasswordItem.keychainQuery(withService: service, account: account, accessGroup: accessGroup)
      query[kSecMatchLimit as String] = kSecMatchLimitOne
      query[kSecReturnAttributes as String] = kCFBooleanTrue
      query[kSecReturnData as String] = kCFBooleanTrue

      // Try to fetch the existing keychain item that matches the query.
      var queryResult: AnyObject?
      let status = withUnsafeMutablePointer(to: &queryResult) {
         SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))
      }

      // Check the return status and throw an error if appropriate.
      guard status != errSecItemNotFound else { throw KeychainError.noPassword }
      guard status == noErr else { throw KeychainError.unhandledError(status: status) }

      // Parse the password string from the query result.
      guard
         let existingItem = queryResult as? [String: AnyObject],
         let passwordData = existingItem[kSecValueData as String] as? Data
      else {
         throw KeychainError.unexpectedPasswordData
      }

      return passwordData
   }

   func saveJSON<T>(_ object: T) throws where T: Encodable {

      // Encode the JSON object into an Data.
      let encoder = JSONEncoder()
      let data = try encoder.encode(object)

      try save(data)
   }

   func save(_ keychainData: Data) throws {

      do {
         // Check for an existing item in the keychain.
         try _ = readPassword()

         // Update the existing item with the new password.
         var attributesToUpdate = [String: AnyObject]()
         attributesToUpdate[kSecValueData as String] = keychainData as AnyObject?

         let query = KeychainPasswordItem.keychainQuery(withService: service, account: account, accessGroup: accessGroup)
         let status = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)

         // Throw an error if an unexpected status was returned.
         guard status == noErr else { throw KeychainError.unhandledError(status: status) }

      } catch KeychainError.noPassword {

         // No password was found in the keychain. Create a dictionary to save
         // as a new keychain item.
         var newItem = KeychainPasswordItem.keychainQuery(withService: service, account: account, accessGroup: accessGroup)
         newItem[kSecValueData as String] = keychainData as AnyObject?

         // Add a the new item to the keychain.
         let status = SecItemAdd(newItem as CFDictionary, nil)

         // Throw an error if an unexpected status was returned.
         guard status == noErr else { throw KeychainError.unhandledError(status: status) }
      }
   }

   func deleteItem() throws {

      // Delete the existing item from the keychain.
      let query = KeychainPasswordItem.keychainQuery(withService: service, account: account, accessGroup: accessGroup)
      let status = SecItemDelete(query as CFDictionary)

      // Throw an error if an unexpected status was returned.
      guard status == noErr || status == errSecItemNotFound else { throw KeychainError.unhandledError(status: status) }
   }

   // MARK: - Convenience

   private static func keychainQuery(withService service: String, account: String? = nil, accessGroup: String? = nil) -> [String: AnyObject] {

      var query = [String: AnyObject]()
      query[kSecClass as String] = kSecClassGenericPassword
      query[kSecAttrService as String] = service as AnyObject?

      if let account = account {
         query[kSecAttrAccount as String] = account as AnyObject?
      }

      if let accessGroup = accessGroup {
         query[kSecAttrAccessGroup as String] = accessGroup as AnyObject?
      }

      return query
   }
}
