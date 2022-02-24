import Firebase

let COLLECTION_USERS = Firestore.firestore().collection("users")
let COLLECTION_FOLLOWERS = Firestore.firestore().collection("followers")
let COLLECTION_FOLLOWING = Firestore.firestore().collection("following")

let DEFAULT_URL = "https://lh3.googleusercontent.com/OIUpIvOXhqG8F-Wa948rxJcA8bg5lQGGaJ2yquegulYrD3nncituY5DcOi_wnpVumHU4qEBR-G-zBRNsQusbIgETVcTadt0r5arh32A"
