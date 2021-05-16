module main

import vweb
import json


struct App {
	vweb.Context
mut:
	users_list []User	
}

fn main() {
	vweb.run<App>(8081)
}

pub fn (mut app App) index() vweb.Result {	

	return app.text('Hello world from vweb!')
}

['/create'; post]
pub fn (mut app App) create_user() vweb.Result {

	user_from_json := json.decode(User, app.req.data) or { panic(err) }

	userobj := User{
		id: user_from_json.id
		name: user_from_json.name
		phone: user_from_json.phone
	}

	//x := json.encode(user1)
	app.users_list << userobj

	//users_map[user_from_json.id] = userobj

	msg_to_return := 'User created!'

	return app.json(msg_to_return)
}

['/users'; get]
pub fn (mut app App) get_users() vweb.Result{

	obj := 'Users: $app.users_list'

	return app.json(obj)

}

['/user/:user_id'; put]
pub fn (mut app App) update_user(user_id int) vweb.Result{

	user_from_json := json.decode(User, app.req.data) or { panic(err) }	
	
	for i := 0; i < app.users_list.len; i++ {

		if app.users_list[i].id == user_id{

			userobj := User{
			id: user_from_json.id
			name: user_from_json.name
			phone: user_from_json.phone
			}

			app.users_list[i] = userobj
			break

		}
	}

	msg_to_return := 'User updated!'
	
	return app.json(msg_to_return)

}

['/user/:user_id'; delete]
pub fn (mut app App) delete_user(user_id int) vweb.Result{
	//TODO
	msg_to_return := 'User deleted!'
	
	return app.json(msg_to_return)

}
