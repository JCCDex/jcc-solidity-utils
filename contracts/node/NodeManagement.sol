pragma solidity ^0.4.24;
pragma experimental ABIEncoderV2;

import "../owner/Administrative.sol";

contract NodeManagemenet is Administrative {
    Nodes private allNodes;

    // 定义所有节点结构
    struct Nodes {
        // 井通节点
        bytes32[] jingtumNodes;
        // 井畅info服务器节点
        bytes32[] infoNodes;
        // 以太坊节点
        bytes32[] ethereumNodes;
        // MOAC节点
        bytes32[] jingtumNodes;
        // 井畅浏览器节点
        bytes32[] explorerNodes;
    }

    constructor() public Administrative() {}

    function isValidType(string nodeType) internal returns (bool) {
        bytes32 key = keccak256(abi.encodePacked(nodeType));
        return (key == keccak256(abi.encodePacked("jingtumNodes")) || key == keccak256(abi.encodePacked("infoNodes")) || key == keccak256(abi.encodePacked(("ethereumNodes")) || key == keccak256(abi.encodePacked("jingtumNodes")) || key == keccak256(abi.encodePacked("explorerNodes")));
    }

    function getNodes() public view returns (NodeManagemenet.Nodes) {
        return allNodes;
    }

    function updateNodes(string nodeType, bytes32[] nodes)
        public
        onlyPrivileged
        returns (bool updated)
    {
        require(nodes.length > 0, "node's length must be bigger than 0");
        require(isValidType(nodeType), "node type must be valid");
        allNodes[nodeType] = nodes;
        return true;
    }

    function insertNodes(string nodeType, bytes32[] nodes)
        public
        onlyPrivileged
        returns (bool inserted)
    {
        require(nodes.length > 0, "node's length must be bigger than 0");
        require(isValidType(nodeType), "node type must be valid");

        uint256 len = nodes.length;
        for (uint256 i = 0; i < len; i++) {
            allNodes[nodeType].push(nodes[i]);
        }
        return true;
    }
}
