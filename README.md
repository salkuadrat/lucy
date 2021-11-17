# Lucy 

Command Line Interface (CLI) for [Lucifer](https://pub.dev/packages/lucifer) framework.

## Installation

Activate command line from your terminal with this command.

```bash
pub global activate lucy
```

## Usage 

### Create New Project

Use this command to create a new default lucifer project.

```bash
l create <project-name>
```

For example: 

```bash
l create desire
```

### Run Project (With Hot Reload)

To run your project, use this command in the root project directory:

```bash
l run
```

### Build Executable 

To compile your app and build an executable file, you can use this command.

```bash
l build
```

It will generate the executable file in the root project directory.

### Generate Controller

To generate a new controller in your project, use this command.

```bash
l c <controller-name>
```

This example will create `user_controller.dart` with class `UserController` inside at `bin/controller` directory.

```bash
l c user
```

### Generate Repository

To generate a new repository in your project, use this command.

```bash
l r <repository-name>
```

This example will create `user_repository.dart` with class `UserRepository` inside at `bin/repository` directory:

```bash
l r user
```