//
//  StoreKitManager.swift
//  InteliFitness
//
//  Created by Shawn Wakeman on 6/20/23.
//

import Foundation
import StoreKit

class StoreKitManager: ObservableObject {
    @Published var storeProducts: [Product] = []
    @Published var purchasedProduts: [Product] = []
    
    var updateListenerTask: Task<Void, Error>? = nil
    
    private let productDict: [String: String]
    
    
    
    init() {
        if let plistPath = Bundle.main.path(forResource: "Property List", ofType: "plist"),
           let plist = FileManager.default.contents(atPath: plistPath) {
            productDict = (try? PropertyListSerialization.propertyList(from: plist, format: nil) as? [String: String]) ?? [:]
            
        } else {
            productDict = [:]
        }
        updateListenerTask = listenForTransactions()
        
        Task {
            await requestProducts()
            
            
            await updateCustomerProductStatus()
        }
    }
    
    deinit {
        updateListenerTask?.cancel()
    }
    
    func listenForTransactions() -> Task<Void, Error> {
        return Task.detached {
            
            for await result in Transaction.updates {
                do {
                    let transaction = try self.checkVerified(result)
                    
                    await self.updateCustomerProductStatus()
                    
                    await transaction.finish()
                } catch {
                    print("Failed to veryfy")
                }
            }
        }
    }
    
    @MainActor
    func requestProducts() async {
        do {
            storeProducts = try await Product.products(for: productDict.values)
        } catch {
            print("Failed \(error)")
        }
        
    }
    
    
    func purchase(_ product: Product) async throws -> Transaction? {
        let result = try await product.purchase()
        
        switch result {
            
        case .success(let varificationResult):
            let transaction = try checkVerified(varificationResult)
            
            
            await updateCustomerProductStatus()
            
            await transaction.finish()
            
            
            return transaction
            
            
        case.userCancelled, .pending:
            return nil
            
        default:
            return nil
            
        }
    }
    
    
    func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
            
        case .unverified:
            throw StoreError.failedVerification
            
            
        case .verified(let signedType):
            return signedType
        }
    }
    
    @MainActor
    func updateCustomerProductStatus() async {
        var purchasedProducts: [Product] = []
        
        for await result in Transaction.currentEntitlements {
            do {
                
                
                
                let transaction = try checkVerified(result)
                
                
                if let product = storeProducts.first(where: {$0.id == transaction.productID}) {
                    purchasedProducts.append(product)
                }
            } catch {
                print("Transaction Failed")
            }
            
            
            self.purchasedProduts = purchasedProducts
        }
    }
}

public enum StoreError: Error {
    case failedVerification
}
