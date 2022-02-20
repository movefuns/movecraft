# Movecraft

A Minecraft-like on-chain game written in Move language.

## Motivation

Try to simulate the block and crafting system in Minecraft through NFT, and show the combinability of Move NFT.

## How to play

### Minting

1. Select Tools: Hand(default), Axe, Hoe. Use Axe or Hoe can increase the probability of getting Log or Stone.
2. Execute Mint function, Random got a BasicBlock(Log|Stone) or Emerald NFT.

### Crafting

1. Tools: CraftingGrid(2x2) or CraftingTable(3x3). CraftingGrid is default.
2. Log --> Planks --> Stick 
3. Planks --> CraftingTable
4. Stick + Plants --> (Wooden Axe| Wooden Hoe)
5. Stick + Stone --> (Stone Axe| Stone Hoe)

### Trading

1. Emerald is the currency of Game, and only can got by minting.
2. Players can publish Block NFT and Tool NFT in the market, and trading with Emerald.

## Roadmap

1. Implement Block NFT.
2. Implement Minting.
3. Implement Crafing and Recipe.
4. Implement Tools.
5. Implement a simple Web interface.
6. Implement the Market. 
