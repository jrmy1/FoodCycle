package main

import (
  "log"
  "io"
  "fmt"
  "net/http"
  "strings"
  "context"
  firebase "firebase.google.com/go"
  "google.golang.org/api/option"
)

func hello(w http.ResponseWriter, r *http.Request) {

  param1 := r.URL.Query().Get("value")
  if param1 == "" {
    param1 = "protein"
  }

  ctx := context.Background()

  sa := option.WithCredentialsFile("./ServiceAccountKey.json")
  app, err := firebase.NewApp(ctx, nil, sa)

  client, err := app.Firestore(ctx)
  if err != nil {
    log.Fatalln(err)
  }


  result, err := client.Collection("data").Doc("2019-03-03").Get(ctx)

  if (param1 == "meal") {

    meal := result.Data()[param1].(string)
    meal = strings.Split(meal, ",")[0]

    io.WriteString(w, meal)
  } else {
    io.WriteString(w, fmt.Sprint(result.Data()[param1].(int64)))
  }
  defer client.Close()
}

func main() {


  http.HandleFunc("/", hello)
  http.Handle("/nutrition-label-generator/", http.StripPrefix("/nutrition-label-generator/", http.FileServer(http.Dir("./nutrition-label-generator"))))
  http.ListenAndServe(":8424", nil)

}
