importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-app.js");
importScripts(
  "https://www.gstatic.com/firebasejs/8.10.0/firebase-messaging.js"
);

firebase.initializeApp({
  apiKey: "AIzaSyBCQ_NwaciOO2WayStxCBe56EaWWghrHcE",
  authDomain: "keen-tokenizer-400311.firebaseapp.com",
  databaseURL: "",
  projectId: "keen-tokenizer-400311",
  storageBucket: "keen-tokenizer-400311.appspot.com",
  messagingSenderId: "912983858748",
  appId: "1:912983858748:web:b3d99cee33f947f30bad39",
});

const messaging = firebase.messaging();
