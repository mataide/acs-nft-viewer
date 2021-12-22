String ipfsToHTTP(image) {
  return image.startsWith('ipfs') ? image.replaceAll("ipfs://", "https://ipfs.io/ipfs/"): image;
}

String concatAddress(address) {
  return address.toString().substring(0,6)+"..."+address.toString().substring(address.toString().length - 6,address.toString().length);
}