import 'package:flutter/material.dart';

void main() => runApp(OrderApp());

class OrderApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Order App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isAdmin = false;

  void login() {
    // Perform authentication logic here
    // You can customize this logic based on your authentication requirements
    String username = usernameController.text;
    String password = passwordController.text;

    // Check if the login credentials are valid (dummy check for demonstration)
    if (username == 'admin' && password == 'admin') {
      setState(() {
        isAdmin = true;
      });
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => OrderScreen(isAdmin: isAdmin)),
      );
    } else {
      setState(() {
        isAdmin = false;
      });
      // Show an error message or perform appropriate actions for invalid credentials
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: login,
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}

class OrderScreen extends StatefulWidget {
  final bool isAdmin;

  OrderScreen({required this.isAdmin});

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  List<String> items = ['Item 1', 'Item 2', 'Item 3'];
  List<String> selectedItems = [];
  TextEditingController itemNameController = TextEditingController();

  void addToCart(String item) {
    setState(() {
      selectedItems.add(item);
    });
    // Send notification to admin about the selected item
    notifyAdmin(item);
  }

  void notifyAdmin(String item) {
    // Send notification to the admin (e.g., via email, push notification)
    // Include the item details and payment information
    // Replace this with your specific notification implementation
    print('Admin notification: Item "$item" added to cart.');
  }

  void confirmOrder() {
    // Logic to confirm the order by the admin
    // Perform any necessary payment processing
    // Replace this with your specific order confirmation implementation
    print('Order confirmed by admin.');
  }

  void addItem() {
    setState(() {
      items.add(itemNameController.text);
      itemNameController.clear();
    });
  }

  void removeItem(int index) {
    setState(() {
      items.removeAt(index);
    });
  }

  void renameItem(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String newName = '';
        return AlertDialog(
          title: Text('Rename Item'),
          content: TextField(
            onChanged: (value) {
              newName = value;
            },
            decoration: InputDecoration(labelText: 'New Name'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  items[index] = newName;
                });
                Navigator.pop(context);
              },
              child: Text('Rename'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Screen'),
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(items[index]),
            trailing: widget.isAdmin
                ? IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      renameItem(index);
                    },
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () {
                          setState(() {
                            selectedItems.remove(items[index]);
                          });
                        },
                      ),
                      Text(selectedItems.where((item) => item == items[index]).length.toString()),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          addToCart(items[index]);
                        },
                      ),
                    ],
                  ),
            onTap: () {
              // Handle item selection or any other actions
            },
          );
        },
      ),
      floatingActionButton: widget.isAdmin
          ? FloatingActionButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Add Item'),
                      content: TextField(
                        controller: itemNameController,
                        decoration: InputDecoration(labelText: 'Item Name'),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            addItem();
                            Navigator.pop(context);
                          },
                          child: Text('Add'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Icon(Icons.add),
            )
          : null,
    );
  }
}
