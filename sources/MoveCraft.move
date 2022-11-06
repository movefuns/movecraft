module MoveCraft::MoveCraft{
    use MoveCraft::Block;
    use MoveCraft::Crafting2x2;

    public(script) fun initialize(sender: signer){
        Block::initialize(&sender);
        Crafting2x2::initialize(&sender);
        
        Crafting2x2::register(11, 0, 0, 0, 12);        
    }
}