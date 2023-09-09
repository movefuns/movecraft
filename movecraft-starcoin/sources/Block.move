module MoveCraft::Block{
    use StarcoinFramework::NFT::{Self, NFT, MintCapability, BurnCapability, UpdateCapability};
    use StarcoinFramework::Signer;
    use MoveCraft::BlockType;

    friend MoveCraft::Crafting2x2;

    const NAME: vector<u8> = b"Block";
    const DESCRIPTION: vector<u8> = b"MoveCraft Block";
    const IMAGE: vector<u8> = b"data:image/svg+xml;base64,PHN2ZyB2ZXJzaW9uPSIxLjEiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyIgeG1sbnM6eGxpbms9Imh0dHA6Ly93d3cudzMub3JnLzE5OTkveGxpbmsiIHdpZHRoPSIzMS41NTM5MiIgaGVpZ2h0PSIzNC44NDkwNiIgdmlld0JveD0iMCwwLDMxLjU1MzkyLDM0Ljg0OTA2Ij48ZyB0cmFuc2Zvcm09InRyYW5zbGF0ZSgtMjI0LjMxMjUsLTE2MC45NDc1NCkiPjxnIGRhdGEtcGFwZXItZGF0YT0ieyZxdW90O2lzUGFpbnRpbmdMYXllciZxdW90Ozp0cnVlfSIgZmlsbC1ydWxlPSJub256ZXJvIiBzdHJva2UtbGluZWNhcD0iYnV0dCIgc3Ryb2tlLWxpbmVqb2luPSJtaXRlciIgc3Ryb2tlLW1pdGVybGltaXQ9IjEwIiBzdHJva2UtZGFzaGFycmF5PSIiIHN0cm9rZS1kYXNob2Zmc2V0PSIwIiBzdHlsZT0ibWl4LWJsZW5kLW1vZGU6IG5vcm1hbCI+PHBhdGggZD0iTTIyNC41NjI1LDE5NS41NDY2di0zMS4zNDkwNmgzMS4wNTM5MnYzMS4zNDkwNnoiIGZpbGw9Im5vbmUiIHN0cm9rZT0iIzA0YjZmZiIgc3Ryb2tlLXdpZHRoPSIwLjUiLz48dGV4dCB0cmFuc2Zvcm09InRyYW5zbGF0ZSgyMzMuODEyNSwxODYuMTk3NTQpIHNjYWxlKDAuNSwwLjUpIiBmb250LXNpemU9IjQwIiB4bWw6c3BhY2U9InByZXNlcnZlIiBmaWxsPSIjMDBhNWE1IiBmaWxsLXJ1bGU9Im5vbnplcm8iIHN0cm9rZT0ibm9uZSIgc3Ryb2tlLXdpZHRoPSIxIiBzdHJva2UtbGluZWNhcD0iYnV0dCIgc3Ryb2tlLWxpbmVqb2luPSJtaXRlciIgc3Ryb2tlLW1pdGVybGltaXQ9IjEwIiBzdHJva2UtZGFzaGFycmF5PSIiIHN0cm9rZS1kYXNob2Zmc2V0PSIwIiBmb250LWZhbWlseT0iUGl4ZWwiIGZvbnQtd2VpZ2h0PSJub3JtYWwiIHRleHQtYW5jaG9yPSJzdGFydCIgc3R5bGU9Im1peC1ibGVuZC1tb2RlOiBub3JtYWwiPjx0c3BhbiB4PSIwIiBkeT0iMCI+QjwvdHNwYW4+PC90ZXh0PjwvZz48L2c+PC9zdmc+";

    struct Block has copy, drop, store {
        type: u64,
    }

    struct BlockBody has store{
        stackable: bool,
        count: u64
    }


    public(friend) fun unpack(body: BlockBody): (bool, u64){
        let BlockBody{stackable, count} = body;
        (stackable, count)
    }


    public fun stack(body: &mut BlockBody, other: BlockBody){
        assert!(body.stackable, 100);
        assert!(other.stackable, 101);
        let (_,count) = Self::unpack(other);
        body.count = body.count + count;
       
    }

    public(friend) fun stackable_body(count: u64): BlockBody {
        BlockBody{
            stackable: true,
            count,
        }
    }

    public(friend) fun non_stackable_body(): BlockBody{
        BlockBody{
            stackable: false,
            count: 1,
        }
    }


    struct BlockCapability has key {
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

    public fun block_type_info(index: u64, stackable: bool, mintable: bool): BlockTypeInfo{
        BlockTypeInfo{
            index,
            stackable,
            mintable,
        }
    }


    const CONTRACT_ACCOUNT:address = @MoveCraft;

 
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
    }

    public fun block_type(block: &NFT<Block, BlockBody>): u64 {
        let type_meta = NFT::get_type_meta(block);
        type_meta.type
    }


    public fun mint(_sender: &signer): NFT<Block, BlockBody> acquires BlockCapability{
        //TODO do random mint block type, and maybe return None;
        let random: u64 = 11;

        let type_index = random;
        let nft = mint_by_type(type_index);
        nft
    }

    public(friend) fun mint_by_type(type_index: u64): NFT<Block, BlockBody> acquires BlockCapability{
        let cap = borrow_global_mut<BlockCapability>(CONTRACT_ACCOUNT);
        let metadata = BlockType::metadata_by_index(type_index);
        let body = if (BlockType::is_stackable(type_index)) {
            Self::stackable_body(1)
        }else {
            Self::non_stackable_body()
        };
        let nft = NFT::mint_with_cap_v2<Block, BlockBody>(@MoveCraft, &mut cap.mint_cap, metadata, Block{ type: type_index }, body);
        nft
    }

    public fun burn(block: NFT<Block, BlockBody>) acquires BlockCapability {
        let cap = borrow_global_mut<BlockCapability>(CONTRACT_ACCOUNT);
        let body = NFT::burn_with_cap<Block, BlockBody>(&mut cap.burn_cap, block);
        let (_,_) = Self::unpack(body);
    }

}