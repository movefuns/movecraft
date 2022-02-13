module MoveCraft::Block{
    use StarcoinFramework::NFT::{Self, NFT, MintCapability, BurnCapability, UpdateCapability, Metadata};
    use StarcoinFramework::NFTGallery::{Self};
	use StarcoinFramework::Signer;
    use MoveCraft::Log::{Self, Log};
    use MoveCraft::Planks::{Self, Planks};
    use MoveCraft::BlockBody::{Self, BlockBody};

    const NAME: vector<u8> = b"Block";
    const DESCRIPTION: vector<u8> = b"MoveCraft Block";
    const IMAGE: vector<u8> = b"data:image/svg+xml;base64,PHN2ZyB2ZXJzaW9uPSIxLjEiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyIgeG1sbnM6eGxpbms9Imh0dHA6Ly93d3cudzMub3JnLzE5OTkveGxpbmsiIHdpZHRoPSIzMS41NTM5MiIgaGVpZ2h0PSIzNC44NDkwNiIgdmlld0JveD0iMCwwLDMxLjU1MzkyLDM0Ljg0OTA2Ij48ZyB0cmFuc2Zvcm09InRyYW5zbGF0ZSgtMjI0LjMxMjUsLTE2MC45NDc1NCkiPjxnIGRhdGEtcGFwZXItZGF0YT0ieyZxdW90O2lzUGFpbnRpbmdMYXllciZxdW90Ozp0cnVlfSIgZmlsbC1ydWxlPSJub256ZXJvIiBzdHJva2UtbGluZWNhcD0iYnV0dCIgc3Ryb2tlLWxpbmVqb2luPSJtaXRlciIgc3Ryb2tlLW1pdGVybGltaXQ9IjEwIiBzdHJva2UtZGFzaGFycmF5PSIiIHN0cm9rZS1kYXNob2Zmc2V0PSIwIiBzdHlsZT0ibWl4LWJsZW5kLW1vZGU6IG5vcm1hbCI+PHBhdGggZD0iTTIyNC41NjI1LDE5NS41NDY2di0zMS4zNDkwNmgzMS4wNTM5MnYzMS4zNDkwNnoiIGZpbGw9Im5vbmUiIHN0cm9rZT0iIzA0YjZmZiIgc3Ryb2tlLXdpZHRoPSIwLjUiLz48dGV4dCB0cmFuc2Zvcm09InRyYW5zbGF0ZSgyMzMuODEyNSwxODYuMTk3NTQpIHNjYWxlKDAuNSwwLjUpIiBmb250LXNpemU9IjQwIiB4bWw6c3BhY2U9InByZXNlcnZlIiBmaWxsPSIjMDBhNWE1IiBmaWxsLXJ1bGU9Im5vbnplcm8iIHN0cm9rZT0ibm9uZSIgc3Ryb2tlLXdpZHRoPSIxIiBzdHJva2UtbGluZWNhcD0iYnV0dCIgc3Ryb2tlLWxpbmVqb2luPSJtaXRlciIgc3Ryb2tlLW1pdGVybGltaXQ9IjEwIiBzdHJva2UtZGFzaGFycmF5PSIiIHN0cm9rZS1kYXNob2Zmc2V0PSIwIiBmb250LWZhbWlseT0iUGl4ZWwiIGZvbnQtd2VpZ2h0PSJub3JtYWwiIHRleHQtYW5jaG9yPSJzdGFydCIgc3R5bGU9Im1peC1ibGVuZC1tb2RlOiBub3JtYWwiPjx0c3BhbiB4PSIwIiBkeT0iMCI+QjwvdHNwYW4+PC90ZXh0PjwvZz48L2c+PC9zdmc+";

    struct Block has copy, drop, store{}

    struct BlockCapability has key{
        mint_cap: MintCapability<Block>,
        burn_cap: BurnCapability<Block>,
        update_cap: UpdateCapability<Block>,
    }

    struct BlockTypeInfo has store, copy, drop {
        //global type index
        index: u64,
        stackable: bool,
        mintable: bool,
    }

    struct BlockTypeInfoKey<phantom BlockType> has key {
        info: BlockTypeInfo,
    }


    const CONTRACT_ACCOUNT:address = @MoveCraft;

    const LOG_TYPE: u64 = 11;
    const PLANKS_TYPE: u64 = 12;

    public fun initialize(sender: &signer) {
        assert!(Signer::address_of(sender)==CONTRACT_ACCOUNT, 101);
		
         let addr = Signer::address_of(sender);

        if(!exists<BlockCapability>(addr)) {
          
			let meta = NFT::new_meta_with_image_data(*&NAME, *&IMAGE, *&DESCRIPTION);
			NFT::register_v2<Block>(sender, meta);

			let mint_cap = NFT::remove_mint_capability<Block>(sender);
			let burn_cap = NFT::remove_burn_capability<Block>(sender);
			let update_cap = NFT::remove_update_capability<Block>(sender);

            let cap = BlockCapability{
                mint_cap,
                burn_cap,
                update_cap,
            };
			move_to(sender, cap);
		};
        
        try_register_block<Log>(sender, LOG_TYPE, true, true);
        try_register_block<Planks>(sender, PLANKS_TYPE, true, false);
    }

    fun try_register_block<BlockType: copy + drop + store>(sender: &signer, index: u64, stackable: bool,
        mintable: bool,){
        let addr = Signer::address_of(sender);
        if(!exists<BlockTypeInfoKey<BlockType>>(addr)) {
            let info = BlockTypeInfoKey<BlockType>{
                info:BlockTypeInfo{
                    index,
                    stackable,
                    mintable,
                }
            };
			move_to(sender, info);
		}
    }

    ///Get Block metadata by BlockType
    public fun metadata<BlockType: copy + drop + store>(): Metadata acquires BlockTypeInfoKey {
        let info = borrow_global<BlockTypeInfoKey<BlockType>>(CONTRACT_ACCOUNT);
        metadata_by_index(info.info.index)
    }

    ///Get Block name and description by type index
    public fun  metadata_by_index(block_type_index: u64): Metadata{
        if(block_type_index == LOG_TYPE){
            Log::metadata()
        }else if(block_type_index == PLANKS_TYPE){
            Planks::metadata()
        }else{
            abort 102
        }
    }

    public fun block_type_info<BlockType>(): BlockTypeInfo acquires BlockTypeInfoKey {
        let info = borrow_global<BlockTypeInfoKey<BlockType>>(CONTRACT_ACCOUNT);
        *&info.info
    }

    public fun block_type_info_by_index(block_type_index: u64): BlockTypeInfo acquires BlockTypeInfoKey {
        if(block_type_index == LOG_TYPE){
            Self::block_type_info<Log>()
        }else if(block_type_index == PLANKS_TYPE){
            Self::block_type_info<Planks>()
        }else{
            abort 102
        }
    }


    public fun mint(sender: &signer) acquires BlockCapability, BlockTypeInfoKey{
        //TODO do random mint block type
        let random:u64 = 1;

        let type_index = random;
        let cap = borrow_global_mut<BlockCapability>(CONTRACT_ACCOUNT);
        let metadata = metadata_by_index(type_index);
        let block_type_info = block_type_info_by_index(type_index);
        let body = if(block_type_info.stackable) {
            BlockBody::stackable_body(1)
        }else{
            BlockBody::non_stackable_body()
        };
        let nft = NFT::mint_with_cap_v2<Block,BlockBody>(@MoveCraft, &mut cap.mint_cap, metadata, Block{}, body);
        NFTGallery::deposit(sender, nft);
    }


    public fun craft(_sender: &signer): NFT<Planks, BlockBody>{
        // let metadata = NFT::new_meta(Self::name(), Self::description());
        // let count = Log::burn(burn_cap, log);
		// let nft = NFT::mint_with_cap_v2<Planks,BlockBody>(@MoveCraft, mint_cap, metadata, Planks{}, BlockBody::stackable_body(4 * count));
		// nft
        abort 0
    }
}