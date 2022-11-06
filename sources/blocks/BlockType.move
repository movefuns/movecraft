module MoveCraft::BlockType{
    use StarcoinFramework::NFT::{Metadata};
    use MoveCraft::Log;
    use MoveCraft::Planks;
    
    ///Get Block name and description by type index
    public fun  metadata_by_index(block_type_index: u64): Metadata{
        if(block_type_index == Log::block_type()){
            Log::metadata()
        }else if(block_type_index == Planks::block_type()){
            Planks::metadata()
        }else{
            abort 102
        }
    }

    public fun is_mintable(block_type_index: u64): bool{
        if(block_type_index == Log::block_type()){
            Log::mintable()
        }else if(block_type_index == Planks::block_type()){
            Planks::mintable()
        }else{
            abort 102
        }
    }

    public fun is_stackable(block_type_index: u64): bool{
        if(block_type_index == Log::block_type()){
            Log::stackable()
        }else if(block_type_index == Planks::block_type()){
            Planks::stackable()
        }else{
            abort 102
        }
    }
}