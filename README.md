# Lucy 

Simple Command Line Interface (CLI) for [Lucifer](https://pub.dev/packages/lucifer) framework.

## Installation

You may activate Lucy CLI by using the following command in your terminal:

```bash
pub global activate lucy
```

## Usage 

### Create New Project

To create a new Lucifer project, you may use the following Lucy command.

```bash
l create <project>
```

For example, you may use `l create` command like so:

```bash
l create desire
```

It will create a new Lucifer project named desire in the `desire` directory.

### Run Project (With Hot Reload)

To run your project, you may use the following command in the root project directory:

```bash
l run
```

### Build Executable 

To compile your app and build an executable, you may use:

```bash
l build
```

It will generate the executable file, ready to be sent to production server, in your root project directory.

### Generate Controller

To generate a controller in your Lucifer project, you may use:

```bash
l c <controller>
```

For example, you may use `l c` command like so:

```bash
l c user
```

It will create a `user_controller.dart` file with class `UserController` in the `lib/controller` directory.

### Generate Repository

To generate a repository in your Lucifer project, you may use:

```bash
l r <repository>
```

For example, you may use `l r` command like so:

```bash
l r user
```

It will create a `user_repository.dart` file with class `UserRepository` in the `lib/repository` directory.

### Create Custom Middleware 

You may use the following command to generate a new custom middleware for your Lucifer project:

```bash
l m <middleware>
```

For example, you may use `l m` command like so:

```bash
l m auth
```

It will create a `auth.dart` file containing an `auth` function to define your custom middleware in the `lib/middleware` directory.