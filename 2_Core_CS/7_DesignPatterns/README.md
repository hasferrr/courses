# Design Pattern (Code)

## CREATIONAL PATTERN

### Singleton

If a class has a public constructor, an object of this class can be instantiated at any time.

```java
public class notSingleton {
// Public Constructor
    public notSingleton() {
        // code
    }
}
```

Private constructor

```java
public class ExampleSingleton {
    // lazy construction
    // the class variable is null if no instance is
    // instantiated
    private static ExampleSingleton uniqueInstance = null;


    private ExampleSingleton() {
        // ...
    }


    // lazy construction of the instance
    public static ExampleSingleton getInstance() {
        if (uniqueInstance == null) {
            uniqueInstance = new ExampleSingleton();
        }
        return uniqueInstance;
    }

    // ...
}
```

In real use, there may be variations of how Singleton is realized because design patterns are defined by purpose and not exact code.

### Factory Design Pattern

#### Factory Object

```java
public class KnifeFactory {

    public Knife createKnife(String knifeType) {
        Knife knife = null;

        // create Knife object
        if (knifeType.equals("steak")) {
            knife = new SteakKnife();
        } else if (knifeType.equals("chefs")) {
            knife = new ChefsKnife();
        }
        return knife;
    }
}

public class KnifeStore {
    private KnifeFactory factory;

    // require a KnifeFactory object to be passed
    // to this constructor:
    public KnifeStore(KnifeFactory factory) {
        this.factory = factory;
    }

    public Knife orderKnife(String knifeType) {
        Knife knife;

        //use the create method in the factory
        knife = factory.createKnife(knifeType);

        //prepare the Knife
        knife.sharpen();
        knife.polish();
        knife.package();

        return knife;
    }
}
```

#### Factory Method Pattern

```java
public abstract class KnifeStore {

    // The orderKnife method uses a Factory,
    // but it is a factory method, createKnife().
    public Knife orderKnife(String knifeType) {
        Knife knife;

        // now creating a knife is a method in the class
        knife = createKnife(knifeType);

        knife.sharpen();
        knife.polish();
        knife.package();

        return knife;
    }

    abstract Knife createKnife(String type);
}

// subclasses such as BudgetKnifeStore
// inherit the orderKnife method

public BudgetKnifeStore extends KnifeStore {

    //up to any subclass of KnifeStore to define this method
    Knife createKnife(String knifeTYpe) {

        if (knifeType.equals("steak")) {
            return new BudgetSteakKnife();
        }
        else if (knifeType.equals("chefs")) {
            return new BudgetChefsKnife();
        }

        //.. more types
        else return null;
    }
}

```

## STRUCTURAL PATTERN

### Facade pattern

A facade is a wrapper class that encapsulates a subsystem in order to hide the subsystem’s complexity

```java
public interface IAccount {
    public void deposit(BigDecimal amount);
    public void withdraw(BigDecimal amount);
    public void transfer(BigDecimal amount);
    public int getAccountNumber();
}



public class Chequing implements IAccount { ... }
public class Saving implements IAccount { ... }
public class Investment implements IAccount { ... }



public class BankService {
    private Hashtable<int, IAccount> bankAccounts;

    public BankService() {
        this.bankAccounts = new Hashtable<int, IAccount>
    }

    public int createNewAccount(String type, BigDecimal initAmount) {
        IAccount newAccount = null;

        switch (type) {
        case "chequing":
            newAccount = new Chequing(initAmount);
            break;
        case "saving":
            newAccount = new Saving(initAmount);
            break;
        case "investment":
            newAccount = new Investment(initAmount);
            break;
        default:
            System.out.println("Invalid account type");
            break;
        }

        if (newAccount != null) {
            this.bankAccounts.put(newAccount.getAccountNumber(), newAccount);
            return newAccount.getAccountNumber();
        }

        return -1;
    }

    public void transferMoney(int to, int from, BigDecimal amount) {
        IAccount toAccount   = this.bankAccounts.get(to);
        IAccount fromAccount = this.bankAccounts.get(from);

        fromAccount.transfer(toAccount, amount);
    }
}



public class Customer {
    public static void main(String args[]) {
        BankService myBankService = new BankService();

        int mySaving     = myBankService.createNewAccount("saving",     new BigDecimal(500.00));
        int myInvestment = myBankService.createNewAccount("investment", new BigDecimal(1000.00));

        myBankService.transferMoney(mySaving, myInvestment, new BigDecimal(300.00));
    }
}
```

