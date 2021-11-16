# Lucy 

Command Line Interface (CLI) for [Lucifer](https://pub.dev/packages/lucifer) framework.

## Installation

Activate command line from your terminal with this command.

```bash
pub global activate lucy
```

## Usage 

Use this command to create a new default lucifer project.

```bash
lucy create <project-name>
```

For example: 

```bash
lucy create desire
```

To run your project, use this command in the root project directory:

```
lucy run
```

To create a new controller in your project, use this command.

```bash
lucy c <controller-name>
```

Example to create `user_controller.dart` with a class `UserController` inside at `bin/controller` directory.

```bash
lucy c user
```

To create a new repository in your project, use this command.

```bash
lucy r <repository-name>
```

Example to create `user_repository.dart` with a class `UserRepository` inside at `bin/repository` directory:

```bash
lucy r user
```