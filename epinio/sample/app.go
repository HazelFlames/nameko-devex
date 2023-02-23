package main

import (
	"database/sql"
	"fmt"
	"log"

	"github.com/gofiber/fiber/v2"
)

type todo struct {
	Item string
}

func indexHandler(c *fiber.Ctx, d *sql.DB) error {
	var res string
	var todos []string
	rows, err := d.Query("SELECT * FROM todos")
	if err != nil {
		log.Fatalln(err)
		c.JSON("An error occured")
	}
	defer rows.Close()
	for rows.Next() {
		rows.Scan(&res)
		todos = append(todos, res)
	}
	return c.Render("index", fiber.Map{
		"Todos": todos,
	})
}

func postHandler(c *fiber.Ctx, d *sql.DB) error {
	newTodo := todo{}
	if err := c.BodyParser(&newTodo); err != nil {
		log.Printf("An error occured: %v", err)
		return c.SendString(err.Error())
	}
	fmt.Printf("%v", newTodo)
	if newTodo.Item != "" {
		_, err := d.Exec("INSERT into todos VALUES ($1)", newTodo.Item)
		if err != nil {
			log.Fatalf("An error occured while executing query: %v", err)
		}
	}

	return c.Redirect("/")
}

func putHandler(c *fiber.Ctx, d *sql.DB) error {
	olditem := c.Query("olditem")
	newitem := c.Query("newitem")
	d.Exec("UPDATE todos SET item=$1 WHERE item=$2", newitem, olditem)
	return c.Redirect("/")
}

func deleteHandler(c *fiber.Ctx, d *sql.DB) error {
	todoToDelete := c.Query("item")
	d.Exec("DELETE from todos WHERE item=$1", todoToDelete)
	return c.SendString("deleted")
}
