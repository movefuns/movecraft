module MoveCraft::Block{
    use StarcoinFramework::NFT::{Self, NFT, MintCapability, BurnCapability, UpdateCapability};
	use StarcoinFramework::Signer;
    use MoveCraft::Log::{Self, Log};
    use MoveCraft::Planks::{Self, Planks};
    use MoveCraft::BlockBody::{BlockBody};

    struct BlockTypeInfo<phantom BlockType: copy + drop + store> has key {
        index: u64,
        stackable: bool,
        mintable: bool,
        mint_cap: MintCapability<BlockType>,
        burn_cap: BurnCapability<BlockType>,
        update_cap: UpdateCapability<BlockType>,
    }


    const CONTRACT_ACCOUNT:address = @MoveCraft;

    public fun initialize(sender: &signer) {
        assert!(Signer::address_of(sender)==CONTRACT_ACCOUNT, 101);
		
        try_register<Log>(sender, Log::name(), Log::image(), Log::description(), 1, true, true);
        try_register<Planks>(sender, Planks::name(), Planks::image(), Planks::description(), 2, true, false);
    }

    fun try_register<BlockType: copy + drop + store>(sender: &signer, name:vector<u8>, image: vector<u8>, description: vector<u8>, index: u64, stackable: bool,
        mintable: bool,){
        let addr = Signer::address_of(sender);
        if(!exists<BlockTypeInfo<BlockType>>(addr)) {
          
			let meta = NFT::new_meta_with_image_data(name, image, description);

			NFT::register_v2<BlockType>(sender, meta);

			let mint_cap = NFT::remove_mint_capability<BlockType>(sender);
			let burn_cap = NFT::remove_burn_capability<BlockType>(sender);
			let update_cap = NFT::remove_update_capability<BlockType>(sender);

            let info = BlockTypeInfo<BlockType>{
                index,
                stackable,
                mintable,
                mint_cap,
                burn_cap,
                update_cap,
            };
			move_to(sender, info);
		}
    }

    //TODO mint block should use tools
    fun mint_log() : NFT<Log, BlockBody> acquires BlockTypeInfo{
        let info = borrow_global_mut<BlockTypeInfo<Log>>(CONTRACT_ACCOUNT);
        Log::mint(&mut info.mint_cap)
    }
}