// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {IPoolManager} from './contracts/interfaces/IPoolManager.sol';
import {IDynamicFeeManager} from './contracts/interfaces/IDynamicFeeManager.sol';
import {Hooks} from './contracts/libraries/Hooks.sol';
import {FeeLibrary} from './contracts/libraries/FeeLibrary.sol';
import {BaseHook} from './BaseHook.sol';
import {PoolKey} from './contracts/types/PoolKey.sol';

// contract InferCallContract{
//     function inferCall(string calldata modelName, string calldata inputData) public returns(bytes32){
//           bytes32[2] memory output;
//           bytes memory args = abi.encodePacked(modelName,"-",inputData);
//            assembly {
//                 if iszero(staticcall(not(0), 0x100, add(args, 32), mload(args), output, 12)) {
//                 revert(0, 0)
//                 }
//             }
//         return output[0];
//     }
// }
contract DynamicFeeHook is BaseHook, IDynamicFeeManager {
    using FeeLibrary for uint24;

    error MustUseDynamicFee();
    uint24 fee;
    uint32 deployTimestamp;

    // function setFee(string calldata modelName, string calldata inputData) public  {
    //     bytes32 data = inferCall(modelName,inputData);
    //     fee = uint24(uint256(data) & 0xFFFFFF);
    // }
    function getFee(
        address,
        PoolKey calldata,
        IPoolManager.SwapParams calldata,
        bytes calldata
    ) external view returns (uint24) {
        return 0;
    }

    /// @dev For mocking
    function _blockTimestamp() internal view virtual returns (uint32) {
        return uint32(block.timestamp);
    }

    constructor(IPoolManager _poolManager) BaseHook(_poolManager) {
        deployTimestamp = _blockTimestamp();
    }

    function getHooksCalls() public pure override returns (Hooks.Calls memory) {
        return
            Hooks.Calls({
                beforeInitialize: true,
                afterInitialize: false,
                beforeModifyPosition: false,
                afterModifyPosition: false,
                beforeSwap: false,
                afterSwap: false,
                beforeDonate: false,
                afterDonate: false
            });
    }

    function beforeInitialize(
        address,
        PoolKey calldata key,
        uint160,
        bytes calldata
    ) external pure override returns (bytes4) {
        if (!key.fee.isDynamicFee()) revert MustUseDynamicFee();
        return DynamicFeeHook.beforeInitialize.selector;
    }
}
