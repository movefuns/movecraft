module my_addr::block {
    // generate block using the object NFT in Aptos Framework.
    // reference: 
    // > https://github.com/aptos-labs/aptos-core/tree/main/aptos-move/move-examples/token_objects/hero/sources

    use std::error;
    use std::option::{Self, Option};
    use std::signer;
    use std::string::{Self, String};

    use aptos_framework::object::{Self, ConstructorRef, Object};

    use aptos_token_objects::collection;
    use aptos_token_objects::token;
    use aptos_std::string_utils;

    struct OnChainConfig has key {
        collection: String,
    }

    #[resource_group_member(group = aptos_framework::object::ObjectGroup)]
    struct Block has copy, drop, store, key {
        type: u64,
    }

    #[resource_group_member(group = aptos_framework::object::ObjectGroup)]
    struct BlockBucket has store, key{
        stackable: bool,
        blocks: Option<Object<Block>>
    }

    // need capability
    // mint any type as user like
    public entry fun mint_block(account: &signer, type: u64) acquires OnChainConfig {
        create_block(account, type);
    }

    fun create(
        creator: &signer,
        description: String,
        name: String,
        uri: String,
    ): ConstructorRef acquires OnChainConfig {
        let on_chain_config = borrow_global<OnChainConfig>(signer::address_of(creator));
        token::create_named_token(
            creator,
            on_chain_config.collection,
            description,
            name,
            option::none(),
            uri,
        )
    }

    //:!:> Creation methods
    public fun create_block(
        creator: &signer,
        type: u64
    ): Object<Block> acquires OnChainConfig {
        // TODO: the default uri could be show here
        let constructor_ref = create(creator, string::utf8(b"blocks"), string::utf8(b"a block"), string::utf8(b"blocks"));
        let token_signer = object::generate_signer(&constructor_ref);

        let block = Block {
            type: type
        };
        move_to(&token_signer, block);

        object::address_to_object(signer::address_of(&token_signer))
    }

    //<:!: Creation methods


}