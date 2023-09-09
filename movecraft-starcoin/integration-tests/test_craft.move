//# init -n dev

//# faucet --addr alice

//# faucet --addr MoveCraft

//# run --signers MoveCraft

script {
    use MoveCraft::MoveCraft;
    fun main(sender: signer) {
        MoveCraft::initialize(sender);
    }
}
// check: EXECUTED

//# run --signers alice

script {
    use StarcoinFramework::Option;
    use MoveCraft::Block;
    use MoveCraft::Crafting2x2;
    use MoveCraft::Log;
    use MoveCraft::Planks;

    fun main(sender: signer) {
        let block = Block::mint(&sender);
        let recipe_opt = Crafting2x2::get_recipe(Log::block_type(), 0, 0, 0);
        let recipe = Option::destroy_some(recipe_opt);
        let mater = Crafting2x2::new_materials_one(block);
        let output = Crafting2x2::craft(&recipe, mater);
        assert!(Block::block_type(&output) == Planks::block_type(), 1000);
        Block::burn(output);
    }
}