pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Exchange is ERC20{
    address public tokenAddress ;

    constructor (address _token) ERC20("Zuniswap","ZUNI-1"){
        require(_token != address(0), "invalid token address");
        tokenAddress = _token;
    }

    // 添加流动性
    function addLiquidity(uint256 _tokenAmount) public payable returns(uint256){
        // 初始化池子
        if (getReserve() == 0){
            IERC20 token = IERC20(tokenAddress);
            token.transferFrom(msg.sender, address(this), _tokenAmount);

            //发放 LP Token
            uint256 liquidity = address(this).balance;
            _mint(msg.sender, liquidity);
            return liquidity;
        // 池子已经初始化
        }else{
            uint256 ethReserve = address(this).balance -msg.value;
            uint256 tokenReserve = getReserve();
            uint256 tokenAmount = (msg.value * tokenReserve)/ethReserve; 
            require(_tokenAmount > tokenAmount, "in sufficent token amount");

            IERC20 token = IERC20(tokenAddress);
            token.transferFrom(msg.sender, address(this), _tokenAmount);

            //发放 LP Token
            uint256 liquidity = totalSupply()*(msg.value/ethReserve);
            _mint(msg.sender, liquidity);
            return liquidity;
        }

    }

    function removeLiquidity(uint256 amount)
        public 
        returns(uint256, uint256)
    {
        uint256 ethAmount = address(this).balance * (amount/totalSupply());
        uint256 tokenAmount = getReserve() *(amount/totalSupply());

        _burn(msg.sender, amount);
        payable(msg.sender).transfer(ethAmount);
        IERC20(tokenAddress).transfer(msg.sender, tokenAmount);
        return(ethAmount, tokenAmount);
    }

    function getReserve()public view returns(uint256) {
        return IERC20(tokenAddress).balanceOf(address(this));
    }

    function getAmount(uint256 inputAmount, uint256 inputReserve, uint256 outputReserve)
        private 
        pure
        returns(uint256)
    {
        require(inputReserve >0 && outputReserve >0, "invalid reserve");
        // 收取1%的费用
        uint256 inputAmountWithFee = inputAmount * 99 ;
        uint256 numerator = inputAmountWithFee * outputReserve ;
        uint256 denominator = (inputReserve*100) + inputAmountWithFee;
        
        return numerator/denominator;
    }

    function getTokenAmount(uint256 _ethSold)
        public 
        view
        returns(uint256)
    {
        require(_ethSold>0, "eth sold is too small");

        uint256 tokenReserve = getReserve();
        
        return getAmount(_ethSold, address(this).balance, tokenReserve);
    }

    function getEthAmount(uint256 _tokenSold)
        public
        view
        returns(uint256)
    {
        require(_tokenSold > 0, "token sold is too small");

        uint256 tokenReserve = getReserve();

        return getAmount(_tokenSold, tokenReserve, address(this).balance);
    }
    
    function ethToTokenSwap(uint256 _minTokens) public payable{
        uint256 tokenReserve = getReserve();
        uint256 tokenBought = getAmount(
            msg.value, 
            address(this).balance,
            tokenReserve
        );

        require(tokenBought >= _minTokens, "unsufficient output amount");

        IERC20(tokenAddress).transfer(msg.sender, tokenBought);

    }
}