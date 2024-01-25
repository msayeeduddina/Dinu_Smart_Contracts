// SPDX-License-Identifier: MIT


//    /$$$$$$$  /$$$$$$ /$$   /$$ /$$   /$$
//   | $$__  $$|_  $$_/| $$$ | $$| $$  | $$
//   | $$  \ $$  | $$  | $$$$| $$| $$  | $$
//   | $$  | $$  | $$  | $$ $$ $$| $$  | $$
//   | $$  | $$  | $$  | $$  $$$$| $$  | $$
//   | $$  | $$  | $$  | $$\  $$$| $$  | $$
//   | $$$$$$$/ /$$$$$$| $$ \  $$|  $$$$$$/
//   |_______/ |______/|__/  \__/ \______/ 


pragma solidity ^0.8.20;


import "./ERC20.sol";
import "./Ownable.sol";

// I'm here for the $DINU - CryptoQuine

contract DIAPERINU is ERC20, Ownable(msg.sender) {
    // Added state variable for lubrication - gently does it!
    // Lubrication prevents any wallet receiving more than 1% of DINU in the opening days.
    bool public lubricating = true;
    address public liquidityPool;

    // Mint the totalSupply (100 T) to the deployer
    constructor() ERC20("DIAPERINU", "DINU") {
        _mint(msg.sender, 100000000000000 * 10 ** 18);
    }

    // Function to set lubricating state
    function setLubricating(bool _state) external onlyOwner {
        lubricating = _state;
    }

    // Define the LP address to enable trading!
    function setLiquidityPool(address _liquidityPool) external onlyOwner {
        liquidityPool = _liquidityPool;
    }

    // Override _update function to include lubricating logic (previously _beforeTokenTransfer)
    function _update(
        address from,
        address to,
        uint256 amount
    ) internal virtual override {
        super._update(from, to, amount);
        // If liquidityPool is address(0) we've not yet enabled trading. Liquidity Loading....
        if(liquidityPool == address(0)) {
            require(from == owner() || to == owner(), "Patience - Trading Not Started Yet!");
            return;
        }
        // Allow deployer (owner) to send/receive any amount and the liquidityPool to receive any amount.
        // This allows for loading of the LP, and for people to sell tokens into the LP whilst lubrication in progress.
        if (lubricating && from != owner() && to != liquidityPool) {
            // Require that a receiving wallet will not hold more than 1% of supply after a transfer whilst lubrication is in effect
            require(
                balanceOf(to) <= totalSupply() / 100,
                "Just getting warmed up, limit of 1% of Diaper can be Inu until Lubrication is complete!"
            );
        }
    }
    // Renounce the contract and pass ownership to address(0) to lock the contract forever more.
    function renounceTokenOwnership() public onlyOwner {
        renounceOwnership();
    }
}
// $DINU is a meme coin with no intrinsic value or expectation of financial return. There is no formal team or roadmap. The coin is completely useless and for entertainment purposes only.