### Adapter pattern

The adapter design pattern facilitates communication between two existing systems by providing a compatible interface

```java
public interface WebRequester {
    public int request(Object);
}



public class WebAdapter implements WebRequester {
    private WebService service;

    public void connect(WebService currentService) {
        this.service = currentService;
        /* Connect to the web service */
    }

    public int request(Object request) {
        Json result = this.toJson(request);
        Json response = service.request(result);

        if (response != null) {
            return 200; // OK status code
        }
        return 500; // Server error status code
    }

    private Json toJson(Object input) { ... }
}



public class WebClient {
    private WebRequester webRequester;

    public WebClient(WebRequester webRequester) {
        this.webRequester = webRequester;
    }

    private Object makeObject() { ... } // Make an Object

    public void doWork() {
        Object object = makeObject();
        int status = webRequester.request(object);

        if (status == 200) {
            System.out.println("OK");
        }
        else {
            System.out.println("Not OK");
        }

        return;
    }
}



public class Program {
    public static void main(String args[]) {
        String webHost = "Host: https://google.com\n\r";
        WebService service = new WebService(webHost);
        WebAdapter adapter = new WebAdapter();
        adapter.connect(service);
        WebClient client = new WebClient(adapter);
        client.doWork();
    }
}
```

### Composite pattern

```java
public interface IStructure {
    public void enter();
    public void exit();
    public void location();
    public String getName();
}


// composite class
public class Housing implements IStructure {
    private ArrayList <IStructure> structures;
    private String address;

    public Housing(String address) {
        this.structures = new ArrayList <IStructure> ();
        this.address = address;
    }

    public int addStructure(IStructure component) {
        this.structures.add(component);
        return this.structures.size() - 1;
    }

    public IStructure getStructure(int componentNumber) {
        return this.structures.get(componentNumber);
    }


    public String getName() {
        return this.address;
    }
    public void location() {
        System.out.println("You are currently in " + this.getName() + ". It has ");
        for (IStructure struct: this.structures)
            System.out.println(struct.getName());
    }
    public void enter() {
        System.out.println("You have entered the " + this.getName());
    }
    public void exit() {
        System.out.println("You have left the " + this.getName());
    }

}


// leaf class
public class Room implements IStructure {
    public String name;

    public Room(String name) {
        this.name = name;
    }
    public void enter() {
        System.out.println("You have entered the " + this.getName());
    }
    public void exit() {
        System.out.println("You have left the " + this.getName());
    }
    public void location() {
        System.out.println("You are currently in the" + this.getName());
    }
    public String getName() {
        return this.name;
    }
}



public class Main {
    public static void main(String[] args) {
        Housing building = new Housing("123 Street"); // composite
        Housing floor1   = new Housing("123 Street - First Floor"); // composite

        int firstFloor = building.addStructure(floor1);

        // ArrayList <IStructure> structures in building now contains:
        // [Housing floor1]

        Room washroom1m = new Room("1F Men's Washroom"); // leaf
        Room washroom1w = new Room("1F Women's Washroom");
        Room common1    = new Room("1F Common Area");

        int firstMens   = floor1.addStructure(washroom1m);
        int firstWomans = floor1.addStructure(washroom1w);
        int firstCommon = floor1.addStructure(common1);

        // ArrayList <IStructure> structures in foor1 now contains:
        // [Room washroom1m, Room washroom1w, Room common1]

        building.enter();

        Housing currentFloor = (Housing) building.getStructure(firstFloor); // go to floor1
        currentFloor.enter(); // Walk into the first floor

        Room currentRoom = (Room) currentFloor.getStructure(firstMens); // go to washroom1w, and cast the type into (Room)
        currentRoom.enter(); // Walk into the men's room

        currentRoom = (Room) currentFloor.getStructure(firstCommon);
        currentRoom.enter(); // Walk into the common area

        building.exit();
    }
}

```

### Proxy pattern

