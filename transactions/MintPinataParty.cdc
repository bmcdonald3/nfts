import PinataPartyContract from 0xf8d6e0586b0a20c7

transaction {
    let receiverRef: &{PinataPartyContract.NFTReceiver}
    let minterRef: &PinataPartyContract.NFTMinter

    prepare(acct: AuthAccount) {
        self.receiverRef = acct.getCapability<&{PinataPartyContract.NFTReceiver}>(/public/NFTReceiver)
        .borrow()
        ?? panic("Could not borrow receiver reference")        

        self.minterRef = acct.borrow<&PinataPartyContract.NFTMinter>(from: /storage/NFTMinter)
        ?? panic("could not borrow minter reference")
    }

    execute {
        let metadata : {String : String} = {
            "name": "Hello",
            "color": "blind", 
            "sports": "yes",
            "uri": "ipfs://QmTpbVxkwsJp78FqAB7zJpgZRWRPKWbySZu5AFSLf6aeWR"
        }
        let newNFT <- self.minterRef.mintNFT()

        self.receiverRef.deposit(token: <-newNFT, metadata: metadata)

        log("NFT Minted and deposited to Account 2's Collection")
    }
}