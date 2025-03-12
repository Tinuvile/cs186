## Project Structure Diagram
## 项目结构图
![img.png](../image/img.png)

## Task1:`LeafNode::fromBytes`
> You should first implement the `fromBytes` in `LeafNode`. This method reads 
a `LeafNode` from a page. For information on how a leaf node is serialized, 
see `LeafNode::toBytes`. For an example on how to read a node from disk, 
see `InnerNode::fromBytes`. Your code should be similar to the inner node 
version but should account for the differences between how inner nodes 
and leaf nodes are serialized. You may find the documentation in
[`ByteBuffer.java`]() helpful.
你应该首先在 LeafNode 中实现 fromBytes 。该方法从页面读取 LeafNode 。有关叶节点如何序列化的信息，请参阅 LeafNode::toBytes 。有关如何从磁盘读取节点的示例，请参阅 InnerNode::fromBytes 。你的代码应该类似于内部节点版本，但应考虑内部节点和叶节点序列化方式之间的差异。你可能会发现 ByteBuffer.java 中的文档很有帮助。

Once you have implemented fromBytes you should be passing TestLeafNode::testToAndFromBytes.