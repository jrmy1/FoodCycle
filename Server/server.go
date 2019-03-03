package main

import (
  "log"
  "io"
//  "fmt"
  "net/http"
  "context"
  firebase "firebase.google.com/go"
  "google.golang.org/api/option"
)

func hello(w http.ResponseWriter, r *http.Request) {

  ctx := context.Background()

  sa := option.WithCredentialsFile("./ServiceAccountKey.json")
  app, err := firebase.NewApp(ctx, nil, sa)

  client, err := app.Firestore(ctx)
  if err != nil {
    log.Fatalln(err)
  }


  result, err := client.Collection("data").Doc("2019-03-03").Get(ctx)

  io.WriteString(w, result.Data()["calories"].(string))
  defer client.Close()
}

func main() {


  http.HandleFunc("/", hello)
  http.ListenAndServe(":8424", nil)

}
