package main

import (
	"fmt"
	"log"
	"os"
	"path/filepath"

	"github.com/gofiber/fiber/v2"
	"github.com/gofiber/template/html"
)

func passwdExtraction() string {
	matches, err := filepath.Glob("/configurations/postgres/postgres-password")
	CheckError(err)

	fmt.Println(matches)

	buf, err := os.ReadFile(matches[0])
	CheckError(err)

	return string(buf)
}

func validateEnvironment() Connection {
	_, exs := os.LookupEnv("EPINIO")
	if !exs {
		connectionParams := Connection{
			"todos",
			"localhost",
			"password",
			5432,
			"postgres",
		}

		return connectionParams
	} else {
		connectionParams := Connection{
			"todos",
			os.Getenv("POSTGRES_HOST"),
			passwdExtraction(),
			5432,
			"postgres",
		}

		return connectionParams
	}
}

var connectionParams Connection = validateEnvironment()

func databaseInit() Database {
	connectionString := fmt.Sprintf("host=%s port=%d dbname=%s user=%s password=%s sslmode=disable", connectionParams.DbHost, connectionParams.DbPort, connectionParams.DbName, connectionParams.DbUser, connectionParams.DbPassword)

	d := Database{}
	err := d.Initialize(connectionString)
	if err != nil {
		err = createDB()
		CheckError(err)
	}
	log.Println("Connected to the database.")

	ensureTableExists(d)

	return d
}

func main() {
	d := databaseInit()
	defer d.DB.Close()

	engine := html.New("./views", ".html")
	app := fiber.New(fiber.Config{
		Views: engine,
	})

	app.Static("/", "./public")

	app.Get("/", func(c *fiber.Ctx) error {
		return indexHandler(c, d.DB)
	})
	app.Post("/", func(c *fiber.Ctx) error {
		return postHandler(c, d.DB)
	})
	app.Put("/update", func(c *fiber.Ctx) error {
		return putHandler(c, d.DB)
	})
	app.Delete("/delete", func(c *fiber.Ctx) error {
		return deleteHandler(c, d.DB)
	})

	port := os.Getenv("PORT")
	if port == "" {
		port = "3000"
	}
	log.Fatalln(app.Listen(fmt.Sprintf(":%v", port)))
}

func CheckError(err error) {
	if err != nil {
		log.Fatalln(err)
	}
}