```java
public interface IOrder {
    public void fulfillOrder(Order);
}


public class Warehouse implements IOrder {
    private Hashtable<String, Integer> stock;
    private String address;

    /* Constructors and other attributes would go here */
    ...

    public void fulfillOrder(Order order) {
        for (Item item : order.itemList)
            this.stock.replace(item.sku, stock.get(item)-1);

        /* Process the order for shipment and delivery */
        ...
    }

    public int currentInventory(Item item) {
        if (stock.containsKey(item.sku))
            return stock.get(item.sku).intValue();
        return 0;
    }
}



public class OrderFulfillment implements IOrder {
    private List<Warehouse> warehouses;

    /* Constructors and other attributes would go here */
    public void fulfillOrder(Order order) {
        /*
        - For each item in a customer order, check each
          warehouse to see if it is in stock.
        - If it is then create a new Order for that warehouse.
          Else check the next warehouse.
        - Send all the Orders to the warehouse(s) after you finish
          iterating over all the items in the original Order.
        */
        for (Item item: order.itemList) {
            for (Warehouse warehouse: warehouses) {
                ...
            }
        }
        return;
    }
}
```

### Decorator pattern

```java
public interface WebPage {
    public void display();
}



public class BasicWebPage implements WebPage {
    public String html = ...;
    public String styleSheet = ...;
    public String script = ...;
    public void display() {
    /* Renders the HTML to the stylesheet, and run any embedded
    scripts */
}



public abstract class WebPageDecorator implements WebPage {
    protected WebPage page;

    public WebPageDecorator(WebPage webpage) {
        this.page = webpage;
    }

    public void display() {
        this.page.display();
    }
}



public class AuthorizedWebPage extends WebPageDecorator {

    public AuthorizedWebPage(WebPage decoratedPage) {
        super(decoratedPage);
    }
    public void authorizedUser() {
        System.out.println("Authorizing user");
    }
    public display() {
        super.display();
        this.authorizedUser();
    }
}

public class AuthenticatedWebPage extends WebPageDecorator {

    public AuthenticatedWebPage(WebPage decoratedPage) {
        super(decoratedPage);
    }
    public void authenticateUser() {
        System.out.println("Authenticating user");
    }
    public display() {
        super.display();
        this.authenticateUser();
    }
}
```

main program

```java
public class Program {
    public static void main(String args[]) {
        WebPage myPage = new BasicWebPage();
        myPage = new AuthorizedWebPage(myPage);
        myPage = new AuthenticatedWebPage(myPage);
        myPage.display();
    }
}
```

## BEHAVIOURAL PATTERN

### Template Method Pattern

The template method pattern defines an algorithm’s steps generally, by deferring the implementation of some steps to subclasses. In other words, it is concerned with the assignment of responsibilities.

```java
public abstract class PastaDish { //abstract class
    final void makeRecipe() { //template method
        boilWater();
        addPasta();
        cookPasta();
        drainAndPlate();
        addSauce();
        addProtein();
        addGarnish();
    }
    abstract void addPasta();
    abstract void addSauce();
    abstract void addProtein();
    abstract void addGarnish();
    private void boilWater() {
        System.out.println("Boiling water");
    }
    ...
}
```

```java
public class SpaghettiMeatballs extends PastaDish {
    public void addPasta() {
        System.out.println("Add spaghetti");
    }
    public void addProtein() {
        System.out.println("Add meatballs");
    }
    public void addSauce() {
        System.out.println("Add tomato sauce");
    }
    public void addGarnish() {
        System.out.println("Add Parmesan cheese");
    }
}
```

```java
public class PenneAlfredo extends PastaDish {
    public void addPasta() {
        System.out.println("Add penne");
    }
    public void addProtein() {
        System.out.println("Add chicken");
    }
    public void addSauce() {
        System.out.println("Add Alfredo sauce");
    }
    public void addGarnish() {
        System.out.println("Add parsley");
    }
}
```

### Chain of Responsibility Pattern

- A chain of objects that are responsible for handling requests.
- The first handler in the chain will try to process it.
- If the handler can process the request, then the request ends with this handler.
- However, if the handler cannot handle the request, then the request is sent to the next handler in the chain.
- This pattern is similar to exception handling in Java (a series of try/catch blocks)

```java
Operation_A() {
    try {
        Operation_B()
    }
    catch (Exception e1) {
        // try this
    }
}

Operation_B() {
    try {
        Operation_C()
    }
    catch (Exception e1) {
        // try this
    }
}

Operation_C() {
    try {
        // throw exception
    }
    catch (Exception e1) {
        // try this
    }
}
```

