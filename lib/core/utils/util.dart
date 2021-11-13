String ipfsToHTTP(image) {
  return image.startsWith('ipfs') ? image.replaceAll("ipfs://", "https://ipfs.io/ipfs/"): image;
}