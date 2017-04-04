pragma solidity ^0.4.8;

import 'ds-cache/cache.sol';

contract MedianizerEvents {
    event LogSet(bytes12 pos, address wat);
}

contract Medianizer is DSCache, MedianizerEvents {
    mapping (bytes12 => DSValue) public values;
    mapping (address => bytes12) public indexes;

    bytes12 public next = 0x1;
    
    function set(address wat) auth {
        bytes12 nextId = bytes12(uint96(next) + 1);
        assert(nextId != 0x0);
        set(next, wat);
        next = nextId;
    }

    function set(bytes12 pos, address wat) auth {
        if (indexes[wat] != 0 && pos != 0x0) throw;

        if (wat == 0) {
            indexes[values[pos]] = 0;
        } else {
            indexes[wat] = pos;
        }

        values[pos] = DSValue(wat);

        LogSet(pos, wat);
    }

    function unset(bytes12 pos) {
        set(pos, 0);
    }

    function unset(address wat) {
        set(indexes[wat], 0);
    }

    function poke() auth {
        val = compute();
        has = true;
    }

    function poke(bytes32) {
        poke();
    }

    function prod(uint128 Zzz) {
        prod(0, Zzz);
    }

    function compute() internal constant returns (bytes32) {
        if (next <= 0x1) throw;

        bytes32[] memory wuts = new bytes32[](uint96(next) - 1);
        uint96 ctr = 0;
        for (uint96 i = 1; i < uint96(next); i++) {
            if (address(values[bytes12(i)]) != 0) {
                bytes32 wut = values[bytes12(i)].read();
                if (ctr == 0 || wut >= wuts[ctr - 1]) {
                    wuts[ctr] = wut;
                } else {
                    uint96 j = 0;
                    while (wut >= wuts[j]) {
                        j++;
                    }
                    for (uint96 k = ctr; k > j; k--) {
                        wuts[k] = wuts[k - 1];
                    }
                    wuts[j] = wut;
                }
                ctr++;
            }
        }

        if (ctr % 2 == 0) {
            uint128 val1 = uint128(wuts[(ctr / 2) - 1]);
            uint128 val2 = uint128(wuts[ctr / 2]);
            return bytes32(wdiv(incr(val1, val2), 2 ether));
        } else {
            return wuts[(ctr - 1) / 2];
        }
    }

}