Each filter needs to go through the following steps:

1. Check if the rule matches.
2. If it matches, do something specific.
3. If it doesn’t match, call the next filter in the list.

### State Pattern

- Objects in your code are aware of their current state.
- They can choose an appropriate behavior based on their current state.
- When their current state changes, this behavior can be altered - this is the state design pattern.

Let us examine the state *interface* as code. State classes must implement the methods in this interface to respond to each trigger.

```java
public interface State {
    public void insertDollar( VendingMachine vendingMachine );
    public void ejectMoney( VendingMachine vendingMachine );
    public void dispense( VendingMachine vendingMachine );
}
```

Now, let us examine the *for each State* class:

```java
public class IdleState implements State {
    public void insertDollar( VendingMachine vendingMachine ) {
        System.out.println( "dollar inserted" );
        vendingMachine.setState(
            vendingMachine.getHasOneDollarState()
        );
    }
    public void ejectMoney( VendingMachine vendingMachine ) {
        System.out.println( "no money to return" );
    }
    public void dispense( VendingMachine vendingMachine ) {
        System.out.println( "payment required" );
    }
}
```

```java
public class HasOneDollarState implements State {
    public void insertDollar( VendingMachine vendingMachine ) {
        System.out.println( "already have one dollar" );
    }
    public void ejectMoney( VendingMachine vendingMachine ) {
        System.out.println( "returning money" );
        vendingMachine.doReturnMoney();
        vendingMachine.setState(
            vendingMachine.getIdleState()
        );
    }
    public void dispense( VendingMachine vendingMachine ) {
        System.out.println( "releasing product" );
        if (vendingMachine.getCount() > 1) {
            vendingMachine.doReleaseProduct();
            vendingMachine.setState(
                vendingMachine.getIdleState());
        } else {
            vendingMachine.doReleaseProduct();
            vendingMachine.setState(
                vendingMachine.getOutOfStockState());
        }
    }
}
```

```java
public class OutOfStockState implements State {
    public void insertDollar( VendingMachine vendingMachine ) { ... }
    public void ejectMoney( VendingMachine vendingMachine ) { ... }
    public void dispense( VendingMachine vendingMachine ) { ... }
}
```

```java
public class PopMachine {
    private State idleState;
    private State hasOneDollarState;
    private State outOfStockState;
    private State currentState;
    private int count;

    public PopMachine( int count ) {

        // make the needed states
        idleState = new IdleState();
        hasOneDollarState = new HasOneDollarState();
        outOfStockState = new OutOfStockState();

        if (count > 0) {
            currentState = idleState;
            this.count = count;
        } else {
            currentState = outOfStockState;
            this.count = 0;
        }
    }
}
```

### Command Pattern

In general, when an object makes a request for a second object to do an action, the first object would call a method of the second object and the second object would complete the task. There is direct communication between the sender and receiver object.

The *command pattern* creates a command object *between* the sender and receiver.

This way, the sender does not have to know about the receiver and the methods to call.

In a command pattern, a sender object can create a command object.

### Mediator Pattern

[Mediator-Pattern](Mediator-Pattern.pdf)

### Observer Pattern

The **observer design pattern** is a pattern where a **subject** keeps a list of **observers**.

Observers rely on the subject to inform them of changes to the state of the subject.

- There is generally a **Subject superclass**, which would have an attribute to keep track of all the observers
- There is also an **Observer interface** with a method, so that an observer can be notified of state changes to the subject
- The *Subject superclass* may also have **subclasses** that implement the *Observer interface*.
- These elements create the **relationship** between the subject and observer.

```java
public class Subject {
    private ArrayList<Observer> observers = new ArrayList<Observer>();

    public void registerObserver(Observer observer) {
        observers.add(observer);
    }
    public void unregisterObserver(Observer observer) {
        observers.remove(observer);
    }
    public void notify() {
        for (Observer o : observers) {
            o.update();
        }
    }
}
```

The Observer interface would be as below:

```java
public interface Observer {
    public void update();
}
```

```java
class Subscriber implements Observer {
    public void update() {
    // get the blog change
        ...
    }
}
```
