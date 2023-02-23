package main

import (
	"context"
	"database/sql"
	"fmt"
	"log"

	_ "github.com/lib/pq"
)

type Connection struct {
	DbName     string
	DbHost     string
	DbPassword string
	DbPort     int
	DbUser     string
}

type Database struct {
	DB *sql.DB
}

func (d *Database) Initialize(connectionString string) error {
	var err error
	d.DB, err = sql.Open("postgres", connectionString)
	CheckError(err)

	return d.DB.Ping()
}

func createDB() error {
	log.Println("Setting up connection to create the database...")

	connectionStringForCreation := fmt.Sprintf("host=%s port=%d user=%s password=%s sslmode=disable", connectionParams.DbHost, connectionParams.DbPort, connectionParams.DbUser, connectionParams.DbPassword)

	ctx := context.TODO()
	dc := Database{}
	err := dc.Initialize(connectionStringForCreation)
	CheckError(err)
	defer dc.DB.Close()

	log.Println("Creating the database...")

	_, err = dc.DB.ExecContext(ctx, "CREATE DATABASE "+connectionParams.DbName)
	if err != nil {
		log.Println("Attempt to create the database failed!\nAborting...")
		log.Fatalln(err)
	}

	return dc.DB.Ping()
}

func ensureTableExists(d Database) {
	err := d.DB.Ping()
	CheckError(err)

	log.Println("Checking existance of appropriate table...")

	_, err = d.DB.Exec("CREATE TABLE IF NOT EXISTS todos (item TEXT)")
	CheckError(err)

	log.Println("Correct table exists.")
}
