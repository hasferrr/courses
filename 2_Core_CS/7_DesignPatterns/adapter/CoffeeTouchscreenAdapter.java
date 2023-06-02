public class CoffeeTouchscreenAdapter implements CoffeeMachineInterface {
    private OldCoffeeMachine machine;

    public CoffeeTouchscreenAdapter(OldCoffeeMachine givenMachine) {
        this.machine = givenMachine;
    }

    public void chooseFirstSelection() {
        machine.selectA();
    }

    public void chooseSecondSelection() {
        machine.selectB();
    }
}
