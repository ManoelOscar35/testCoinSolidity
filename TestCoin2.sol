//código antigo
pragma solidity >=0.8.0;

library SafeMath {
    function add(uint a, uint b) internal pure returns(uint) {
        uint c = a + b;
        require(c >= a);

        return c;
    }

    function sub(uint a, uint b) internal pure returns(uint) {
        require(b <= a);
        uint c = a - b;

        return c;
    }

    function mul(uint a, uint b) internal pure returns(uint) {
        if(a == 0) {
            return 0;
        }

        uint c = a * b;
        require(c / a == b);

        return c;
    }

    function div(uint a, uint b) internal pure returns(uint) {
        uint c = a / b;

        return c;
    }
}

contract Ownable {
    address payable public owner;
    
    event OwnershipTransferred(address newOwner);

    constructor() public {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    function transferOwnership(address payable newOwner) onlyOwner public  {
        require(newOwner != address(0));

        owner = newOwner;
        emit OwnershipTransferred(owner);
    }
}

abstract contract ERC20 {
    function totalSupply() virtual public view returns (uint);
    function balanceOf(address tokenOwner) virtual public view returns (uint balance);
    function allowance(address tokenOwner, address spender) virtual public view returns (uint remaining);
    function transfer(address to, uint tokens) virtual public returns (bool success);
    function approve(address spender, uint tokens) virtual public returns (bool success);
    function transferFrom(address from, address to, uint tokens) virtual public returns (bool success);

    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}

contract BasicToken is Ownable, ERC20 {
    using SafeMath for uint;
    uint internal _totalSupply;
    mapping(address => uint) internal _balances;
    mapping(address => mapping(address => uint)) internal _allowed;

    function totalSupply() override public view returns (uint) {
        return _totalSupply;
    }

    function balanceOf(address tokenOwner) override public view returns (uint balance) {
        return _balances[tokenOwner];
    }

    function transfer(address to, uint tokens) override public returns (bool success) {
        require(_balances[msg.sender] >= tokens);
        require(to != address(0));

        _balances[msg.sender] = _balances[msg.sender].sub(tokens);
        _balances[to] = _balances[to].add(tokens);

        emit Transfer(msg.sender, to, tokens);

        return true;
    }

    function approve(address spender, uint tokens) override public returns (bool success) {
        _allowed[msg.sender][spender] = tokens;

        emit Approval(msg.sender, spender, tokens);

        return true;
    }

    function allowance(address tokenOwner, address spender) override public view returns (uint remaining) {
        return _allowed[tokenOwner][spender];
    }

    function  transferFrom(address from, address to, uint tokens) override public returns (bool success) {
        require(_allowed[from][msg.sender] >= tokens);
        require(_balances[from] >= tokens);
        require(to != address(0));

        _balances[from] = _balances[from].sub(tokens);
        _balances[to] = _balances[to].add(tokens);
        _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(tokens);

        emit Transfer(from, to, tokens);

        return true;
    }
}

contract MintableToken is BasicToken {
    
    event Mint(address indexed to, uint tokens);

    function mint(address to, uint tokens) onlyOwner public {
        _balances[to] = _balances[to].add(tokens);
        _totalSupply = _totalSupply.add(tokens);

        emit Mint(to, tokens);
    }
  
}

contract TestCoin is MintableToken {
    string public constant name = "Test Coin";
    string public constant symbol = "TST";
    uint8 public constant decimals = 18;
}

contract OscarCoin is MintableToken {
    string public constant name = "Oscar Coin";
    string public constant symbol = "OCC";
    uint8 public constant decimals = 18;
}

// Código novo refatorado pelo chatgpt//

pragma solidity >=0.8.0;

library SafeMath {
    function add(uint a, uint b) internal pure returns (uint) {
        uint c = a + b;
        require(c >= a, "SafeMath: addition overflow");
        return c;
    }

    function sub(uint a, uint b) internal pure returns (uint) {
        require(b <= a, "SafeMath: subtraction overflow");
        uint c = a - b;
        return c;
    }

    function mul(uint a, uint b) internal pure returns (uint) {
        if (a == 0) {
            return 0;
        }
        uint c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");
        return c;
    }

    function div(uint a, uint b) internal pure returns (uint) {
        require(b > 0, "SafeMath: division by zero");
        uint c = a / b;
        return c;
    }
}

contract Ownable {
    address payable public owner;
    
    event OwnershipTransferred(address newOwner);

    constructor() {
        owner = payable(msg.sender);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Ownable: caller is not the owner");
        _;
    }

    function transferOwnership(address payable newOwner) onlyOwner public {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        owner = newOwner;
        emit OwnershipTransferred(owner);
    }
}

abstract contract ERC20 {
    function totalSupply() virtual public view returns (uint);
    function balanceOf(address tokenOwner) virtual public view returns (uint balance);
    function allowance(address tokenOwner, address spender) virtual public view returns (uint remaining);
    function transfer(address to, uint tokens) virtual public returns (bool success);
    function approve(address spender, uint tokens) virtual public returns (bool success);
    function transferFrom(address from, address to, uint tokens) virtual public returns (bool success);

    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}

contract BasicToken is Ownable, ERC20 {
    using SafeMath for uint;
    uint internal _totalSupply;
    mapping(address => uint) internal _balances;
    mapping(address => mapping(address => uint)) internal _allowed;

    function totalSupply() override public view returns (uint) {
        return _totalSupply;
    }

    function balanceOf(address tokenOwner) override public view returns (uint balance) {
        return _balances[tokenOwner];
    }

    function transfer(address to, uint tokens) override public returns (bool success) {
        require(_balances[msg.sender] >= tokens, "BasicToken: insufficient balance");
        require(to != address(0), "BasicToken: transfer to the zero address");

        _balances[msg.sender] = _balances[msg.sender].sub(tokens);
        _balances[to] = _balances[to].add(tokens);

        emit Transfer(msg.sender, to, tokens);
        return true;
    }

    function approve(address spender, uint tokens) override public returns (bool success) {
        _allowed[msg.sender][spender] = tokens;
        emit Approval(msg.sender, spender, tokens);
        return true;
    }

    function allowance(address tokenOwner, address spender) override public view returns (uint remaining) {
        return _allowed[tokenOwner][spender];
    }

    function transferFrom(address from, address to, uint tokens) override public returns (bool success) {
        require(_allowed[from][msg.sender] >= tokens, "BasicToken: transfer amount exceeds allowance");
        require(_balances[from] >= tokens, "BasicToken: insufficient balance");
        require(to != address(0), "BasicToken: transfer to the zero address");

        _balances[from] = _balances[from].sub(tokens);
        _balances[to] = _balances[to].add(tokens);
        _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(tokens);

        emit Transfer(from, to, tokens);
        return true;
    }
}

contract MintableToken is BasicToken {
    event Mint(address indexed to, uint tokens);

    function mint(address to, uint tokens) onlyOwner public {
        require(to != address(0), "MintableToken: mint to the zero address");
        _balances[to] = _balances[to] + tokens;
        _totalSupply = _totalSupply + tokens;

        emit Mint(to, tokens);
        emit Transfer(address(0), to, tokens); // Emit Transfer event from zero address
    }
}

contract TestCoin is MintableToken {
    string public constant name = "Test Coin";
    string public constant symbol = "TST";
    uint8 public constant decimals = 18;
}

contract OscarCoin is MintableToken {
    string public constant name = "Oscar Coin";
    string public constant symbol = "OCC";
    uint8 public constant decimals = 18;
}