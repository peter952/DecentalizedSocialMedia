//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Alienmedia {
  string public name;
  uint public imageCount = 0;
  mapping(uint => Image) public images;

  struct Image {
    uint id;
    string hash;
    string description;
    string comment;
    uint tipAmount;
    address payable author;
  }

  event ImageCreated(
    uint id,
    string hash,
    string description,
    uint tipAmount,
    address payable author
  );

  event ImageTipped(
    uint id,
    string hash,
    string description,
    string comment,
    uint tipAmount,
    address payable author
  );

  constructor() {
    name = "Alienmedia";
  }

  function uploadImage(string memory _imgHash, string memory _description) public {
    // Make sure the image hash exists
    require(bytes(_imgHash).length > 0);
    // Make sure image description exists
    require(bytes(_description).length > 0);
    // Make sure uploader address exists
    require(msg.sender!=address(0));

    // Increment image id
    imageCount ++;

    // Add Image to the contract
    images[imageCount] = Image(imageCount, _imgHash, _description, "",  0, payable(msg.sender));
    // Trigger an event
    emit ImageCreated(imageCount, _imgHash, _description, 0, payable(msg.sender));
  }

  function tipImageOwner(uint _id, string memory _comment) public payable {
    // Make sure the id is valid
    require(_id > 0 && _id <= imageCount);
    // Fetch the image
    Image memory _image = images[_id];
    // Fetch the author
    address payable _author = _image.author;
    // Pay the author by sending them Ether
    payable(address (_author)).transfer(msg.value);

    require(bytes(_comment).length > 0);
    // Increment the tip amount
    _image.tipAmount = _image.tipAmount + msg.value;
    // Update the image
    images[_id] = _image;
    // Trigger an event
    emit ImageTipped(_id, _image.hash, _image.description, _image.comment, _image.tipAmount, _author);
  }
}
