// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract LiquidityLocker {
    address public owner;
    uint256 public unlockTime;
    address public lpToken;

    constructor(address _lpToken, uint256 _lockDuration) {
        owner = msg.sender;
        lpToken = _lpToken;
        unlockTime = block.timestamp + _lockDuration;
    }

    function withdraw() external {
        require(msg.sender == owner, "Only owner can withdraw");
        require(block.timestamp >= unlockTime, "Liquidity is still locked");

        IERC20(lpToken).transfer(owner, IERC20(lpToken).balanceOf(address(this)));
    }

    function lockLiquidity(uint256 amount) external {
        require(msg.sender == owner, "Only owner can lock liquidity");
        require(IERC20(lpToken).transferFrom(msg.sender, address(this), amount), "Transfer failed");
    }
}

interface IERC20 {
    function transfer(address recipient, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
}