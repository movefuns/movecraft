module MoveCraft::BlockBody{
    
    friend MoveCraft::Block;
    friend MoveCraft::Log;
    friend MoveCraft::Planks;

    struct BlockBody has store{
        stackable: bool,
        count: u64
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
}